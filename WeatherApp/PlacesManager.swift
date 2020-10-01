//
//  PlacesManager.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import Foundation
import MapKit
final class PlacesManager {
    
    static var shared = PlacesManager()
    
    var encoder : JSONEncoder!
    var decoder : JSONDecoder!
    var geocoder : CLGeocoder!
    
    var unit : Int {
        set{
                UserDefaults.standard.set(newValue, forKey: "unit")
                UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.integer(forKey: "unit")
        }
    }
    var selectedPlaces : [Info] {
        set{
            do{
                let encoded = try encoder.encode(newValue)
                UserDefaults.standard.set(encoded, forKey: "selectedPlaces")
                UserDefaults.standard.synchronize()
            }catch{
                print(error)
            }
        }
        get{
            do{
                guard let data = UserDefaults.standard.data(forKey: "selectedPlaces") else { return [Info]() }
                return try decoder.decode(Array<Info>.self, from: data)
            }catch{
                print(error)
            }
            return [Info]()
        }
    }
    
    private init(){
        geocoder = CLGeocoder()
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    func addNewPlace(info : Info){
        var newSelectedPlaces = selectedPlaces
        newSelectedPlaces.append(info)
        selectedPlaces = newSelectedPlaces
    }
    func has(place : String) -> Bool{
        return selectedPlaces.contains(where: {$0.name == place})
    }
    func removePlace(info : Info){
        var newSelectedPlaces = selectedPlaces
        newSelectedPlaces.removeAll(where: {info.name == $0.name})
        selectedPlaces = newSelectedPlaces
    }
    func findPlacemark(lat: Double, lon :Double, callback : @escaping ((CLPlacemark?)-> Void)){
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon)){
            (place, error) in
            guard error == nil else {
                return
            }
            if let firstPlacemark = place?.first {
                callback(firstPlacemark)
            }
        }
    }
}
