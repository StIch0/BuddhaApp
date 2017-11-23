//
//  VideoAlbumViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 29/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class VideoAlbumViewController: UITableViewController {
    
    var cntPag = 2;
    var allLoaded = false
    var pagParamDict:[String:[String]] = Dictionary()

    @IBOutlet var btnMenuButton: UIBarButtonItem!

    var paramDict:[String:[String]] = Dictionary()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }               
            
        paramDict = JSONTaker.shared.loadData(API: "videos?page=\(cntPag)", paramNames: ["id","title", "date", "text"])
            //print (paramDict)    
        
        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
            cntPag = Int((paramDict["id"]?[0])!)!
        }
        
        var ы = cntPag%20
        
        if (ы > 0) {ы = 1;}
        
        cntPag = cntPag/20 + ы
        
        cntPag -= 1
        
        paramDict["id"]!.reverse()
        paramDict["title"]!.reverse()
        paramDict["date"]!.reverse()
        paramDict["text"]!.reverse()        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paramDict["id"]?.count)!
    }    
    override func viewDidAppear(_ animated: Bool) {
        tableView.allowsSelection = true

    }
    @objc(tableView:didSelectRowAtIndexPath:) override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        //print("You selected name : "+(self.paramDict["title"]?[indexPath.row])!)
                
        StringLblText   = (self.paramDict["title"]?[indexPath.row])!           
        StringVideoID   = JSONTaker.shared.fromHTMLToAdequate(HTML: (paramDict["text"]?[indexPath.row])!)
        tableView.allowsSelection = false

        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoAlbumCell = tableView.dequeueReusableCell(withIdentifier: "VideoAlbumCell", for: indexPath) as! VideoAlbumCell                        
        
        cell.titleLbl.text = self.paramDict["title"]?[indexPath.row]
        let adequateVideoURL = JSONTaker.shared.fromHTMLToAdequate(HTML: (paramDict["text"]?[ indexPath.row])!)
        
        print (" adequateVideoURL   =   ", adequateVideoURL)
        JSONTaker.shared.loadImg(imgURL: adequateVideoURL, img: [cell.img], spinner: cell.spinner)
        //cell.shortText.sizeToFit() 
        
        if !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
            
            self.pagParamDict =  JSONTaker.shared.loadData(API: "videos?page=\(cntPag)", paramNames: ["id","title", "date", "text"])
            
            pagParamDict["id"]!.reverse()
            pagParamDict["title"]!.reverse()
            pagParamDict["date"]!.reverse()
            pagParamDict["text"]!.reverse()
            
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
