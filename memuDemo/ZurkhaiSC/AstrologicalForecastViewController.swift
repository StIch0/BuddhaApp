//
//  khuralScheduleViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 11/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class AstrologicalForecastViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    var day: [String] = []           
    var texts: [String] = []
    var paramDict:[String:[String]] = Dictionary()    
    var cntPag = 10000;
    var allLoaded = false
    var pagParamDict:[String:[String]] = Dictionary()
    override func viewDidLoad() {
        super.viewDidLoad()      
        
         let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.menu.target = revealViewControllers
            menu.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }
        
        //http://localhost:8080/budd/http/api/zurkhay           
        
        for var i in 1...7
        {
            texts.append("text" + String(i))
        }                
        
        paramDict = JSONTaker.shared.loadData(API: "zurkhay?page=\(cntPag)", paramNames: ["id", "date", "title", "text"])
        
        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
            cntPag = Int((paramDict["id"]?[0])!)!
        }
        
        var ы = cntPag%20
        
        if (ы > 0) {ы = 1;}
        
        cntPag = cntPag/20 + ы
        
        paramDict["id"]?.reverse()
        paramDict["date"]?.reverse()
        paramDict["title"]?.reverse()
        paramDict["text"]?.reverse()
        
        cntPag -= 1;
                //print ("paramDict.count", paramDict.count)
        
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44 
        
        tableView.allowsSelection = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            UIViewController.removeSpinner(spinner: sv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }        
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return (self.paramDict["id"]?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DatAstroCellTableViewCell") as! DatAstroCellTableViewCell     

        cell.TitleLbl.text = (paramDict["title"]?[ indexPath.row])!
        cell.TextLbl.setHTML(html: (paramDict["text"]?[ indexPath.row])!)
        cell.sizeToFit()
        cell.TitleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        if cntPag != -1 && !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
            
            self.pagParamDict =  JSONTaker.shared.loadData(API: "zurkhay?page=\(cntPag)", paramNames: ["id", "date", "title", "text"])
            
            pagParamDict["id"]?.reverse()
            pagParamDict["date"]?.reverse()
            pagParamDict["title"]?.reverse()
            pagParamDict["text"]?.reverse()
            
            cntPag = cntPag-1
            
            print(pagParamDict)
            
            if (cntPag == -1) {
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
