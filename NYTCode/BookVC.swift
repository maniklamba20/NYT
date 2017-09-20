//
//  BookVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/13/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

struct book {
    var title:String?
    var author:String?
    var image:String?
    var encodedTitle:String?
}

typealias sectionTuple = (Key:String,Value:String)

class BookVC: UIViewController {
    var bookData = NSMutableDictionary()
    var sections = [sectionTuple]()
    var imageCache = [String:UIImage]()
    let appDel = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var bookTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = "Books"
        self.bookTable.rowHeight = UITableViewAutomaticDimension
        self.bookTable.estimatedRowHeight = 160
        self.fetchData(forAPI: URLConstants.BookAPI + appDel.APIKey)
    }

    
    
    func fetchData(forAPI:String){
        self.ShowProgressView("Loading....")
        let headers = ["content-type": "application/json"]
        Alamofire.request(forAPI, method:.get
            , parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                do{
                    guard let info = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] else{
                        return
                    }
                    if (response.response?.statusCode == 200){
                        
                        for dict in info["results"]?["lists"] as! [NSDictionary] {
                            self.sections.append((dict["display_name"] as! String, dict["list_name_encoded"] as! String))
                            var temp = [book]()
                            var count = 0
                            for bookDict in dict["books"] as! [NSDictionary] {
                                if (count < 3 ) {
                                    temp.append(book(title:bookDict["title"] as? String, author:bookDict["author"] as?String,image:bookDict["book_image"] as? String,encodedTitle:bookDict["list_name_encoded"] as? String))
                                    count  += 1
                                }
                                else{
                                    break
                                }
                            }
                            self.bookData.setValue(temp, forKey: dict["display_name"] as! String)
                            temp.removeAll()
                        }
                        if self.bookData.count > 0 {
                            self.bookTable.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let descVC = segue.destination as! GenreBooksVC
        descVC.title = self.sections[(sender as! UIButton).tag-100].Key
        descVC.genre = self.sections[(sender as! UIButton).tag-100].Value
    }

    func showMoreBooks(button:UIButton){
        performSegue(withIdentifier: "genreBooks", sender: button)
    }
}


extension BookVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = self.bookData.value(forKey: self.sections[section].Key) as! NSArray
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BookCustomCell
        let value = self.bookData.value(forKey: self.sections[indexPath.section].Key) as! NSArray
        let bookDO = value[indexPath.row] as! book
        
        cell?.bookTitle?.text = bookDO.title
        cell?.author?.text = "By " + bookDO.author!


        if let image = self.imageCache[bookDO.image!] {
            cell?.bookImage.image = image
        }
        else
        {
            DispatchQueue.global().async {
                let imgUrl = NSURL(string:bookDO.image!)
                let data = NSData(contentsOf:(imgUrl as URL?)!)! as Data
                let tempImage = UIImage (data: data)
                self.imageCache[bookDO.image!] = tempImage
                DispatchQueue.main.async {
                    cell?.bookImage.image = tempImage
                }
            }
        }
        return cell!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].Key
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        
        let lab = UILabel(frame: CGRect(x:10,y:0,width:self.view.bounds.width,height:28))
        lab.text = self.sections[section].Key
        lab.textColor = UIColor.black
        lab.font = UIFont.init(name: "HelveticaNeue-Medium", size: 15)
        view.addSubview(lab)
        
        let seeMoreBtn = UIButton()
        seeMoreBtn.frame = CGRect(x: self.view.bounds.width - 80 , y: 4, width: 70, height: 20)
        seeMoreBtn.tag = section + 100
        seeMoreBtn.setTitle("View All", for: .normal)
        seeMoreBtn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Bold", size: 13)
        seeMoreBtn.addTarget(self, action: #selector(self.showMoreBooks(button:)), for: UIControlEvents.touchUpInside)
        seeMoreBtn.setTitleColor(UIColor.white, for: .normal)
        seeMoreBtn.backgroundColor = UIColor.red
        seeMoreBtn.layer.cornerRadius = 3.0
        view.addSubview(seeMoreBtn)

        return view
    }
    
}
