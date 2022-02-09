//
//  SearchTableViewCell.swift
//  Moonshot
//
//  Created by Matthew Lock on 09/02/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let reuseidentifier = "SearchTableCell"
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var thumbNail: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
        contentView.addSubview(thumbNail)
        contentView.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        thumbNail.frame = CGRect(x: 13, y: 9, width: 25, height: 25)
        title.frame = CGRect(x: 60, y: 13, width: 300, height: 20)
    }
    
    
}
