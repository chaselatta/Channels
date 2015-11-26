//
//  ViewController.swift
//  Channels iOS Example
//
//  Created by Chase Latta on 11/23/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let id = NSUUID().UUIDString
    
    deinit {
        print("GO AWAY")
    }

    @IBAction func handleButton() {
        let vc = ViewController()
        showViewController(vc, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalGenerator.channel.registerListener(self) { vc, data in
            print("\(vc.id) - \(data)")
        }
    }
}

