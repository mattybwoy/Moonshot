//
//  TrendingCellTableViewCell.swift
//  Moonshot
//
//  Created by Matthew Lock on 07/02/2022.
//

import UIKit

class TrendingCellTableViewCell: UITableViewCell {

    static let reuseidentifier = "TrendingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        view?.addSubview(title)
//        view.addSubview(thumbNail)
        // Configure the view for the selected state
    }
    
    lazy var title: UILabel = {
        let label = UILabel(frame: CGRect(x: 40, y: 25, width: 40, height: 15))
        label.center = CGPoint(x: 50, y: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.font = UIFont(name: "Astrolab", size: 10)
        return label
    }()
    
    lazy var thumbNail: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 25, width: 15, height: 15))
        image.center = CGPoint(x: 20, y: 20)
        return image
    }()
    
}
