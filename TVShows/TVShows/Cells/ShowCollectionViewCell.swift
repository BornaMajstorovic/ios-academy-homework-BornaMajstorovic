//
//  ShowCollectionViewCell.swift
//  TVShows
//
//  Created by Borna on 29/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

class ShowCollectionViewCell: UICollectionViewCell {
    static let IDENTIFIER = "ShowCollectionViewCell"
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
   

    
    func configure(with showObject:Show) {
        titleLabel.text = showObject.title
        showImage.kf.setImage(with: showObject.fullImageUrl)
    }
}
