//
//  NameWithImageTableViewCell.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-04-14.
//

import UIKit

class NameWithImageTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var theImageView: UIImageView? //Getter for 'imageView' with Objective-C selector 'imageView' conflicts with getter for 'imageView' from superclass 'UITableViewCell' with the same Objective-C selector...
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
