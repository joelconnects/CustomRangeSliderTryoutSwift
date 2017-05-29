//
//  ForecastAPI.swift
//  BikeOrNot
//
//  Created by Joel Bell on 5/19/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import Foundation

class ForecastAPI {
    
    class func getLocalWeatherData(_ completion: @escaping (_ results: NSDictionary) -> Void) {
        
        let url = URL(string: "https://api.forecast.io/forecast/fd6c971c5244ead13ee4229060a2af9f/39.8255502,-74.1893672")!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                print(jsonDictionary)
                completion(jsonDictionary)
            } catch {
                print("something went wrong")
            }
        }) .resume()
    }
    
}

