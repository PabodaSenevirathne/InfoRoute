//
//  HistoryTableViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/10/23.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    // Array to store search history items
    var searchHistory: [SearchHistoryItem] = []
    
    lazy var context: NSManagedObjectContext = {
            return CoreDataStack.shared.context
        }()
    
    override func viewDidLoad() {
        title = "Search History"
        super.viewDidLoad()
        
        // Register the cell class for the reuse identifier
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        
        // Function to fetch search history
        fetchSearchHistory()
    }
    
    // Fetch search history
    func fetchSearchHistory() {
            let fetchRequest: NSFetchRequest<SearchHistoryItem> = SearchHistoryItem.fetchRequest()
            do {
                searchHistory = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch {
                print("Error fetching search history: \(error.localizedDescription)")
            }
        }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let historyItem = searchHistory[indexPath.row]

            // Customize the cell based on the interaction type
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

            if let interactionType = historyItem.type {
                switch interactionType {
                case "News":
                    cell.textLabel?.text = historyItem.type
                case "Weather":
                    cell.textLabel?.text = historyItem.type
                case "Map":
                    cell.textLabel?.text = "Map Interaction: \(historyItem.mapStartPoint ?? "") to \(historyItem.mapEndPoint ?? "")"
                default:
                    cell.textLabel?.text = "Unknown Interaction Type"
                }
            }

            return cell
        }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 100
    }
    
    // MARK: - Table view delegate

    // Delete a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                let deletedItem = searchHistory.remove(at: indexPath.row)
                context.delete(deletedItem)

                do {
                    try context.save()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("Error deleting item: \(error.localizedDescription)")
                }
            }
        }
}
