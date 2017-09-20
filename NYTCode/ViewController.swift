//
//  ViewController.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/11/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var articleBtn: UIButton!
    @IBOutlet weak var topStoriesBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var movieBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleBtn.layer.borderColor = UIColor.white.cgColor
        self.topStoriesBtn.layer.borderColor = UIColor.white.cgColor
        self.bookBtn.layer.borderColor = UIColor.white.cgColor
        self.movieBtn.layer.borderColor = UIColor.white.cgColor
        
        self.articleBtn.layer.borderWidth = 1.0
        self.movieBtn.layer.borderWidth = 1.0
        self.bookBtn.layer.borderWidth = 1.0
        self.topStoriesBtn.layer.borderWidth = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

