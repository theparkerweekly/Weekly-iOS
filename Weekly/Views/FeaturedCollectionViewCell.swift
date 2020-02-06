//
//  FeaturedCollectionViewCell.swift
//  Weekly
//
//  Created by Matthew Turk on 1/22/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import SwiftyPress

class FeaturedCollectionViewCell: UICollectionViewCell, PostsDataViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    
}

extension FeaturedCollectionViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setImage(from: model.imageURL)
    }
}
