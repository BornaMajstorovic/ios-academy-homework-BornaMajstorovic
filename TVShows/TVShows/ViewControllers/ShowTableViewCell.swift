//
//  ShowTableViewCell.swift
//  TVShows
//
//  Created by Borna on 21/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire

class ShowTableViewCell: UITableViewCell {
    static let IDENTIFIER = "ShowTableViewCell"
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    func configure(with showObject:Show) {
        titleLabel.text = showObject.title
        likeCountLabel.text = "\(showObject.likesCount)"
    }
}
