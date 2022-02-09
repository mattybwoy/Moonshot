//
//  SearchTableViewCell.swift
//  Moonshot
//
//  Created by Matthew Lock on 09/02/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let reuseidentifier = "SearchCoinCell"

    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var thumbNail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
