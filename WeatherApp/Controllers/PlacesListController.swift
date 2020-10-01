//
//  PlacesListController.swift
//  WeatherApp
//
//  Created by Shahar Hillel on 9/30/20.
//

import Foundation
import UIKit
import MapKit
class PlacesListController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    private var tableView : UITableView!
    private var mainTitle : UILabel!
    private var segmentedControl : UISegmentedControl!
    private var places = [Info]()
    override func viewDidLoad() {
        super.viewDidLoad()
        places = PlacesManager.shared.selectedPlaces
        view.backgroundColor = isDarkMode ? .black : .white

        setupSegmentedController()

        mainTitle = UILabel(frame: .zero)
        mainTitle.font = UIFont.boldSystemFont(ofSize: 20)
        mainTitle.text = "Saved places"
        view.activate([mainTitle.start(view.safeAreaLayoutGuide.leadingAnchor,20),mainTitle.top(segmentedControl.bottomAnchor,10)])

        setupList()
    }
    func setupSegmentedController(){
        let items = ["Imperial", "Metric"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = PlacesManager.shared.unit
        view.activate([segmentedControl.centerX(view),segmentedControl.top(view.topAnchor,10)])
        view.addSubview(segmentedControl)
    }
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        PlacesManager.shared.unit = segmentedControl.selectedSegmentIndex
    }
    func setupList(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(PlaceCell.self, forCellReuseIdentifier: "PlaceCell")
        tableView.dataSource = self
        view.activate([tableView.start(view.safeAreaLayoutGuide.leadingAnchor),tableView.end(view.trailingAnchor),
                       tableView.top(mainTitle.bottomAnchor,10),tableView.bottom(view.bottomAnchor)])

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            PlacesManager.shared.removePlace(info: places[indexPath.row])
            places = PlacesManager.shared.selectedPlaces
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        self.dismiss(animated: true){
            PlacesManager.shared.findPlacemark(lat: place.coord.lat, lon: place.coord.lon) { placemark in
                if let place = placemark{
                    if let mainController = UIApplication.shared.windows.first?.rootViewController as? MainController{
                        mainController.showController(for: place)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell",for: indexPath) as! PlaceCell
        cell.place = places[indexPath.row]
        return cell
    }
    class PlaceCell : UITableViewCell{

        var title : UILabel!
        var place : Info!{
            didSet {
                title?.text = "\(place.name)"
            }
        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            title = UILabel(fontSize: 26)
            activate([title.centerY(self),title.start(leadingAnchor,20)])
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

