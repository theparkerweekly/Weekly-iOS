//
//  CategoryDetailTableViewCell.swift
//  Weekly
//
//  Created by Matthew Turk on 1/25/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
