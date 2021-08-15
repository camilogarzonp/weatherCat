//
//  CityCardCollectionViewCell.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import UIKit

class CityCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameCityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var temMinLabel: UILabel!
    @IBOutlet var temMaxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static let identifier = "CityCardCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CityCardCollectionViewCell", bundle: nil)
    }
    
    func configure(with model: WeatherAPI) {
        self.tempLabel.text = "\(model.main.temp)º"
        self.temMinLabel.text = "\(model.main.temp_min)º"
        self.temMaxLabel.text = "\(model.main.temp_max)º"
        self.nameCityLabel.text = "\(model.name)"
        self.descriptionLabel.text = "\(model.weather.first?.description ?? "")"
        self.iconView.contentMode = .scaleAspectFit
        
        let summary = model.weather.first?.main.lowercased()
        
        if summary == "clear" {
            self.iconView.image = UIImage(systemName: "sun.max.fill")
            self.iconView.tintColor = .yellow
        } else if summary == "clouds" {
            self.iconView.image = UIImage(systemName: "cloud.fill")
            self.iconView.tintColor = .gray
        } else if summary == "rain" {
            self.iconView.image = UIImage(systemName: "cloud.heavyrain.fill")
            self.iconView.tintColor = .blue
        } else if summary == "thunderstorm" {
            self.iconView.image = UIImage(systemName: "cloud.bolt.rain.fill")
            self.iconView.tintColor = .blue
        }
    }
}
