//
//  MainViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/9/23.
//

import UIKit



class MainViewController: UIViewController {
    
    @IBOutlet weak var showPages: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func showPages(_ sender: UIButton) {
        showCityAlert()
    }
    
    func showCityAlert() {
            let alert = UIAlertController(title: "Enter City", message: "Please enter a city name", preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = "City Name"
            }

            // Add three buttons to navigate to different controllers
            let mapAction = UIAlertAction(title: "Show Map", style: .default) { [weak self] _ in
                guard let cityName = alert.textFields?.first?.text else {
                    return
                }
                self?.navigateToMapViewController(cityName)
            }

            let weatherAction = UIAlertAction(title: "Show Weather", style: .default) { [weak self] _ in
                guard let cityName = alert.textFields?.first?.text else {
                    return
                }
                self?.navigateToWeatherViewController(cityName)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(mapAction)
            alert.addAction(weatherAction)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)
        }
    
    
        func navigateToMapViewController(_ cityName: String) {
            performSegue(withIdentifier: "MapSegue", sender: cityName)
        }

        func navigateToWeatherViewController(_ cityName: String) {
            performSegue(withIdentifier: "WeatherSegue", sender: cityName)
        }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let cityName = sender as? String {
                switch segue.identifier {
                case "MapSegue":
                    if let mapViewController = segue.destination as? MapViewController {
                        mapViewController.cityName = cityName
                    }
                case "WeatherSegue":
                    if let weatherViewController = segue.destination as? WeatherViewController {
                       weatherViewController.cityName = cityName
            
                    }
                default:
                    break
                }
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
