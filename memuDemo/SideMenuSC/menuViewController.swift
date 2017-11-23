//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var RandomTextUnderPict: UILabel!    
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!        
    @IBOutlet var imgXConstraint: NSLayoutConstraint!    
    @IBOutlet var imgWidthConstraint: NSLayoutConstraint!
    
    var randFrazes = ["Да пребудет с вами Будда",
                      "Пусть вам сопутствует удача",
                      "Пусть вас защищают все будды",
                      "Улыбнитесь, всё будет хорошо",
                      "Будьте сильны духом",
                      "Будьте в добром здравии"]    
    
    var viewControllersDict: [String:String] = ["Новости":"ViewController",
                                                "Расписание хуралов":"KhuralScheduleViewController",
                                                "Астрологический прогноз":"AstrologicalForecastViewController",
                                                "Дацаны Сангхи":"DatsansTableViewController",
                                                "Историческая справка":"HistoryTableViewController",
                                                "Лекции буддийского университета":"LecturesTableViewController",                                                                                                
                                                "Фото":"PhotoAlbumTableViewController",
                                                "Видео":"VideoAlbumViewController",
                                                "Разработчики":"DevelopersViewController"]
    
    var randIndex = arc4random_uniform(5)
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()   
    var didLoadCalled = true
    
    func handleDissmis (bugged: Bool=false)
    {
        if let window = UIApplication.shared.keyWindow {
            //magic numbers ALERT !!!
            UIView.animate(withDuration: 0.68, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.88, options: .curveEaseOut, animations: { 
                //blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                blackView.alpha = 0
            }, completion: nil)
        
            if (!bugged) {revealViewController().revealToggle(animated: true)}
        }                
    }
    
    func makeDark ()
    {                                            
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmis)))
        
        revealViewController().frontViewController.view.addSubview(blackView)
        blackView.frame = revealViewController().frontViewController.view.frame 
        blackView.alpha = 0
        //magic numbers ALERT !!!                        
        
        UIView.animate(withDuration: 0.725, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            blackView.alpha = 1                
        }, completion: nil)
            
        
    }           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JSONTaker.shared.setStatusBarColorOrange()
        self.view.layer.shadowRadius = 0;
        
        
        revealViewController().toggleAnimationType = SWRevealToggleAnimationType.spring
        revealViewController().toggleAnimationDuration = 0.725 //magic numbers ALERT !!!                                                
        
        if let window = UIApplication.shared.keyWindow {
            revealViewController().rearViewRevealWidth = window.frame.width * 0.8
            revealViewController().draggableBorderWidth = window.frame.width * 0.05
            imgXConstraint.constant = window.frame.width * 0.4 - imgWidthConstraint.constant*0.5            
        }                
        
        ManuNameArray = [
            "Новости",
            "Расписание хуралов",
            "Астрологический прогноз",
            "Дацаны Сангхи", 
            "Историческая справка", 
            "Лекции буддийского университета",
            "Фото",
            "Видео",
            "Разработчики"
        ]
        iconArray = [UIImage(named:"news")!,
                     UIImage(named:"hurals")!,
                     UIImage(named:"zurkhai")!,
                     UIImage(named:"datsans")!,
                     UIImage(named:"history")!,
                     UIImage(named:"lectures")!,
                     UIImage(named:"album")!,
                     UIImage(named:"video")!,
                     UIImage(named:"settings")!
        ]                    
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true 
        // Do any additional setup after loading the view.        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        handleDissmis(bugged: true)
        
        DispatchQueue.main.async(execute: {
            while (blackView.alpha != 0) {
                blackView.removeFromSuperview()
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let randIndex = arc4random_uniform(5)
        RandomTextUnderPict.text = randFrazes[Int(randIndex)]
        makeDark()
        JSONTaker.shared.setStatusBarColorOrange()     
        
        if (didLoadCalled == true) {
            (self.tblTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MenuCell).setSelected(true, animated: true)            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell        
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        cell.frame.size = CGSize(width: cell.frame.size.width, height: 200)                  
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDissmis()        
        
        var _: SWRevealViewController = self.revealViewController()
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)        
        
        if (didLoadCalled == true) {
            if (indexPath.row != 0) {
                (self.tblTableView.cellForRow(at: IndexPath(row: 0, section: 0)))?.setSelected(false, animated: true)
            }
            didLoadCalled = false
        }

        callViewController(controllerName: cell.lblMenuname.text!)
    }

    private func callViewController (controllerName: String) {
        for i in 0...ManuNameArray.count-1 {
            if ManuNameArray[i] == controllerName {
                JSONTaker.shared.location = i
            }
        }

        print(JSONTaker.shared.location)
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: viewControllersDict[controllerName]!)
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
        //sv = UIViewController.displaySpinner(onView: UIApplication.shared.keyWindow!)
        revealViewController().pushFrontViewController(newFrontController, animated: true)
    }    
}
