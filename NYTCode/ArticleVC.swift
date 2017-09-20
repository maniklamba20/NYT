//
//  ArticleVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/19/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

struct articleStruc {
    var title:String
    var desc:String
    var image:String
}
typealias timeTuple = (Key:String,Value:Int)

class ArticleVC: UIViewController {
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var articleTable: UITableView!
    var articleData = [articleStruc]()
    var imageCache = [String:UIImage]()
    var timeData = [timeTuple]()
    var currentSelectedButton = 0
    
    var sectionData = ["Arts","Automobiles","Blogs","Books","Business Day","Education","Fashion & Style","Food","Health","Job Market","Magazine","membercentre","Movies","multimedia","NYT Now","Obituaries","Open","Opinion","Public Editor","Real Estate","Science","Sports","Style","Sunday Review","T Magazine","Technology","The Upshot","Theatre","Times Insider","Today's Paper","Travel","US","World","Your Money","all-sections"]

    @IBOutlet weak var searchViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet weak var timePeriodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Articles"
        timeData.append(("Daily", 1))
        timeData.append(("Weekly", 7))
        timeData.append(("Monthly", 30))
        self.timePeriodTable.reloadData()
        self.sectionTable.reloadData()
        self.defaultValuesForFilter()
        let formURl = URLConstants.MostEmailedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
        
