//
//  JSONTaker.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 25/08/2017.
//  Created by Pavel Burdikovskii (StIch)
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON
//

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }   
}

extension UILabel {
    func setHTML(html: String) {           
        do {               
            let at : NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil);                        
            self.attributedText = at;
        } catch {
            self.text = html;
        }
        font = UIFont(name: "Helvetica", size: 14)
    }
}

var StringLblText       :  String  = ""
var StringText          :  String  = ""
var StringDataField     :  String  = ""
var StringUrlImg        :  String  = ""
var StringVideoID       :  String  = ""
var StringNavBarTitle   :  String  = ""
var StringSumm          :  String  = ""
var StringImgURLs       : [String] = [String]()
var GlobalImg           : UIImage? = UIImage()

var sv : UIView = UIView()

//don't remove this line -> test for StIch


//let baseURL = "file:///Users/dugar/Downloads/Android_to_iOs-master-6/FANATICS/"
//let baseURL = "file:///Users/dugar/Desktop/AndrtoIOS/FANATICS/"
let baseURL = "http://ch95115.tmweb.ru"
//let baseURL = "http://192.168.3.225"
let donateURL = "http://www.buddhismofrussia.ru/donate/"
let blackView = UIView()
var localError: String = ""

class JSONTaker
{        
    private init () {}
    static let shared = JSONTaker()
    public var location = 0;    
    var json:[String:AnyObject] = Dictionary()
    let dateFormatter = DateFormatter()              
    
    
    private func loadJSON (API: String)
    {
        //let url=URL(string: baseURL + API + ".json")
        let url=URL(string: baseURL + "/api/" + API)
        
            var allData = Data()
            
            do {
                allData = try Data(contentsOf: (url)!)                                                        
                //print (strData!)            
                let strJSON = String(data: allData, encoding: .utf8)            
                                    
                var validStrJSON = "{\n  \"page\":" + strJSON! + "\n}"            
            
                print (validStrJSON)
                
                let arr: [UInt8] = Array(validStrJSON.utf8)
                allData = Data(arr)
            
                let tryJSON = try JSONSerialization.jsonObject(with: allData, options: JSONSerialization.ReadingOptions.allowFragments)                        
                json = tryJSON as! [String: AnyObject]
            }
            catch {                
                print(error)
                localError = error.localizedDescription            
            }          
    }

    
    func loadData (API: String, paramNames:[String]) -> ([String: [String]])
    {
        loadJSON(API: API)
        var Localparams:[String:[String]] = Dictionary()
        do {            
            if let JSONN = json["page"] {                           
                
                for var iParam in paramNames { Localparams[iParam] = [] }                                
                
                if (JSONN.count > 0) { 
                for var index in 0...JSONN.count-1 {     
                    var aObject = JSONN.objectAt(index) as! [String : AnyObject]  
                                        
                    for var iParam in paramNames {               
                        if (iParam == "id" || iParam=="album" || iParam == "id_photos" || iParam == "id_rasp") {
                            Localparams[iParam]?.append(String(aObject[iParam] as! Int))
                        }                        
                        else {
                            Localparams[iParam]?.append(aObject[iParam] as! String)
                        }
                    }                    
                }
                }
            }
            else {
                for var iParam in paramNames { Localparams[iParam] = [] }
                                
                for var index in 0...paramNames.count-1 {
                    if paramNames[index] == "id" || paramNames[index] == "album" {
                        Localparams[paramNames[index]]?.append("1")
                    }
                    else {
                        Localparams[paramNames[index]]?.append("")
                    }
                }
            }            
        }
        catch {
            print(error)
            localError = error.localizedDescription
        }
            return Localparams
    }
    
    
   
