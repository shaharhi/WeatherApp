//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import Foundation
class WeatherAPI {
    
    static let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"
    static let host = "https://api.openweathermap.org/data/2.5/weather"
    static func getWeatherFor(cityName : String, callback : @escaping ((String?, Info?) -> Void)) {
        let escapedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
        let buildUrl = "\(WeatherAPI.host)?q=\(escapedCity)&appid=\(WeatherAPI.apiKey)&units=\(PlacesManager.shared.unit == 0 ? "imperial" : "metric")"
        let url: URL = URL(string: buildUrl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
               guard error == nil else {
                   return
               }
               guard let data = data else {
                   return
               }
                if let info = try? JSONDecoder().decode(Info.self, from: data){
                    DispatchQueue.main.async {
                        callback(nil,info)
                    }
                    return
                }
                DispatchQueue.main.async {
                    callback("Failed loading information. please try again.",nil)
                }
           })
           task.resume()
    }
}
class Info : Codable {
    var name : String
    var weather : [Weather]
    var main : Main
    var coord : Coord
    var wind : Wind
}
class Coord :Codable{
    var lat : Double
    var lon : Double
}
class Weather : Codable {
    var main : String
    var description : String
}
class Wind : Codable {
    var speed : Double
}
class Main : Codable{
    var temp : Double
    var humidity : Int
}