        let btn = self.view.viewWithTag(100) as? UIButton
        self.refreshTheTableData(btn!)
        self.fetchData(forAPI: formURl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData(forAPI:String){
        self.articleData.removeAll()
        self.articleTable.reloadData()
        self.ShowProgressView("Loading....")

        let headers = ["content-type": "application/json"]
        Alamofire.request(forAPI, method:.get
            , parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //            print(response)
                do{
                    guard let info = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] else{
                        return
                    }
                    if (response.response?.statusCode == 200){
                        for dict in info["results"] as! [NSDictionary] {
                            print("My Data Count is \(dict.count)")
                            if let temp =  dict["media"] as? [NSDictionary]{
                                self.articleData.append(articleStruc(title:(dict["title"] as? String)!, desc: (dict["abstract"] as? String)!, image:((temp[0].value(forKeyPath:"media-metadata") as? NSArray)!.object(at: 2) as! NSDictionary)["url"]! as! String))
                            }
                            else{
                                self.articleData.append(articleStruc(title:(dict["title"] as? String)!, desc: (dict["abstract"] as? String)!, image:""))
                            }
                        }
                        if self.articleData.count > 0 {
                            self.articleTable.reloadData()
                            self.articleTable.estimatedRowHeight = 150
                            self.articleTable.rowHeight = UITableViewAutomaticDimension
                            self.HideProgressView()
                        }
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

    @IBAction func refreshTheTableData(_ sender: UIButton) {
        for i in 100 ... 102 {
            let btn = self.view.viewWithTag(i) as? UIButton
            btn?.backgroundColor = UIColor.clear
        }
        sender.backgroundColor = UIColor.white
       
        switch sender.tag {
        case 100:
            let formURl = URLConstants.MostViewedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
                self.fetchData(forAPI: formURl)
                self.currentSelectedButton = 100
            break
        case 101:
            let formURl = URLConstants.MostEmailedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
                self.fetchData(forAPI: formURl)
            self.currentSelectedButton = 101
            break
        default:
            let formURl = URLConstants.MostSharedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
                self.fetchData(forAPI: formURl)
            self.currentSelectedButton = 102
            break
        }
    }
    
    @IBAction func displayFilters(_ sender: UIBarButtonItem) {
        self.backgroundBtn.isHidden = false
        self.hideUnhideSearchViewLogic(shouldHide: false)
    }
    
    
    func hideUnhideSearchViewLogic(shouldHide:Bool){
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

    @IBAction func hideFilterView(_ sender: UIButton) {
        self.hideUnhideSearchViewLogic(shouldHide: true)
    }
    
    @IBAction func defaultFilterValues(_ sender: UIButton) {
        self.defaultValuesForFilter()
    }
    
    func defaultValuesForFilter (){
        if let deselectIndexPathOne = self.sectionTable.indexPathForSelectedRow {
            self.sectionTable.deselectRow(at: deselectIndexPathOne, animated: true)
            self.sectionTable.delegate?.tableView!(self.sectionTable, didDeselectRowAt: deselectIndexPathOne)
        }
        
        let selectIndexPathOne = IndexPath(row: 0, section: 0)
        self.sectionTable.selectRow(at: selectIndexPathOne, animated: false, scrollPosition: .none)
        self.sectionTable.delegate?.tableView!(self.sectionTable, didSelectRowAt: selectIndexPathOne)
        
        
        if let deselectIndexPathTwo = self.timePeriodTable.indexPathForSelectedRow {
            self.timePeriodTable.deselectRow(at: deselectIndexPathTwo, animated: true)
            self.timePeriodTable.delegate?.tableView!(self.timePeriodTable, didDeselectRowAt: deselectIndexPathTwo)
        }
        
        let selectIndexPathTwo = IndexPath(row: 0, section: 0)
        self.timePeriodTable.selectRow(at: selectIndexPathTwo, animated: false, scrollPosition: .none)
        self.timePeriodTable.delegate?.tableView!(self.timePeriodTable, didSelectRowAt: selectIndexPathTwo)

    }
    
    @IBAction func refreshListDataFromPopup(_ sender: UIButton) {
        switch self.currentSelectedButton {
        case 100:
            let formURl = URLConstants.MostViewedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
            self.fetchData(forAPI: formURl)
            break
        case 101:
            let formURl = URLConstants.MostEmailedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
            self.fetchData(forAPI: formURl)
            break
        default:
            let formURl = URLConstants.MostSharedArticleAPI + "\(self.sectionData[(self.sectionTable.indexPathForSelectedRow?.row)!])/\(self.timeData[(self.timePeriodTable.indexPathForSelectedRow?.row)!].Value).json?" + appDel.APIKey
            self.fetchData(forAPI: formURl)
            break
        }

        self.hideUnhideSearchViewLogic(shouldHide: true)
    }
    
    
}

extension ArticleVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 200:
            return self.articleData.count
        case 201:
            return self.timeData.count
        default:
            return self.sectionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 200:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ArticleCustomCell
            cell?.articleTitle?.text = articleData[indexPath.row].title
            cell?.articleDesc?.text = articleData[indexPath.row].desc
            if articleData[indexPath.row].image == "" {
                cell?.articleImage.isHidden = true
                cell?.articleDescTrailingConstraint.constant = 8
                cell?.articleTrailingConstraint.constant = 8
            }
            else{
                cell?.articleImage.isHidden = false
                cell?.articleDescTrailingConstraint.constant = 175
                cell?.articleTrailingConstraint.constant = 175
                if let image = self.imageCache[self.articleData[indexPath.row].image] {
                    cell?.articleImage.image = image
                }
                else
                {
                    DispatchQueue.global().async {
                        let imgUrl = NSURL(string:self.articleData[indexPath.row].image)
                        let data = NSData(contentsOf:(imgUrl as URL?)!)! as Data
                        let tempImage = UIImage (data: data)
                        self.imageCache[self.articleData[indexPath.row].image] = tempImage
                        DispatchQueue.main.async {
                            cell?.articleImage.image = tempImage
                        }
                    }
                }
            }
            return cell!

        case 201:
            let cell = tableView.dequeueReusableCell(withIdentifier:"time")
            cell?.textLabel?.text = "\(timeData[indexPath.row].Key)"
            cell?.textLabel?.textColor = UIColor.white
            if indexPath.row == self.timePeriodTable.indexPathForSelectedRow?.row {
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else{
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:"section")
            cell?.textLabel?.text = self.sectionData[indexPath.row]
            cell?.textLabel?.textColor = UIColor.white
            if indexPath.row == self.sectionTable.indexPathForSelectedRow?.row {
                    cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else{
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 201 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else if tableView.tag == 202 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.tag == 201 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else if tableView.tag == 202 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
}

