//
//  ViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import KeyboardObserver
import UIKit

class ViewController: UIViewController {
    
    // MARK: - ivars
    let keyboard = KeyboardObserver()
    
    // MARK: - IBOutlets
    @IBOutlet weak var textfieldContainer: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    // MARK: - View Lifeccle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let bottom = min(keyboardFrameEnd.minY, self.view.bounds.size.height - self.view.safeAreaInsets.bottom)
                
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.textfieldContainer.frame.origin.y = bottom - self.textfieldContainer.bounds.size.height
                }, completion: nil)
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldSearch.becomeFirstResponder()
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTarget.getOrMakeIMDb().executeSearch(query: textField.text ?? "")
        return false
    }
}

