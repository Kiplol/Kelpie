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
    
    // MARK: - Helpers
    class func with(color: UIColor?) -> ColorPickerViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "colorPicker") as? ColorPickerViewController else {
            fatalError("Could not instantiate a \(self) from Storyboard.")
        }
        if let color = color {
            vc.color = color
        }
        return vc
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick a Color"
    }

}
