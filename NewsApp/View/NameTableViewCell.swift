//
//  NameTableViewCell.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-28.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
