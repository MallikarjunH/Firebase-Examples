//
//  ViewController.swift
//  iOSCrashlyticsTest
//
//  Created by EOO61 on 23/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton(type: .roundedRect)
              button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
              button.setTitle("Test Crash", for: [])
              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
              view.addSubview(button)
    }
 
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          fatalError()
      }

}

