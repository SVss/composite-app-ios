//
//  FullMapViewController.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit
import MapKit

class FullMapViewController: UIViewController, WeatherReloadAsyncDelegate {
    
    let alertController = UIAlertController(title: "Error", message: "Can't load weather info", preferredStyle: .alert)
    let weatherModel = WeatherModel.getInstance()
    var cityAnnotations = [CityAnnotation]()
    var idToShow: Int?
    
    @IBOutlet weak var FullMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultAlertAction()
        weatherModel.subscribe(self)
        reloadWeather()
        showCityOnMap(idToShow)
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

    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
//            print("long press began!")
            
            let locationPoint = sender.location(in: FullMapView)
            let location = FullMapView.convert(locationPoint, toCoordinateFrom: FullMapView)
            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            var minDist = CLLocationDistance(Int.max)
            var nearestCity: CityAnnotation? = nil
            for city in cityAnnotations {
                let dist = currentLocation.distance(from: city.location)
                if (dist < minDist) {
//                    print("next min: ")
//                    print(city.latitude, city.longitude)
                    minDist = dist
                    nearestCity = city
                }
            }
            
            if (nearestCity != nil) {
                showCityOnMap(nearestCity!.id!)
            }
        }
    }
    
    func setCityIdToShow(_ id: Int) {
        idToShow = id
    }
    
    func showCityOnMap(_ id: Int?) {
        if let cityIndex = cityAnnotations.index(where: { $0.id == id }) {
            let city = cityAnnotations[cityIndex]
            FullMapView.selectAnnotation(city, animated: true)
            let region = MKCoordinateRegionMake(city.coordinate, MKCoordinateSpanMake(1, 1))
            FullMapView.setRegion(region, animated: true)
        } else {
            print("City not found")
        }
    }
    
    // WeatherReloadAsyncDelegate
    
    internal func reloadWeather() {
        FullMapView.removeAnnotations(cityAnnotations)
        cityAnnotations = [CityAnnotation]()
        for city in weatherModel.getWeather {
//            print(city.id)
            let cityAnnotation = CityAnnotation(city)
            cityAnnotations.append(cityAnnotation)
            FullMapView.addAnnotation(cityAnnotation)
        }
    }
    
    internal func onError() {
        present(alertController, animated: true, completion: nil)
    }
}
