//
//  MovieCustomCell.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/18/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
protocol readReviewForMovie {
    func readTheReview(tag:Int)
}


class MovieCustomCell: UITableViewCell {

    @IBOutlet weak var readReviewBtn: UIButton!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    var delegate: readReviewForMovie?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func reviewMovie(_ sender: UIButton) {
        delegate?.readTheReview(tag: sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
