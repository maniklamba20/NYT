//
//  TopStoriesVC.swift
//  NYTCode
//
//  Created by Manik Lamba on 9/12/17.
//  Copyright © 2017 Manik Lamba. All rights reserved.
//

import UIKit
import Alamofire

struct topStory {
    var storyImage:String
    var Detail:String
    var storyURl:String
}

class TopStoriesVC: UIViewController {
    var topStoryData = [topStory]()
    var imageCache = [String:UIImage]()
    let appDel = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var topStoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Stories"
        self.fetchData(forAPI: URLConstants.TopStories + appDel.APIKey)
    }
    
    func fetchData(forAPI:String){
        self.topStoryData.removeAll()
        self.topStoryTable.reloadData()
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
                            print(dict)
                            if (dict["multimedia"] as! [NSDictionary]).count > 0{
                                self.topStoryData.append(topStory(storyImage:((dict["multimedia"] as! [NSDictionary])[4].value(forKey: "url") as? String)!, Detail:(dict["title"] as? String)!, storyURl: (dict["url"] as? String)!))
                            }
                        }
                        if self.topStoryData.count > 0 {
                            self.topStoryTable.reloadData()
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
        let descVC = segue.destination as! ReadStoryVC
            descVC.storyUrl = self.topStoryData[(self.topStoryTable.indexPathForSelectedRow?.row)!].storyURl
    }


}
extension TopStoriesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topStoryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TopStoryCustomCell
        cell?.desc?.text = topStoryData[indexPath.row].Detail
        
        if let image = self.imageCache[self.topStoryData[indexPath.row].storyImage] {
            cell?.storyRelatedImage.image = image
        }
        else
        {
        DispatchQueue.global().async {
            let imgUrl = NSURL(string:self.topStoryData[indexPath.row].storyImage)
            let data = NSData(contentsOf:(imgUrl as URL?)!)! as Data
            let tempImage = UIImage (data: data)
            self.imageCache[self.topStoryData[indexPath.row].storyImage] = tempImage
            DispatchQueue.main.async {
                cell?.storyRelatedImage.image = tempImage
            }
          }
        }
        return cell!
    }
}
