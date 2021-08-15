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
    }
    
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
