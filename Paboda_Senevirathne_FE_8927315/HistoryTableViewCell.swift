//
//  HistoryTableViewCell.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/11/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    // Add other outlets for displaying specific information

    func configure(with historyItem: SearchHistoryItem) {
        sourceLabel.text = historyItem.source
        typeLabel.text = historyItem.type
        // Configure other UI elements based on your data model
    }
}
