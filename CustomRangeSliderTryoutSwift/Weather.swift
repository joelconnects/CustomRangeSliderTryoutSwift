//
//  Weather.swift
//  BikeOrNot
//
//  Created by Joel Bell on 5/19/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    var temperature: Double
    var cloudCover: Double
    var dewPoint: Double
    var humidity: Double
    var nearestStormDistance: Double
    var precipIntensity: Double
    var precipProbability: Double
    var summary: String
    var windBearing: Double
    var windSpeed: Double
    
    init(conditions: NSDictionary){
        
        let current = conditions["currently"] as! NSDictionary
            
        temperature = current["temperature"] as! Double
        cloudCover = current["cloudCover"] as! Double
        dewPoint = current["dewPoint"] as! Double
        humidity = current["humidity"] as! Double
        nearestStormDistance = current["nearestStormDistance"] as! Double
        precipIntensity = current["precipIntensity"] as! Double
        precipProbability = current["precipProbability"] as! Double
        summary = current["summary"] as! String
        windBearing = current["windBearing"] as! Double
        windSpeed = current["windSpeed"] as! Double
        
    }

}