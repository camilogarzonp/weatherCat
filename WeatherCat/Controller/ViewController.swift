//
//  ViewController.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var currentLocationName: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var locationsWeather = [WeatherAPI]()
    
    let width = 165
    let height = 200
    
    let locationManager = CLLocationManager()
    private let API_KEY = "366338160a785ca26b052f816aca8af5"
    var majorCities : [String] =  ["New york", "Moscu", "Madrid", "roma", "MEDELLIN"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: width, height: height)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(CityCardCollectionViewCell.nib(), forCellWithReuseIdentifier: CityCardCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func makeDataRequestWithCoordinates(forCoordinates coordinates: CLLocationCoordinate2D){
        
        let long = coordinates.longitude, lat = coordinates.latitude
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var json: WeatherAPI?
            
            do {
                json = try JSONDecoder().decode(WeatherAPI.self, from: data)
            } catch {
                print("Error: \(error.localizedDescription)\n")
            }
            
            guard let result = json else { return }
            
            self.locationsWeather.append(result)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.currentLocationName.text = result.name
            }
        }.resume()
    }
    
    func makeDataRequestWithNameCity(forNameCity nameCity: String) {
        var cityNameValidated = nameCity.trimmingCharacters(in: .whitespacesAndNewlines)
        cityNameValidated = cityNameValidated.removeExtraSpaces()
        cityNameValidated = cityNameValidated.changeSpacesForPlus()
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityNameValidated)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var json: WeatherAPI?
            
            do {
                json = try JSONDecoder().decode(WeatherAPI.self, from: data)
            } catch {
                print("\nError: \(error.localizedDescription)\n")
            }
            
            guard let result = json else { return }
            
            self.locationsWeather.append(result)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        locationManager.stopUpdatingLocation()
        
        self.locationsWeather.removeAll()
        
        makeDataRequestWithCoordinates(forCoordinates: location.coordinate)
        
        for city in majorCities {
            makeDataRequestWithNameCity(forNameCity: city)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
//    MARK: - Función cuando el usuario hace click a una tarjeta (cell) de una ciudad y navega hacia el DatailView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(identifier: DetailViewController.identifier) as! DetailViewController
        desVC.nameCity = locationsWeather[indexPath.row].name
        desVC.descriptionWeather = locationsWeather[indexPath.row].weather.first!.description
        desVC.localTime = locationsWeather[indexPath.row].timezone
        desVC.temp = locationsWeather[indexPath.row].main.temp
        desVC.feelsLike = locationsWeather[indexPath.row].main.feels_like
        desVC.tempMin = locationsWeather[indexPath.row].main.temp_min
        desVC.tempMax = locationsWeather[indexPath.row].main.temp_max
        desVC.windSpeed = locationsWeather[indexPath.row].wind.speed
        guard let icon = locationsWeather[indexPath.row].weather.first?.main else { return }
        desVC.icon = icon
        self.navigationController?.pushViewController(desVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCardCollectionViewCell.identifier, for: indexPath) as! CityCardCollectionViewCell
        
        cell.configure(with: locationsWeather[indexPath.row])
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
