//
//  TopStoryCustomCell.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/12/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit

class TopStoryCustomCell: UITableViewCell {
    
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var storyRelatedImage: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
