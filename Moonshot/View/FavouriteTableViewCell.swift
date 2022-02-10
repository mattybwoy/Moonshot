//
//  FavouriteTableViewCell.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/02/2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    static let reuseidentifier = "WatchlistCell"
    
    @IBOutlet var thumbNail: UIImageView!
    @IBOutlet var coinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
