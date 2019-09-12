//
//  ViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import KeyboardObserver
import UIKit

class AdvancedSearchViewController: UIViewController {
    
    static let storyboardID = "AdvancedSearch"
    
    // MARK: - ivars
    let keyboard = KeyboardObserver()
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldSearch: UITextField!
    
    // MARK: - Helper
    class func fromStoryboard() -> AdvancedSearchViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: storyboardID) as! AdvancedSearchViewController
    }
    
    // MARK: - View Lifeccle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.textFieldSearch.becomeFirstResponder()
    }


}

extension AdvancedSearchViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        SearchTarget.getOrMakeIMDb().executeSearch(query: textField.text ?? "")
        textField.resignFirstResponder()
        return false
    }
}

