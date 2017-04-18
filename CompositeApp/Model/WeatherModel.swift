//
//  WeatherModel.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherModel {
    private var delegates: [WeatherReloadAsyncDelegate] = [WeatherReloadAsyncDelegate]();
    private var _cities: [City] = []
    private var _refreshing: Bool = false
    
    private static var _instance: WeatherModel = WeatherModel()
    
    private init() {
        
    }
    
    public static func getInstance() -> WeatherModel {
        return _instance
    }
    
    public var getWeather: [City] {
        return _cities
    }
    
    public var count: Int {
        return _cities.count
    }
    
    let YQUERY = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition.temp%2C%20wind.direction%2C%20wind.speed%2C%20item.lat%2C%20item.long%2C%20location.city%20from%20weather.forecast%20where%20woeid%20in(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22Minsk%2C%20BY%22%20or%20text%3D%22Dubrovno%2C%20BY%22%20or%20text%3D%22Orsha%2C%20BY%22%20or%20text%3D%22Baran'%2C%20BY%22%20or%20text%3D%22Mahilyow%2C%20BY%22%20or%20text%3D%22Bobruysk%2C%20BY%22%20or%20text%3D%22Osipovichi%2C%20BY%22%20or%20text%3D%22Kopyl'%2C%20BY%22%20or%20text%3D%22Nesvizh%2C%20BY%22%20or%20text%3D%22Mir%2C%20BY%22%20or%20text%3D%22Navahrudak%2C%20BY%22%20or%20text%3D%22Slonim%2C%20BY%22%20or%20text%3D%22Pruzhany%2C%20BY%22%20or%20text%3D%22Brest%2C%20BY%22%20or%20text%3D%22Vileyka%2C%20BY%22%20or%20text%3D%22Pinsk%2C%20BY%22%20or%20text%3D%22Baranavichy%2C%20BY%22%20or%20text%3D%22Navapolatsk%2C%20BY%22%20or%20text%3D%22Vitsyebsk%2C%20BY%22%20or%20text%3D%22Homyel'%2C%20BY%22%20or%20text%3D%22Barysaw%2C%20BY%22)%20and%20u%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    public func subscribe(_ delegate: WeatherReloadAsyncDelegate) {
        self.delegates.append(delegate)
    }
    
    public func refresh() {
        if _refreshing {
            return
        }
        _refreshing = true
//        print("*** Start refreshing weather")
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(YQUERY, encoding: URLEncoding.queryString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
//                 print(value)
                 self._cities = [City]()
                 self.invokeReloadWeather()
                 let json = JSON(value)
                 let cities = json["query"]["results"]["channel"]
                 var id: Int = 0
                 for (_,subJson):(String, JSON) in cities {
                    id += 1
                    if let cityName = subJson["location"]["city"].string,
                        let temperature = subJson["item"]["condition"]["temp"].string,
                        let lat = Double(subJson["item"]["lat"].string!),
                        let long = Double(subJson["item"]["long"].string!)
                    {
                        let location = CLLocation(latitude: lat, longitude: long)
                        let newWeatherItem = City(id: id, name: cityName, temperature: temperature, location: location)
                        self._cities.append(newWeatherItem)
                        self.invokeReloadWeather()
//                        print(cityName, temperature, location.coordinate.latitude, location.coordinate.longitude)
                    } else {
//                        print("Invalid response format")
                        self.invokeOnError()
                        break
                    }
                }
            case .failure:
//                print("Can't load weather info")
                self.invokeOnError()
            }
            self._refreshing = false
        }
    }
    
    private func invokeReloadWeather() {
        for delegate in delegates {
            delegate.reloadWeather()
        }
    }
    
    private func invokeOnError() {
        for delegate in delegates {
            delegate.onError()
        }
    }
}


protocol WeatherReloadAsyncDelegate {
    func reloadWeather()
    func onError()
}
