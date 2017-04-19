//
//  CityAnnotation.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    var id: Int?
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    init(_ city: City) {
        self.id = city.id
        self.title = city.name
        self.subtitle = city.temperature
        self.latitude = city.location.coordinate.latitude
        self.longitude = city.location.coordinate.longitude
    }
    
    public func update(_ city: City) {
        if (city.id == self.id) {
            self.title = city.name
            self.subtitle = city.temperature
        }
    }
}
