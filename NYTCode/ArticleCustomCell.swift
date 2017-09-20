//
//  ArticleCustomCell.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/19/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit

class ArticleCustomCell: UITableViewCell {

    @IBOutlet weak var articleDescTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var articleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDesc: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
