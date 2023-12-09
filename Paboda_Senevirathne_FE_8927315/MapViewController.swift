//
//  MapViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/8/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var mapSlider: UISlider!
    
    @IBOutlet weak var changeCity: UIButton!
    
    var cityName: String?
    
    var startLocation: CLLocationCoordinate2D? // The original location of the phone
    var destinationLocation: CLLocationCoordinate2D? // The destination location
    
    // Create a CLLocationManager instance
      let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        if let cityName = cityName {
                    // Use the cityName as needed in your MapViewController
                    print("City Name: \(cityName)")
                }
        
            mapView.delegate = self
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        // Set initial slider value and call the function to update map region
                mapSlider.value = 0.5
                sliderChanged(mapSlider)        }
    
    // CLLocationManagerDelegate method to get the current location
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let currentLocation = locations.last?.coordinate else {
               return
           }
           
           // Set the startLocation to the current location
           startLocation = currentLocation
           
           // Stop updating location after the first update
          // locationManager.stopUpdatingLocation()
           
           // Set up the map with both start and destination locations
           setTheMap()
       }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        // Calculate the new span for latitude and longitude based on slider value
                let span = MKCoordinateSpan(latitudeDelta: 180 * Double(sender.value), longitudeDelta: 360 * Double(sender.value))

                // Update the map's region
                let region = MKCoordinateRegion(center: mapView.region.center, span: span)
                mapView.setRegion(region, animated: true)    }
    
    // Function to set up the map
       func setTheMap() {
           // Check if both start and destination coordinates are available
           guard let startCoord = startLocation, let destinationCoord = destinationLocation else {
               // Handle the case where either start or destination coordinates are not available
               return
           }
           
           // Remove existing annotations and overlays
           mapView.removeAnnotations(mapView.annotations)
           mapView.removeOverlays(mapView.overlays)
           
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
    
     @IBAction func changeCity(_ sender: UIButton) {
        changeLocation()
    }
    
    //Function to present an alert for changing the destination location
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
           let geocoder = CLGeocoder()
           
           geocoder.geocodeAddressString(locationText) { [weak self] (placemarks, error) in
               if let error = error {
                   print("Geocoding error: \(error.localizedDescription)")
                   return
               }
               
               guard let placemark = placemarks?.first,
                     let newDestinationLocation = placemark.location?.coordinate else {
                   print("No valid location found.")
                   return
               }
               
               if newDestinationLocation.latitude == 0 || newDestinationLocation.longitude == 0 {
                   print("Invalid coordinates: Latitude or longitude is zero.")
                   return
               }
               
               self?.destinationLocation = newDestinationLocation
               self?.setTheMap() // Refresh the map with the new destination location
           }
       }
    
    
}
