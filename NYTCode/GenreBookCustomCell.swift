//
//  GenreBookCustomCell.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/15/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit

protocol shareAmazonUrl {
    func shareBookAmazonLink(tag:Int)
}

class GenreBookCustomCell: UITableViewCell {

    @IBOutlet weak var shareBookBtn: UIButton!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var bookDesc: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    var delegate: shareAmazonUrl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareLink(_ sender: UIButton) {
        delegate?.shareBookAmazonLink(tag: sender.tag)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
