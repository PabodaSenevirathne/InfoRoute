//
//  MapViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/8/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var mapSlider: UISlider!
    
    @IBOutlet weak var changeCity: UIButton!
    
    
    var startLocation: CLLocationCoordinate2D? // The original location of the phone
    var destinationLocation: CLLocationCoordinate2D? // The destination location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setTheMap()
    }
    
    // Function to set up the map
    func setTheMap() {
        // Check if both start and destination coordinates are available
        guard let startCoord = startLocation, let destinationCoord = destinationLocation else {
            // Handle the case where either start or destination coordinates are not available
            return
        }
        
        // Create annotations for start and destination points
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoord
        startAnnotation.title = "Start Point"
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationCoord
        destinationAnnotation.title = "Destination Point"
        
        mapView.addAnnotations([startAnnotation, destinationAnnotation])
        
        
        // Create a polyline to show the route
        let coordinates = [startCoord, destinationCoord]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        // Set the region to show both points
        let region = MKCoordinateRegion(center: startCoord, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    @IBAction func changeCity(_ sender: UIButton) {
        changeLocation()
    }
    
    // Function to present an alert for changing the destination location
    func changeLocation() {
        let alertController = UIAlertController(title: "Change Destination Location", message: "Enter a new city or coordinates", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City or Coordinates"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let locationText = alertController?.textFields?.first?.text else {
                return
            }
            // Convert the locationText to coordinates or handle city name
            self?.updateDestinationLocation(locationText)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Function to update the destination location based on user input
    func updateDestinationLocation(_ locationText: String) {
        // Implement logic to convert locationText to coordinates or handle city name
        // Update destinationCoordinate with the new coordinates
        // Call setupMap() to refresh the map with the new destination location
    }
    // MARK: - MKMapViewDelegate
    
    // Function to render overlay (polyline) on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    
    
    
}
