//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBar: UINavigationItem!
    
    var paramDict:[String:[String]] = Dictionary()
    var pagParamDict:[String:[String]] = Dictionary()
    var paramParamDict:[String:[String]] = Dictionary()
    var cntNews = 10000;
    var allLoaded = false
    
    override func viewWillAppear(_ animated: Bool) {
        print(cntNews)
        
        self.paramDict = JSONTaker.shared.loadData(API: "news?page=\(cntNews)", paramNames: ["id", "title","date", "short",  "image", "text"])
        
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
        
        if (paramDict["title"]?.count)!==1 && (paramDict["image"]![0]) == "" {
            JSONTaker.shared.showAlert(title: "Сервер не отвечает", message: "Проверьте соединение с интернетом", viewController: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()                                                                                                                        
        
        //revealViewController().panGestureRecognizer().isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.    
          
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))        
            
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
 
    override func viewDidAppear(_ animated: Bool) {
        JSONTaker.shared.setStatusBarColorOrange()
        tableView.allowsSelection = true                                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paramDict["id"]?.count)!
    }
        
    var dataString: [String] = []
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("You selected name : "+(self.paramDict["date"]?[indexPath.row])!)
        let cell = tableView.cellForRow(at: indexPath) as! FeedsCell
        
        StringLblText   = (self.paramDict["title"]?[indexPath.row])! 
        StringText = (self.paramDict["text"]?[indexPath.row])!
        StringDataField = (self.paramDict["date"]?[indexPath.row])!
        StringUrlImg    = (self.paramDict["image"]?[indexPath.row])!
        
        GlobalImg = cell.img.image
        tableView.allowsSelection = false
        
        //print(paramDict.count, "in select")
        performSegue(withIdentifier: "segue", sender: self)                       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedsCell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
        print("dateTime before      ",self.paramDict["date"]?[indexPath.row])

      //  cell.dataTime.text = JSONTaker.shared.convertDate(date: (self.paramDict["date"]?[indexPath.row])!)
        cell.dataTime.text = self.paramDict["date"]?[indexPath.row]
        print("dateTime      ",cell.dataTime.text)
        cell.titleText.text = self.paramDict["title"]?[indexPath.row]
        cell.shortText.text = self.paramDict["short"]?[indexPath.row]
        JSONTaker.shared.loadImg(imgURL: (self.paramDict["image"]?[indexPath.row])!, img: [cell.img], spinner: cell.spinner)
        
        
        cell.shortText.sizeToFit()   
        cell.titleText.sizeToFit()
        cell.dataTime.sizeToFit()
        cell.img.sizeToFit()        
        
        if cntNews != -1 && !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
            
            print (" ********** ", cntNews)
            self.pagParamDict = JSONTaker.shared.loadData(API: "news?page=\(cntNews)", paramNames: ["id","title","date", "short",  "image", "text"])
            cntNews = cntNews-1
            
            pagParamDict["id"]!.reverse()
            pagParamDict["title"]!.reverse()
            pagParamDict["date"]!.reverse()
            pagParamDict["short"]!.reverse()
            pagParamDict["image"]!.reverse()
            pagParamDict["text"]!.reverse()
            
            //print(pagParamDict)
            
            if (cntNews == -1) {
                print("  ALL LOADED !!!") 
                allLoaded = true
                return cell
            }
            
            
            for var iPag in pagParamDict.keys {
                for var paramIpag in pagParamDict[iPag]! {
                    paramDict[iPag]?.append(paramIpag)
                }
            }
            
            tableView.reloadData()
        }
        
        return cell
    }
}

//https://www.youtube.com/watch?v=K1qrk6XOuIU
