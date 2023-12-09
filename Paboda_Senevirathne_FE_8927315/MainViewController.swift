//
//  MainViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/9/23.
//

import UIKit



class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showCityAlert(_ sender: UIButton) {
            let alert = UIAlertController(title: "Enter City", message: "Please enter a city name", preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = "City Name"
            }

            // Add three buttons to navigate to different controllers
            let newsAction = UIAlertAction(title: "Show News", style: .default) { [weak self] _ in
                guard let cityName = alert.textFields?.first?.text else {
                    return
                }
                self?.navigateToNewsViewController(cityName)
            }

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

            alert.addAction(newsAction)
            alert.addAction(mapAction)
            alert.addAction(weatherAction)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)
        }
    
    
    
    func navigateToNewsViewController(_ cityName: String) {
            performSegue(withIdentifier: "NewsSegue", sender: cityName)
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
