//
//  TrendingCellTableViewCell.swift
//  Moonshot
//
//  Created by Matthew Lock on 07/02/2022.
//

import UIKit

class TrendingCellTableViewCell: UITableViewCell {

    static let reuseidentifier = "TrendingCell"
    
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet var coinTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
