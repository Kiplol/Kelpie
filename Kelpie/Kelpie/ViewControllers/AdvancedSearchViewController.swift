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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Helper
    class func fromStoryboard() -> AdvancedSearchViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: storyboardID) as? AdvancedSearchViewController else {
            fatalError("Check storyboard for missing AdvancedSearchViewController")
        }
        return vc
    }
    
    // MARK: - View Lifeccle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension AdvancedSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {// called when text starts editing
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { // return NO to not resign first responder
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { // called when text ends editing
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text changes (including clear)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // called when keyboard search button pressed
        searchBar.resignFirstResponder()
    }
}
