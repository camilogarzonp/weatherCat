//
//  ViewController.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import UIKit
import CoreLocation


/// Home screen
class ViewController: UIViewController {

    @IBOutlet var currentLocationName: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var locationsWeather = [WeatherAPI]()
    var locationsWeatherData = [Data]()
    
//    MARK: -Vars city cards size
    let width = 165
    let height = 200
    
    let locationManager = CLLocationManager()
//    MARK: - Var API_KEY
    private let API_KEY = "366338160a785ca26b052f816aca8af5"
//    MARK: - Array with the cities to research
    var majorCities : [String] =  ["New york", "Moscu", "Madrid", "roma", "MEDELLIN"]
    
    private let citiesWeatherKey = "citiesWeatherKey"

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
        checkNetwork()
    }
    
    /// Connection checker which will determine whether to call the API or search the data stored in the cell phone
    func checkNetwork(){
        if NetworkMonitor.shared.isConnected {
            self.locationsWeather.removeAll()
            setupLocation()
        } else {
            self.locationsWeather.removeAll()
            getDataPersistense()
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.locationsWeather.count == 0 {
                self.currentLocationName.text = "You're offline"
            }
        }
    }
    
    /// Asks for authorization to obtain the location of the user's device and then asks the delegate for the location of the device
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// Build the request to be sent to the service if you want to check the location obtained by the device's gps
    /// - Parameter coordinates: coordinates obtained by the device, thanks to CoreLocation
    func makeDataRequestWithCoordinates(forCoordinates coordinates: CLLocationCoordinate2D){
        
        let long = coordinates.longitude, lat = coordinates.latitude
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        getDataAPI(forUrl: url, isCurrentLocation: true)
    }
    
    /// Build the request to be sent to the service if you want to consult the name of a city
    /// - Parameter nameCity: City name regardless of spaces
    func makeDataRequestWithNameCity(forNameCity nameCity: String) {
        var cityNameValidated = nameCity.trimmingCharacters(in: .whitespacesAndNewlines)
        cityNameValidated = cityNameValidated.removeExtraSpaces()
        cityNameValidated = cityNameValidated.changeSpacesForPlus()
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityNameValidated)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        getDataAPI(forUrl: url, isCurrentLocation: false)
    }
    
    /// Send the request to the service to bring the data you need
    /// - Parameters:
    ///   - url: url type with which the API will be consulted
    ///   - currentLocation: bool type if true allows assigning the name of the location (city name) to the variable currentLocationName to display it on the screen
    func getDataAPI(forUrl url: URL, isCurrentLocation currentLocation: Bool){
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            guard let data = data, error == nil else { return }
            
            var json: WeatherAPI?
            
            do {
                json = try JSONDecoder().decode(WeatherAPI.self, from: data)
            } catch {
                print("Error: \(error.localizedDescription)\n")
            }
            
            guard let result = json else { return }
            
            if let obj = try? PropertyListEncoder().encode(result) {
                self.locationsWeatherData.append(obj)
                
                UserDefaults.standard.set(locationsWeatherData, forKey: self.citiesWeatherKey)
            }
            
            self.locationsWeather.append(result)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if currentLocation {
                    self.currentLocationName.text = result.name
                }
            }
        }.resume()
    }
    
    /// Get data when device is offline
    func getDataPersistense(){
        var propertyList: WeatherAPI?
        
        if let data = UserDefaults.standard.object(forKey: self.citiesWeatherKey) as? [Data] {
            for data in data {
                
                do {
                    propertyList = try PropertyListDecoder().decode(WeatherAPI.self, from: data)

                    
                } catch {
                    print("Error: \(error.localizedDescription)\n")
                }
                guard let result = propertyList else { return }
                
                self.locationsWeather.append(result)

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.currentLocationName.text = "You're offline"
                }
            }
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        checkNetwork()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        locationManager.stopUpdatingLocation()
        
        self.locationsWeather.removeAll()
        
        UserDefaults.standard.removeObject(forKey: self.citiesWeatherKey)
        
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



