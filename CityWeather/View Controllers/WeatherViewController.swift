//
//  WeatherViewController.swift
//  CityWeather
//
//  Created by Bioo on 25.08.2020.
//  Copyright © 2020 Bioo. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!

    var selectedCity: CityData!
    let networkWeatherManager: WeatherNetworkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.isHidden = true
        temperatureLabel.isHidden = true
        minTempLabel.isHidden = true
        humidityLabel.isHidden = true
        windLabel.isHidden = true
        
        networkWeatherManager.performRequest(withURLString: "https://api.openweathermap.org/data/2.5/weather?lat=\(selectedCity.coord.lat)&lon=\(selectedCity.coord.lon)&apikey=\(apiKey)&units=metric") { [weak self] (currentWeather) in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        navigationItem.title = selectedCity.name
        updateMap()
    }

    func updateMap() {
        let center = CLLocationCoordinate2D(latitude: selectedCity.coord.lat, longitude: selectedCity.coord.lon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
    }

    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            if self.descriptionLabel.isHidden == true {
                self.descriptionLabel.text = weather.weatherDescription
                self.descriptionLabel.isHidden = false
            }
            if self.temperatureLabel.isHidden == true {
                self.temperatureLabel.text = weather.temperatureString
                self.temperatureLabel.isHidden = false
            }
            if self.minTempLabel.isHidden == true {
                self.minTempLabel.text = weather.temperatureMinString
                self.minTempLabel.isHidden = false
            }
            if self.humidityLabel.isHidden == true {
                self.humidityLabel.text = weather.humidityString
                self.humidityLabel.isHidden = false
            }
            if self.windLabel.isHidden == true {
                self.windLabel.text = weather.windString
                self.windLabel.isHidden = false
            }
        }
    }
}



