//
//  ViewController.swift
//  PushNotification
//
//  Created by EOO61 on 03/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendDeviceTokenToServer(_ sender: Any) {
        
        let fcmToken = UserDefaults.standard.object(forKey: "FcmToken")
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
            "SecretKey": "4767e127b1a2493d9796eee3f6830c0d", //this is for emSigner
            "AppName": "EmsignerMobileApp",
            "DeviceId": "\(fcmToken ?? "")" //this is for push notification
        ]
        let parameters = [
            "UserName": "yes1@yopmail.com",
            "Password": "111111"
        ] as [String : Any]
        
        let postData = try!JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let urlNew = "https://qamobapi-int.emsigner.com/api/ValidateLogin"
        let request = NSMutableURLRequest(url: NSURL(string: urlNew)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                print(String(data: data!, encoding: .utf8)!)
            }
        })
        
        dataTask.resume()
    }
}


