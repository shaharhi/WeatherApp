//
//  HelpScreen.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 10/1/20.
//

import UIKit
import WebKit

class HelpController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        view.activate([webView.start(view.leadingAnchor),webView.end(view.trailingAnchor),
                       webView.top(view.topAnchor),webView.bottom(view.bottomAnchor)])
        let info = """
        
        </br></br>
        <h1> Help Section </h1>

        <p> Welcome to The Weather App. here you will be able to look throught he map of the world and click a location to find out the current weather in the location. you may also click the button to keep the location in your "Saved places" list. you can access the "Saved places" list by click the bottom list icon in the main screen. </p>

        <h2> Gestures </h2>
        <p>Within the "Saved places" screen, you will be able to swipe left to delete and remove an item. you can also change the metric unit being used to receive the information from the API.</p>

        <p>The app is using OpenWeatherMap.org API</p>

        """
        webView.loadHTMLString(info, baseURL: nil)
    }
}