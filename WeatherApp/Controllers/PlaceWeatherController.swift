//
//  PlaceWeatherController.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import UIKit
import MapKit
class PlaceWeatherController : UIViewController, UIGestureRecognizerDelegate {
    
    private var info : Info!
    var placeMark : CLPlacemark!
    internal var mainTitle, subtitle, temperature : UILabel!
    internal var keepPlaceButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = isDarkMode ? .black : .white
        
        mainTitle = UILabel(fontSize: 20)
        temperature = UILabel(fontSize: 80)
        subtitle = UILabel(fontSize: 20)
        subtitle.numberOfLines = 6
        keepPlaceButton = UIButton(frame: .zero)
        keepPlaceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        keepPlaceButton.setTitleColor(isDarkMode ? .white : .black, for: .normal)
        
        view.activate([mainTitle.start(view.safeAreaLayoutGuide.leadingAnchor,20),mainTitle.top(view.topAnchor,20)])
        view.activate([temperature.centerX(view),temperature.top(mainTitle.bottomAnchor,40)])
        view.activate([subtitle.centerX(view),subtitle.top(temperature.bottomAnchor,4)])
        view.activate([keepPlaceButton.centerX(view),keepPlaceButton.top(subtitle.bottomAnchor,20)])
        
        keepPlaceButton.layer.borderWidth = 1
        keepPlaceButton.layer.borderColor = isDarkMode ? UIColor.white.withAlphaComponent(0.7).cgColor : UIColor.black.withAlphaComponent(0.7).cgColor
        keepPlaceButton.layer.cornerRadius = 20
        keepPlaceButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        keepPlaceButton.clicked(self, #selector(keepPlaceClicked))
        keepPlaceButton.setTitle("Add to Saved List", for: UIControl.State.normal)
        
        mainTitle.text = "\(placeMark.locality!), \(placeMark.country!)"
        
        WeatherAPI.getWeatherFor(cityName: placeMark.locality!) { err, receivedInfo in
            guard err == nil else{
                print(err ?? "")
                return
            }
            self.info = receivedInfo
            self.updateInfo()
        }
    }
    @objc private func keepPlaceClicked(_: UITapGestureRecognizer){
        if info != nil{
            PlacesManager.shared.addNewPlace(info: self.info)
            keepPlaceButton.removeFromSuperview()
        }
        
    }
    private func updateInfo(){
        subtitle.text = "\(info.weather.first?.description ?? "") \n\nHumidity: \(info.main.humidity)% \nWind Speed: \(info.wind.speed) \((PlacesManager.shared.unit == 0 ? "mph" : "Meter / Hour"))"
        temperature.text = "\(info.main.temp) \(PlacesManager.shared.unit == 0 ? "°F" : "°C")"
        if PlacesManager.shared.has(place: info.name){
            keepPlaceButton.removeFromSuperview()
        }
    }
}
