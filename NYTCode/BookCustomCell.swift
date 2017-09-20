//
//  BookCustomCell.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/13/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit

class BookCustomCell: UITableViewCell {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
