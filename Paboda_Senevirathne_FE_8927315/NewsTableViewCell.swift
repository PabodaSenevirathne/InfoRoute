//
//  NewsTableViewCell.swift
//  Paboda_Senevirathne_FE_8927315
//
//  Created by user234693 on 12/8/23.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subtitle: String
    
    
    init(title: String, subtitle: String, imageData: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        
    }
}
class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight:.semibold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight:.light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 20, height: contentView.frame.size.height / 2)
            
            subTitleLabel.frame = CGRect(x: 10, y: contentView.frame.size.height / 2, width: contentView.frame.size.width - 20, height: contentView.frame.size.height / 2)   }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        
        
    }
}
