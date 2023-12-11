//
//  HistoryTableViewController.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/10/23.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var searchHistory: [SearchHistoryItem] = []
    
    lazy var context: NSManagedObjectContext = {
            return CoreDataStack.shared.context
        }()
    
    override func viewDidLoad() {
        title = "Search History"
        super.viewDidLoad()
        
        // Register the cell class for the reuse identifier
            tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        fetchSearchHistory()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return searchHistory.count    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let historyItem = searchHistory[indexPath.row]

            // Customize the cell based on the interaction type
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

            if let interactionType = historyItem.type {
                switch interactionType {
                case "News":
                    cell.textLabel?.text = historyItem.type
                    // Customize cell further if needed
                case "Weather":
                    cell.textLabel?.text = historyItem.type
                case "Map":
                    cell.textLabel?.text = "Map Interaction: \(historyItem.mapStartPoint ?? "") to \(historyItem.mapEndPoint ?? "")"
                    // Customize cell further if needed
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
