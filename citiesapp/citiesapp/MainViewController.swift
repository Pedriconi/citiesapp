//
//  MainViewController.swift
//  citiesapp
//
//  Created by Guilherme Pedriconi on 12/05/19.
//  Copyright © 2019 Pedriconi. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    var itemSelected:String! = ""
    var objCity = City()
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnSearchBar: UIBarButtonItem!
    @IBOutlet weak var imgStar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func touchPhone(_ sender: Any) {
        var urll:NSURL = NSURL(string: "tel://\(objCity.phoneNumber!)")!
        UIApplication.shared.openURL(urll as URL)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let url = "http://dev.4all.com:3003"
        let task = "/tarefa/" + itemSelected
        let httpMethod = "GET"
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        var request = NSMutableURLRequest(url: NSURL(string: url + task)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = httpMethod
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
               
                do {
                    
                    let json = try JSONSerialization.jsonObject(with:data!) as! [String:Any]
                    let city = City()
                    city.name = json["cidade"]! as! String
                    city.street = json["endereco"]!  as! String
                    city.neighborhood =  json["bairro"]! as! String
                    city.phoneNumber =   json["telefone"]! as! String
                    city.lat = json["latitude"]! as! NSNumber
                    city.long = json["longitude"]! as! NSNumber
                    self.objCity = city
                
                }catch {
                    print("## JSON Serialization step has FAILED ##")
                }
                
            }
        })
        dataTask.resume()
        
        imgStar.setRounded()
        self.view.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 244/255, alpha: 1)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.viewDidLoad()
        if(segue.identifier == "gotoMap"){
            let destination = segue.destination as! MapViewController
            destination.selectedObj = self.objCity
            
        }
    }


}


extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}