    func loadImg(imgURL: String, img: [UIImageView], spinner: UIActivityIndicatorView, heightConstraint: NSLayoutConstraint? = nil)-> Void{
        
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        if imgURL == "" {return;}
        var imgurl = imgURL
        
      
        
        var uploadsSTR = ""
        
        while (imgurl.characters.count > 0) {
            uploadsSTR.append(imgurl.characters.removeFirst())
                        
            if (uploadsSTR == "/uploads") {break;}
//            else {
//                print (" ########### ", uploadsSTR)
//            }
        }
        
        var baseurl = ""        
//        print (imgurl , "  <<<<<<<<<<<<<< ", imgurl.characters.count)
        
        if (imgurl.characters.count == 0) {
            imgurl = "/vi/\(imgURL)/hqdefault.jpg"
            baseurl = "https://img.youtube.com"
        }
        else {
            imgurl = imgURL 
            baseurl = baseURL
        }
        
        //while imgURLL.characters.first == "/" {imgURLL.characters.removeFirst()}
        
        let urlURL = URL(string: baseurl + imgurl)
        
        if urlURL == nil {print (String(baseurl + imgurl));
            print ("invalid url for image !!! АУЕ  ", imgurl); return }
        print (String(baseurl + imgurl))
        asyncLoadImage(imageURL: urlURL!,
                       runQueue: DispatchQueue.global(),
                       completionQueue: DispatchQueue.main)
        { result, error in
            guard let image = result
                else {return}
            
            for gmi in img {
                gmi.image = image
                
                gmi.clipsToBounds = true
                
                if gmi.image != nil {
                if heightConstraint != nil {                                        
                    if (gmi.contentMode == UIViewContentMode.scaleAspectFit && gmi.bounds.height==0) {
                    
                        DispatchQueue.init(label: "asds").async(execute: {
                            while (true) {
                                if gmi.bounds.width != 0.0 {
                                    heightConstraint?.constant = gmi.bounds.width * ((gmi.image?.size.height)!/(gmi.image?.size.width)!)                                                        
                                
                                    gmi.frame = CGRect(x: gmi.frame.origin.x,
                                                       y: gmi.frame.origin.y,
                                                       width: gmi.frame.width,
                                                       height: (heightConstraint?.constant)!)   
                                    print (gmi.frame)
                                    return
                                }
                            }                                                
                        })  
                    }
                    else {
                        heightConstraint?.constant = gmi.bounds.width * ((gmi.image?.size.height)!/(gmi.image?.size.width)!)                                                        
                    
                        gmi.frame = CGRect(x: gmi.frame.origin.x,
                                           y: gmi.frame.origin.y,
                                           width: gmi.frame.width,
                                           height: (heightConstraint?.constant)!)  
                    }
                }
            }
            }
            
            spinner.stopAnimating()
        }        
    }         
    
    func asyncLoadImage(imageURL: URL,
                        runQueue: DispatchQueue,
                        completionQueue: DispatchQueue,
                        completion: @escaping (UIImage?, Error?) -> ()) {
        runQueue.async {
            do {
                let data = try Data(contentsOf: imageURL)
                completionQueue.async { completion(UIImage(data: data), nil)}
            } catch let error {
                completionQueue.async { completion(nil, error)}
            }
        }
    }    
    
    func loadVideo (videoCode: String, myWebView: UIWebView, viewController: UIViewController? = nil) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)") 
        myWebView.isHidden = true        
        
        if (url == nil) {
            if (viewController != nil) {
                self.showAlert(title: "Невозможно загрузить видео", message: "Не валидный адрес на видео", viewController: viewController!)
            }
            return 
        }
        
        myWebView.loadRequest(URLRequest(url: url!))                
    }
    
    func setStatusBarColorOrange ()
    {
        let orangeStatusBar = UIView()
        orangeStatusBar.backgroundColor = UIColor(colorLiteralRed: 1,
                                                   green: 0.62745098,
                                                   blue: 0,
                                                   alpha: 1)
        //orangeStatusBar.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        orangeStatusBar.frame = CGRect(x: 0, y: 0, width: 1000, height: 20)        
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(orangeStatusBar)
        }
    }
    
    func makeDark (viewController: UIViewController)
    {		
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        blackView.alpha = 0
        //magic numbers ALERT !!!
        UIView.animate(withDuration: 0.725, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            blackView.alpha = 1
        }, completion: nil)
                       
        viewController.view.addSubview(blackView)        
    }
    //post request
    
    func onPostTapped(API: String, parameters : [String : String]) {
        
         

        guard let url = URL(string: baseURL + API) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody                        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
             
            
            if let data = data {
                //String(data: allData, encoding: .utf8)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)                    
                } catch {                    
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func showAlert (title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in 
            alert.dismiss(animated: true, completion: nil)            
        }))                
        
        viewController.present(alert, animated: true, completion: nil)        
    }
    
    func fromHTMLToAdequate (HTML: String) -> String {        
        var html = HTML
        var adeq = ""
        var adequate = ""
        
        if (HTML.characters.count == 0) {return ""}
        
        while (html.characters.first != Character("\"")) {
            html.remove(at: html.startIndex)            
        }

        html.remove(at: html.startIndex)
        
        while (html.characters.first != Character("\"")) {
                 adequate.append(html.remove(at: html.startIndex))
            
        }
        
        while (adequate.characters.last != Character("/")) {
                 adeq.append(adequate.characters.removeLast())
            
        }
        
        adeq = String(adeq.characters.reversed())
        
        return adeq
    }

}

