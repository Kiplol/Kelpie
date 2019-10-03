//
//  KelpieViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 10/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import KeyboardObserver
import UIKit

class KelpieViewController: UIViewController {
    
    // MARK: - ivars
    let keyboard = KeyboardObserver()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.observe { [weak self] event -> Void in
            self?.keyboardDidChange(event: event)
        }
    }
    
    // MARK: - KeyboardObserver
    open func keyboardDidChange(event: KeyboardEvent) {
        //Overide
    }
}
