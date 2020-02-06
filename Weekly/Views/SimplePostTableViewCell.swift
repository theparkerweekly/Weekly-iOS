//
//  SimplePostTableViewCell.swift
//  Weekly
//
//  Created by Matthew Turk on 1/22/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit
import SwiftyPress

class SimplePostTableViewCell: UITableViewCell, PostsDataViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
}

extension SimplePostTableViewCell {
    
    func bind(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.date
    }
}
