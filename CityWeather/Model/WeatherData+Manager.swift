//
//  WeatherData.swift
//  CityWeather
//
//  Created by Bioo on 26.08.2020.
//  Copyright © 2020 Bioo. All rights reserved.
//

import Foundation

let apiKey = "20254981fcce06e24c7d2ff0003f7292"

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

protocol WeatherNetworkManager {
    func performRequest(withURLString urlString: String, completion: ((CurrentWeather) -> Void)?)
}

protocol CitiesNetworkManager {
    func loadCities(completion: (Result <[CityData], Error>) -> Void)
}

class NetworkManager {
        
}

extension NetworkManager: WeatherNetworkManager {
    
    func performRequest(withURLString urlString: String, completion: ((CurrentWeather) -> Void)?) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    completion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(weatherData: weatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

extension NetworkManager: CitiesNetworkManager {
    func loadCities(completion: (Result <[CityData], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode([CityData].self, from: data)
                completion(.success(result))

            } catch {

                completion(.failure(error))
            }
        }
    }
}
