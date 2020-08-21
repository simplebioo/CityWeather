//
//  Weather.swift
//  CityWeather
//
//  Created by Bioo on 26.08.2020.
//  Copyright © 2020 Bioo. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let weatherDescription: String

    let temperature: Double
    var temperatureString: String {
        return String(format: "Temperature: %.0f °C", temperature)
    }

    let temperatureMin: Double
    var temperatureMinString: String {
        return String(format: "Temperature min-max: %.0f-%.0f °C", temperatureMin, temperatureMax)
    }

    let temperatureMax: Double

    let humidity: Double
    var humidityString: String {
        return String(format: "Humidity: %.0f %", humidity)
    }

    let wind: Double
    var windString: String {
        return String(format: "Wind: %.0f km/h.", wind)
    }

    init?(weatherData: WeatherData) {
        weatherDescription = weatherData.weather.first?.description ?? ""
        temperature = weatherData.main.temp
        temperatureMin = weatherData.main.tempMin
        temperatureMax = weatherData.main.tempMax
        humidity = weatherData.main.humidity
        wind = weatherData.wind.speed
    }
}
