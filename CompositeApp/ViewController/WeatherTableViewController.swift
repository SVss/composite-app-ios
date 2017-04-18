//
//  WeatherTableViewController.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit
import MapKit

class WeatherTableViewController: UITableViewController, WeatherReloadAsyncDelegate {
    let alertController = UIAlertController(title: "Error", message: "Can't load weather info", preferredStyle: .alert)
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var weatherMapOutlet: MKMapView!
    lazy var weatherModel: WeatherModel = WeatherModel.getInstance()

    internal func reloadWeather() {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    internal func onError() {
        self.refreshControl?.endRefreshing()
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(WeatherTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        setDefaultAlertAction()
        
        weatherModel.subscribe(self)
        
        self.refreshControl?.beginRefreshing()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        let city = weatherModel.getWeather[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.temperature

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailWeatherMap") {
            let detailViewController = segue.destination as! FullMapViewController
            let city = weatherModel.getWeather[(self.tableView.indexPathForSelectedRow?.row)!]
            detailViewController.setCityIdToShow(city.id)
        }
    }
    
    private func updateWeather() {
        weatherModel.refresh()
    }
}
