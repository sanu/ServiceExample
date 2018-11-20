//
//  ViewController.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //https://itunes.apple.com/search?term=jackjohnson&entity=musicVideo&limit=5
        
    }
    
    
    @IBAction func actionn(_ sender: Any) {
        
        Media.loadMediaTypes(keyword: "jackjohnson", entity: "musicVideo").done { (responseArray) in
            print("responseArray >>> \(responseArray)")
            }.catch { (error) in
                print("error \(error)")
            }.finally {
                print("Finallyy")
        }
        
    }
    

}

