//
//  MoviesVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/18/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

struct movieDetail {
    var title:String?
    var desc:String?
    var reviewUrl:String?
    var image:String?
    
}

class MoviesVC: UIViewController {
    
    @IBOutlet weak var dateTxtFld: UITextField!
    @IBOutlet weak var keywordTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var verticalConstraintForPopView: NSLayoutConstraint!
    @IBOutlet weak var searchViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieReviewWebView: UIWebView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var moviesTable: UITableView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var imageCache = [String:UIImage]()
    
    @IBOutlet weak var clearFiltersBtn: UIButton!
    var movieData = [movieDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = "Movies"
        self.fetchData(forAPI: URLConstants.MovieAPI + appDel.APIKey)
    }
    
    func fetchData(forAPI:String){
        self.movieData.removeAll()
        self.moviesTable.reloadData()
        self.ShowProgressView("Loading....")
        let headers = ["content-type": "application/json"]
        Alamofire.request(forAPI, method:.get
            , parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                do{
                    guard let info = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] else{
                        return
                    }
                    if (response.response?.statusCode == 200){
                        
                        for dict in info["results"] as! [NSDictionary] {
                            var imgStr = ""
                            if let tempDict = dict["multimedia"] as? NSDictionary{
                                    imgStr = (tempDict["src"] as? String)!
                            }
                            else{
                                imgStr = "http://engineering.futureuniversity.com/wp-content/themes/envision/lib/images/default-placeholder-200x120.png"
                            }
                            self.movieData.append(movieDetail(title:dict["display_title"] as? String,desc:dict["summary_short"] as? String,reviewUrl:(dict["link"] as! Dictionary<String, Any>)["url"] as? String,image:imgStr))
                        }
                    }
                    if self.movieData.count > 0 {
                        self.moviesTable.reloadData()
                        self.moviesTable.estimatedRowHeight = 238
                        self.moviesTable.rowHeight = UITableViewAutomaticDimension
                        self.HideProgressView()
                    }
                    else{
                        UIHelper.ShowDataAlert("Sorry :( Data Not found.", controller: self)
                        self.HideProgressView()
                    }
                }
                catch{
                    print("Error trying to convert data to JSON")
                    self.HideProgressView()
                    return
                }
            }
        }

    func ShowProgressView(_ msg:String) {
        print(msg)
        let progressView = UIHelper.ShowProgressIndicator(msg, masterView: view)
        progressView.tag = 7777
        self.view.isUserInteractionEnabled = false
        view.addSubview(progressView)
        view.bringSubview(toFront: progressView)
    }

    func HideProgressView()
    {
        self.view.viewWithTag(7777)?.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissThePopupView(_ sender: UIButton) {
        self.hideUnhideMovieReviewLogic(tag: sender.tag, shouldHide: true)
    }
    
    @IBAction func dismissSearchView(_ sender: UIButton) {
        self.hideUnhideSearchViewLogic(shouldHide: true)
    }
    
    
    @IBAction func performSearch(_ sender: UIBarButtonItem) {
        self.hideUnhideSearchViewLogic(shouldHide: false)
    }
    
    @IBAction func clearFilters(_ sender: UIButton) {
        self.keywordTxtFld.text = nil
        self.dateTxtFld.text = nil
        self.fetchData(forAPI: URLConstants.MovieAPI + appDel.APIKey)
        self.clearFiltersBtn.alpha = 0.5
        self.hideUnhideSearchViewLogic(shouldHide: true)
    }
    
    @IBAction func backgroundBtnDismiss(_ sender: UIButton) {
        self.view.endEditing(true)
        self.searchViewVerticalConstraint.constant = -400
        self.hideUnhideMovieReviewLogic(tag: sender.tag, shouldHide: true)
    }
    
    
    @IBAction func refreshListData(_ sender: UIButton) {
        if self.keywordTxtFld.text?.characters.count == 0 && self.dateTxtFld.text?.characters.count == 0 {
            
        }
        else {
            self.clearFiltersBtn.alpha = 1.0
            self.clearFiltersBtn.isUserInteractionEnabled = true
            self.hideUnhideSearchViewLogic(shouldHide: true)
            self.fetchData(forAPI: URLConstants.MovieAPI + appDel.APIKey + "&query=\(self.keywordTxtFld.text!)")

        }
    }

    func hideUnhideSearchViewLogic(shouldHide:Bool){
        self.view.endEditing(true)
        if !shouldHide {
            self.backgroundBtn.isHidden = false
            self.searchView.isHidden = false
            self.searchViewVerticalConstraint.constant = 0
            self.searchView.layer.cornerRadius = 6.0
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.view.bringSubview(toFront: self.backgroundBtn)
                self.view.bringSubview(toFront: self.searchView)
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.2) {
                self.backgroundBtn.alpha = 0.7
            }
        }
        else{
            self.backgroundBtn.isHidden = true
            self.searchView.isHidden = true
            self.searchViewVerticalConstraint.constant = -400
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hideUnhideMovieReviewLogic(tag:Int,shouldHide:Bool){
        if !shouldHide {
            self.backgroundBtn.isHidden = false
            self.popupView.isHidden = false
            self.verticalConstraintForPopView.constant = 0
            self.popupView.layer.cornerRadius = 6.0
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.ShowProgressView("Loading....")
                self.movieReviewWebView.loadRequest(URLRequest(url:NSURL(string:self.movieData[tag].reviewUrl!)! as URL))
                self.view.bringSubview(toFront: self.backgroundBtn)
                self.view.bringSubview(toFront: self.popupView)
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2) {
                self.backgroundBtn.alpha = 0.7
            }
        }
        else{
            self.backgroundBtn.isHidden = true
            self.popupView.isHidden = true
            self.verticalConstraintForPopView.constant = -400
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
                self.movieReviewWebView.loadHTMLString("", baseURL: nil)
            }, completion: nil)
        }
        
    }
    
    
}



extension MoviesVC:UITableViewDelegate,UITableViewDataSource,readReviewForMovie{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MovieCustomCell
        cell?.movieTitle?.text = movieData[indexPath.row].title
        cell?.movieDesc?.text = movieData[indexPath.row].desc
        cell?.readReviewBtn.tag = indexPath.row
        cell?.delegate = self
        if let image = self.imageCache[self.movieData[indexPath.row].image!] {
            cell?.movieImage.image = image
        }
        else
        {
            DispatchQueue.global().async {
                let imgUrl = NSURL(string:self.movieData[indexPath.row].image!)
                let data = NSData(contentsOf:(imgUrl as URL?)!)! as Data
                let tempImage = UIImage (data: data)
                self.imageCache[self.movieData[indexPath.row].image!] = tempImage
                DispatchQueue.main.async {
                    cell?.movieImage.image = tempImage
                }
            }
        }
        return cell!
    }
    
    func readTheReview (tag:Int){
        self.hideUnhideMovieReviewLogic(tag: tag,shouldHide: false)
    }
}


extension MoviesVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (self.dateTxtFld.text?.characters.count)! > 0 || (self.keywordTxtFld.text?.characters.count)! > 0 {
            clearFiltersBtn.isUserInteractionEnabled = true
            self.clearFiltersBtn.alpha = 1.0
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.characters.count)! + string.characters.count) > 0 {
            self.clearFiltersBtn.isUserInteractionEnabled = true
            self.clearFiltersBtn.alpha = 1.0
        }
        if string == "" {
            textField.text?.characters.removeLast()
            if textField.text?.characters.count == 0 {
                self.clearFiltersBtn.isUserInteractionEnabled = false
                self.clearFiltersBtn.alpha = 0.5
            }
        }
        return true
    }

    
}




