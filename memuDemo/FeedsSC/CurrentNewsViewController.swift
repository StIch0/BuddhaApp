//
//  CurrentNewsViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 23/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class CurrentNewsViewController: UIViewController {
    
    @IBOutlet var lblText: UILabel!
    @IBOutlet var dataField: UILabel!    
    @IBOutlet var textNews: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!       
    @IBOutlet var imgHeight: NSLayoutConstraint!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblText.text = StringLblText
        dataField.text = StringDataField
        textNews.text = StringText
        if (localError != ""){
            JSONTaker.shared.showAlert(title: localError, message: "", viewController: self)}
            
        else {
            //JSONTaker.shared.loadImg(imgURL: StringUrlImg, img: [img], spinner: spinner)
            if (GlobalImg != nil) {
                img.image = GlobalImg
                imgHeight.constant = img.bounds.width * ((img.image?.size.height)!/(img.image?.size.width)!)                                                                                           
                
                img.frame = CGRect(x: img.frame.origin.x,
                                   y: img.frame.origin.y,
                                   width: img.frame.width,
                                   height: imgHeight.constant)  
            }
            else {
                JSONTaker.shared.loadImg(imgURL: StringUrlImg, img: [img], spinner: spinner, heightConstraint: imgHeight)
            }
        }
        img.sizeToFit()
        
        textNews.setHTML(html: textNews.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
