//
//  DetailViewController.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var nameCityLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var descriptionWeatherLabel: UILabel!
    @IBOutlet var localTimeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    
    var nameCity = String()
    var icon = String()
    var descriptionWeather = String()
    var localTime = Int()
    var temp = Double()
    var feelsLike = Double()
    var tempMin = Double()
    var tempMax = Double()
    var windSpeed = Double()
    
    static let identifier = "DetailViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        nameCityLabel.text = nameCity
        descriptionWeatherLabel.text = descriptionWeather
        
        localTimeLabel.text = getHourForTimeZone(forTimeZone: localTime)
        
        tempLabel.text = "\(temp)º"
        feelsLikeLabel.text = "\(feelsLike)º"
        tempMinLabel.text = "\(tempMin)º"
        tempMaxLabel.text = "\(tempMax)º"
        windSpeedLabel.text = "\(windSpeed) m/s"
        if icon.lowercased() == "clear" {
            self.weatherIcon.image = UIImage(systemName: "sun.max.fill")
            self.weatherIcon.tintColor = .yellow
        } else if icon.lowercased() == "clouds" {
            self.weatherIcon.image = UIImage(systemName: "cloud.fill")
            self.weatherIcon.tintColor = .gray
        } else if icon.lowercased() == "rain" {
            self.weatherIcon.image = UIImage(systemName: "cloud.heavyrain.fill")
            self.weatherIcon.tintColor = .blue
        } else if icon.lowercased() == "thunderstorm" {
            self.weatherIcon.image = UIImage(systemName: "cloud.bolt.rain.fill")
            self.weatherIcon.tintColor = .blue
        }
    }
    
    /// This method determines the current time in another region depending on your time zone
    /// - Parameter timeZone: Time zone in seconds
    /// - Returns: Returns the time in HH: mm format as a string
    func getHourForTimeZone (forTimeZone timeZone: Int?) -> String {
        guard let GMT = timeZone else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: GMT) as TimeZone
        
        return dateFormatter.string(from: Date())
    }

}
