//
//  Model.swift
//  CityWeather
//
//  Created by Bioo on 21.08.2020.
//  Copyright © 2020 Bioo. All rights reserved.
//

import Foundation

struct CityData: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coord
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

