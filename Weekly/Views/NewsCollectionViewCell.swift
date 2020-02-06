//
//  FeaturesCollectionViewCell.swift
//  Weekly
//
//  Created by Matthew Turk on 1/22/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

class NewsCollectionViewCell: UICollectionViewCell, PostsDataViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var model: PostsDataViewModel?
    private weak var delegate: PostsDataViewDelegate?
}

extension NewsCollectionViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        self.model = model
        
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setImage(from: model.imageURL)
        favoriteButton.isSelected =  model.favorite ?? false
    }
    
    func bind(_ model: PostsDataViewModel, delegate: PostsDataViewDelegate?) {
        self.delegate = delegate
        bind(model)
    }
}

private extension NewsCollectionViewCell {
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let model = model else { return }
        delegate?.postsDataView(toggleFavorite: model)
    }
}
