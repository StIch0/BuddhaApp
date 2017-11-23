//
//  LecturesTableViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 29/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class LecturesTableViewController: UITableViewController {

    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    
    var paramDict:[String:[String]] = Dictionary()
    var pagParamDict:[String:[String]] = Dictionary()
    var cntNews = 100000;
    var prevPage = ""
    var allLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }             
        
        paramDict = JSONTaker.shared.loadData(API: "lectures?page=\(cntNews)", paramNames: ["id","title","date", "short",  "image", "text"])
        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
            cntNews = Int((paramDict["id"]?[0])!)!
        }
        
        var ы = cntNews%20
        
        if (ы > 0) {ы = 1;}
        
        cntNews = cntNews/20 + ы
        
        paramDict["id"]!.reverse()
        paramDict["title"]!.reverse()
        paramDict["date"]!.reverse()
        paramDict["short"]!.reverse()
        paramDict["image"]!.reverse()
        paramDict["text"]!.reverse()
        
        cntNews = cntNews - 1
        
            //loadAstrologicalData(baseURL: "file:///Users/dugar/Downloads/feed.json")
            //print (paramDict)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paramDict["title"]?.count)!
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.allowsSelection = true

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected name : "+(self.paramDict["date"]?[indexPath.row])!)
        var cell = tableView.cellForRow(at: indexPath) as! LectureTableViewCell
        
        StringLblText   = (self.paramDict["title"]?[indexPath.row])! 
        StringText = (self.paramDict["text"]?[indexPath.row])!
        StringDataField = (self.paramDict["date"]?[indexPath.row])!    
        StringUrlImg = (self.paramDict["image"]?[indexPath.row])!
        GlobalImg = cell.img.image
        tableView.allowsSelection = false

        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LectureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LectureTableViewCell", for: indexPath) as! LectureTableViewCell

      //  cell.dateLbl.text = JSONTaker.shared.convertDate(date: (self.paramDict["date"]?[indexPath.row])!)
        cell.dateLbl.text = (self.paramDict["date"]?[indexPath.row])
        cell.titleLbl.text = self.paramDict["title"]?[ indexPath.row]
        cell.shortTextLbl.setHTML(html: (self.paramDict["short"]?[indexPath.row])!)
        
        JSONTaker.shared.loadImg(imgURL: (self.paramDict["image"]?[indexPath.row])!,
                                 img: [cell.img], 
                                 spinner: cell.spinner)                
        
        if !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
            
            
            self.pagParamDict = JSONTaker.shared.loadData(API: "lectures?page=\(cntNews)", paramNames: ["id","title","date", "short",  "image", "text"])
            cntNews = cntNews-1
            
            pagParamDict["id"]!.reverse()
            pagParamDict["title"]!.reverse()
            pagParamDict["date"]!.reverse()
            pagParamDict["short"]!.reverse()
            pagParamDict["image"]!.reverse()
            pagParamDict["text"]!.reverse()
            
            print(pagParamDict)                         
            
            if (cntNews == -1) {
                print (paramDict["title"])
                print("  ALL LOADED !!!") 
                allLoaded = true
                return cell
            }
            
            
            if (allLoaded == true) {
                for var iPag in pagParamDict.keys {
                    for var paramIpag in pagParamDict[iPag]! {
                        paramDict[iPag]?.append(paramIpag)
                    }
                }
                
                tableView.reloadData()
            }
        }
        
        return cell
    }
}
