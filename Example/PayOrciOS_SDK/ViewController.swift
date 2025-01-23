//
//  ViewController.swift
//  PayOrciOS_SDK
//
//  Created by ramanocs1145 on 01/23/2025.
//  Copyright (c) 2025 ramanocs1145. All rights reserved.
//

import UIKit
import PayOrciOS_SDK

class ViewController: UIViewController {
    
    private let homeViewModel = PayOrciOS_SDK.HomeViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        // Do any additional setup after loading the view, typically from a nib.
        
        PayOrciOS_SDK.Configuration.shared.updateConfigurationDetails("https://nodeserver.payorc.com/api/", apiVersion: "v1", merchantKey: "test-JR11KGG26DM", merchantSecret: "sec-DC111UM26HQ", environment: "test")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

