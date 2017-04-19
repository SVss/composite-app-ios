//
//  WeatherTableViewController.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit
import MapKit

class WeatherTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherReloadAsyncDelegate {
    let alertController = UIAlertController(title: "Error", message: "Can't load weather info", preferredStyle: .alert)
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    weak var embededMapController: FullMapViewController? = nil
    weak var fullMapController: FullMapViewController? = nil
    
    var refreshControl: UIRefreshControl!
    var showNextView: Bool = UIDevice.current.orientation.isPortrait
    
    lazy var weatherModel: WeatherModel = WeatherModel.getInstance()

    internal func reloadWeather() {
        tableViewOutlet.reloadData()
        tableViewOutlet.refreshControl?.endRefreshing()
    }

    internal func onError() {
        tableViewOutlet.refreshControl?.endRefreshing()
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(WeatherTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableViewOutlet.refreshControl = self.refreshControl
        
        setDefaultAlertAction()
        
        weatherModel.subscribe(self)
        
        tableViewOutlet.refreshControl?.beginRefreshing()
        updateWeather()
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateWeather()
    }
    
    private func setDefaultAlertAction() {
        let defaultAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(defaultAlertAction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        showNextView = UIDevice.current.orientation.isPortrait
        if showNextView {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        let city = weatherModel.getWeather[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.temperature

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = weatherModel.getWeather[indexPath.row]
        embededMapController?.showCityOnMap(city.id)
        fullMapController?.setCityIdToShow(city.id)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var result = true
        if (identifier == "showDetailWeatherMap") {
            result = showNextView
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailWeatherMap") {
            fullMapController = segue.destination as? FullMapViewController
            let city = weatherModel.getWeather[(self.tableViewOutlet.indexPathForSelectedRow?.row)!]
            fullMapController?.setCityIdToShow(city.id)
            embededMapController?.showCityOnMap(city.id)
        } else if (segue.identifier == "embededMap") {
            embededMapController = segue.destination as? FullMapViewController
        }
    }
    
    private func updateWeather() {
        weatherModel.refresh()
    }
}
