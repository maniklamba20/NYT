//
//  UIHelper.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/19/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import Foundation
import UIKit

class UIHelper{
    
    static func ShowProgressIndicator(_ displayMessage:String, masterView: UIView) -> UIView
        {
            var messageFrame = UIView()
            var activityIndicator = UIActivityIndicatorView()
            var strLabel = UILabel()
            
            strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
            strLabel.font = strLabel.font.withSize(15)
            strLabel.text = displayMessage
            strLabel.textColor = UIColor.black
            messageFrame = UIView(frame: CGRect(x: masterView.frame.midX - 75, y: masterView.frame.midY , width: 150, height: 50))
            messageFrame.layer.cornerRadius = 15
            messageFrame.backgroundColor = UIColor.lightGray
            
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            activityIndicator.color = UIColor.black
            messageFrame.addSubview(activityIndicator)
            messageFrame.addSubview(strLabel)
            return messageFrame
    }
    
    static func ShowDataAlert(_ errorMessage: String, controller:UIViewController)
    {
        let alertMessage = UIAlertController(title: "Error", message: errorMessage , preferredStyle: UIAlertControllerStyle.alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: nil))
        controller.present(alertMessage, animated: true, completion: nil)
        return
    }
    
}
