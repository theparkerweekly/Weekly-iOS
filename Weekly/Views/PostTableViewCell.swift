//
//  PostTableViewCell.swift
//  Weekly
//
//  Created by Matthew Turk on 1/22/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import SwiftyPress

class PostTableViewCell: UITableViewCell, PostsDataViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var featuredImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
}

extension PostTableViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        dateLabel.text = model.date
        featuredImage.setImage(from: model.imageURL)
    }
}
