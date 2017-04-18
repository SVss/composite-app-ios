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
    @IBOutlet weak var weatherMapOutlet: MKMapView!
    
    var refreshControl: UIRefreshControl!
    var showNextView: Bool = true
    
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

    func onScreenRotate() {
        showNextView = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (showNextView) {
            if (segue.identifier == "showDetailWeatherMap") {
                let detailViewController = segue.destination as! FullMapViewController
                let city = weatherModel.getWeather[(self.tableViewOutlet.indexPathForSelectedRow?.row)!]
                detailViewController.setCityIdToShow(city.id)
            }
        }
    }
    
    private func updateWeather() {
        weatherModel.refresh()
    }
}
