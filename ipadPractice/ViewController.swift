//
//  ViewController.swift
//  ipadPractice
//
//  Created by Minh Le on 2019-06-13.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sendDelegate: SendDelegate? = nil
    var userName: String? = nil

   
    
    @IBOutlet weak var username: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = userName
    }
}
