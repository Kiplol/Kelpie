//
//  HomeViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    static let storyboardID = "Home"
    
    // MARK: - Helper
    class func fromStoryboard() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: storyboardID) as! HomeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
