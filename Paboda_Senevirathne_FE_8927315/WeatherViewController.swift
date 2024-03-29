//
//  WeatherViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/7/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var humidityLevelLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var changeCityButton: UIButton!
    
    var cityName: String?
    // CLLocationManager instance
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityName = cityName {
            // Use the cityName cames from the MainViewController
            print("City Name: \(cityName)")
            getWeatherForCity(cityName)
        }
        
        // save data
        let context = CoreDataStack.shared.context
                let searchItem = SearchHistoryItem(context: context)
                searchItem.source = "Weather"
                searchItem.type = "Weather"
                searchItem.cityName = "Weather: \(cityName)"
                CoreDataStack.shared.saveContext()    }
    
    // Get new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
          return
    }
            
        // Stop updating location
        locationManager.stopUpdatingLocation()
            
        // get weather data based on the current location
        getWeatherAPI(for: location.coordinate)
        
        }
    
    // print error message if there is an error obtaining location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Error getting location: \(error.localizedDescription)")
        
    }
    
    // function to change city
    @IBAction func changeCity(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Change City", message: "Enter a new city name", preferredStyle: .alert)

                alertController.addTextField { textField in
                    textField.placeholder = "City"
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
                    guard let cityName = alertController?.textFields?.first?.text else {
                        return
                    }
                    self?.getWeatherForCity(cityName)
                }

                alertController.addAction(cancelAction)
                alertController.addAction(submitAction)

                present(alertController, animated: true, completion: nil)    }
    
    // get weather according to the city
    func getWeatherForCity(_ city: String) {
            guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Error encoding city name")
                return
            }

            let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=b822db056acf7f212fae8acc4a13a245")

            guard let url = apiUrl else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()

                    do {
                        let weatherData = try jsonDecoder.decode(Weather.self, from: data)

                        DispatchQueue.main.async {
                            self.updateWeatherData(with: weatherData)
                        }

                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }

            task.resume()
        }
    
    // get weather data
    func getWeatherAPI(for coordinates: CLLocationCoordinate2D){
                
        let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=b822db056acf7f212fae8acc4a13a245")
        
        guard let url = apiUrl else {
            print("Invalid URL")
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
                        
            if let data = data {
                let jsonDecorder = JSONDecoder()
                
                do{
                    let jsonData = try jsonDecorder.decode(Weather.self, from: data)
                    print(jsonData.name)
                    print(jsonData.coord)
                    
                    DispatchQueue.main.async {
                        self.updateWeatherData(with: jsonData)
                    }
                    
                } catch{
                    
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    
    }
    
    // update weather data in the UI
    func updateWeatherData(with weatherData: Weather) {
        city.text = "\(weatherData.name)"
        //weatherDescription.text = "\(weatherData.weather.first?.description ?? "")"
        if let description = weatherData.weather.first?.description {
               // Capitalize the first letter of the weather description
               let FormattedDescription = description.prefix(1).capitalized + description.dropFirst()
            weatherDescription.text = "\(FormattedDescription)"
           } else {
               weatherDescription.text = "N/A"
           }
        
        // Convert Kelvin to Celsius
        temperatureLabel.text = "\(Int(weatherData.main.temp - 273.15))°"
        humidityLevelLabel.text = "\(Int(weatherData.main.humidity))%"
        windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
        
        // Load image
        if let iconName = weatherData.weather.first?.icon {
            loadImageURL(iconName)
               }
    }
    
    // Load image from the URL
    func loadImageURL(_ iconName: String) {
        let imageUrl = URL(string: "https://openweathermap.org/img/w/\(iconName).png")
        
        if let imageUrl = imageUrl {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherIcon.image = image
                    }
                }
            }
            
            task.resume()
        }
    }
}
