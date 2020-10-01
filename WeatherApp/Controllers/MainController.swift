//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import UIKit
import MapKit

class MainController: UIViewController, UIGestureRecognizerDelegate{

    private var mapView: MKMapView!
    private var iconsStack : UIStackView!
    private var listIcon,helpIcon : UIImageView!
    private var shownAnnotation : MKPointAnnotation!
    private var geocoder : CLGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geocoder = CLGeocoder()
        mapView = MKMapView(frame: CGRect.zero)
        listIcon = UIImageView(image:UIImage(named: "list"))
        helpIcon = UIImageView(image:UIImage(named: "information"))
        
        iconsStack = UIStackView(arrangedSubviews: [helpIcon,listIcon])
        iconsStack.activate([listIcon.height(60),listIcon.width(60)])
        iconsStack.activate([helpIcon.height(60),helpIcon.width(60)])
        
        view.activate([mapView.start(view.leadingAnchor),
                       mapView.end(view.trailingAnchor),
                       mapView.top(view.topAnchor),
                       mapView.bottom(view.bottomAnchor)])
        view.activate([iconsStack.bottom(view.safeAreaLayoutGuide.bottomAnchor,-20),iconsStack.end(view.trailingAnchor, -20)])
        iconsStack.axis = .horizontal
        iconsStack.spacing = 10
        
        mapView.clicked(self, #selector(handleClick))
        listIcon.clicked(self, #selector(handleListClick))
        helpIcon.clicked(self, #selector(handleHelpClicked))
    }
    @objc func handleHelpClicked(gestureRecognizer : UITapGestureRecognizer){
        self.present(HelpController(), animated: true, completion: nil)
    }
    @objc func handleListClick(gestureRecognizer: UITapGestureRecognizer) {
        self.present(PlacesListController(), animated: true, completion: nil)
    }
    @objc func handleClick(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        if shownAnnotation == nil {
            shownAnnotation = MKPointAnnotation()
            mapView.addAnnotation(shownAnnotation)
        }
        shownAnnotation.coordinate = coordinate
        PlacesManager.shared.findPlacemark(lat: coordinate.latitude, lon: coordinate.longitude){ placemark in
            if let place = placemark{
                self.showController(for: place,fromClick: true)
                return
            }
            self.showError()
        }
    }
    func showController(for place: CLPlacemark,fromClick : Bool = false){
        let region = MKCoordinateRegion(center: place.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        mapView.setRegion(region, animated: true)
        if shownAnnotation == nil {
            shownAnnotation = MKPointAnnotation()
            mapView.addAnnotation(shownAnnotation)
        }
        shownAnnotation.coordinate = region.center

        DispatchQueue.main.asyncAfter(deadline: .now() + (fromClick ? 0 : 1)){
            guard place.locality != nil else {
                self.showError("Couldn't find weather for the area")
                return
            }
            if place.locality != nil{
                let placeViewController = PlaceWeatherController()
                placeViewController.placeMark = place
                placeViewController.modalPresentationStyle = .popover
                placeViewController.popoverPresentationController?.sourceView = self.view
                placeViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                self.present(placeViewController, animated: true, completion: nil)
                return
            }
        }
    }
    func showError(_ errorMsg : String = "Something went wrong, please try again"){
        let dialog = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
        dialog.popoverPresentationController?.sourceView = self.view
        dialog.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                    (UIAlertAction) -> Void in
        }
        dialog.addAction(action)
        present(dialog, animated: true){ () -> Void in
        }
    }
}

