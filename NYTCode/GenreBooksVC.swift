//
//  GenreBooksVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/14/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

struct bookDetail {
    var title:String?
    var desc:String?
    var publishedDate:String?
    var amazonUrl:String?

}

class GenreBooksVC: UIViewController {
    var bookData = [bookDetail]()
    var genre = ""
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var genreBookTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData(forAPI: URLConstants.BookGenreAPI + appDel.APIKey + "&list=\(genre)")
        // Do any additional setup after loading the view.
    }
    
    
    func fetchData(forAPI:String){
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
                            let tempDict = (dict["book_details"] as? [NSDictionary])?[0]
                            self.bookData.append(bookDetail(title:tempDict?["title"] as? String,desc:tempDict?["description"] as? String,publishedDate:dict["published_date"] as? String,amazonUrl:dict["amazon_product_url"] as? String))
                        }
                        
                    }
                    if self.bookData.count > 0 {
                        self.genreBookTable.reloadData()
                        self.genreBookTable.estimatedRowHeight = 143
                        self.genreBookTable.rowHeight = UITableViewAutomaticDimension
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
}



extension GenreBooksVC:UITableViewDelegate,UITableViewDataSource,shareAmazonUrl{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GenreBookCustomCell

        cell?.bookTitle?.text = bookData[indexPath.row].title
        cell?.bookDesc?.text = bookData[indexPath.row].desc
        cell?.shareBookBtn.tag = indexPath.row
        cell?.delegate = self
        
        
        let formatter  = { (dateStr:String, formatStr:String) -> (String) in
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            if let date = inputFormatter.date(from: dateStr){
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = formatStr
                return outputFormatter.string(from: date)
            }
            return ""
        }
        cell?.publishedDate?.text = formatter(bookData[indexPath.row].publishedDate! ,"MMM dd")
        print((cell?.publishedDate?.text)!)
        return cell!
    }
    func shareBookAmazonLink (tag:Int){
        let activityVC = UIActivityViewController (activityItems: [self.bookData[tag].amazonUrl!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC,animated: true,completion: nil)
    }

    
}

