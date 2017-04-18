//
//  City.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import CoreLocation

class City {
    private var _id: Int
    private var _name: String
    private var _temperature: String
    private var _location: CLLocation
    
    public var id: Int {
        get {
            return _id
        }
    }
    
    public var name: String {
        get {
            return _name
        }
    }
    public var temperature: String {
        get {
            return String(_temperature) + " \u{00B0}C"
        }
    }
    public var location: CLLocation {
        get{
            return self._location
        }
    }
    
    init(id: Int, name: String, temperature: String, location: CLLocation) {
        self._id = id
        self._name = name
        self._temperature = temperature
        self._location = location
    }
}
