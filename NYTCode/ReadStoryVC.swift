//
//  ReadStoryVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/13/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit

class ReadStoryVC: UIViewController {

    @IBOutlet weak var storyWebView: UIWebView!
    var storyUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyWebView.loadRequest(URLRequest(url:NSURL(string:storyUrl)! as URL))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
