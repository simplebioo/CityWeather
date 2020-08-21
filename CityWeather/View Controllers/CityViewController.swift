//
//  CityViewController.swift
//  CityWeather
//
//  Created by Bioo on 21.08.2020.
//  Copyright © 2020 Bioo. All rights reserved.
//

import UIKit
import Kingfisher

class CityViewController: UITableViewController, UISearchResultsUpdating {

    var searchController: UISearchController!
    var filteredData: [CityData] = []
    var city: [CityData] = []
    var selectedCity: CityData?
    let firstIcon = URL(string: "https://infotech.gov.ua/storage/img/Temp3.png")
    let secondIcon = URL(string: "https://infotech.gov.ua/storage/img/Temp1.png")
    let citiesNetworkManager: CitiesNetworkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        citiesNetworkManager.loadCities { [weak self] (result) in
            switch result {
            case .success(let allCity):
                self?.city = allCity
                self?.filteredData = allCity
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        setupSearchController()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCustomCell

        cell.cityLabel?.text = filteredData[indexPath.row].name
        
        var iconUrl: URL? {
            indexPath.row % 2 == 0 ? secondIcon : firstIcon
        }
        
        DispatchQueue.main.async {
            cell.iconView.kf.setImage(with: iconUrl)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedCity = filteredData[indexPath.row]

        if selectedCity != nil {

            performSegue(withIdentifier: "weatherSegue", sender: self)

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let weatherViewController = segue.destination as! WeatherViewController

        weatherViewController.selectedCity = selectedCity

    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? city : city.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        }
        tableView.reloadData()
    }

    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
    }
}








