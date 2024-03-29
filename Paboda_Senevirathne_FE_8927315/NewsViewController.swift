//
//  NewsViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/8/23.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    
    // Property to store the received city name
    var cityName: String?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            title = "Local News"
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeCity))
            
            API.shared.getTopStories{[weak self] result in
                switch result{
                case .success(let articles):
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title,
                            subtitle: $0.description ?? "No Description",
                            author: $0.author ?? "No Author")
                    })
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case.failure(let error):
                    print(error)
                }
                                     
            }
            
            // Save Data
            let context = CoreDataStack.shared.context
                    let searchItem = SearchHistoryItem(context: context)
                    searchItem.source = "News"
                    searchItem.type = "News"
                    searchItem.newsTitle = "First story: \(title)"
                    CoreDataStack.shared.saveContext()
            
        }
        
        // Function to change city
        @objc private func changeCity(){
            let alertController = UIAlertController(title: "Change City", message: "Enter a new city name", preferredStyle: .alert)

                alertController.addTextField { textField in
                    textField.placeholder = "City Name"
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
                    guard let cityName = alertController?.textFields?.first?.text else {
                        return
                }
                
                // Use the new city name and update the data
                //self?.cityName = cityName
                //self?.fetchNewsForCity(cityName)
            }

            alertController.addAction(cancelAction)
            alertController.addAction(submitAction)

            present(alertController, animated: true, completion: nil)    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in data source
        return viewModels.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Dequeue a reusable cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath
            ) as? NewsTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Set height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 200
    }
}
