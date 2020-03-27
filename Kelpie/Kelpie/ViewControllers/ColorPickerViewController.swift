//
//  ColorPickerViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 3/27/20.
//  Copyright © 2020 Kip. All rights reserved.
//

import UIKit

class ColorPickerViewController: KelpieViewController {
    
    // MARK: - ivars
    var color: UIColor = .kelpieAccent
    
    // MARK: - Initializers
    convenience init(color: UIColor) {
        self.init()
        self.color = color
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick a Color"
        self.view.backgroundColor = .systemBackground
    }

}
