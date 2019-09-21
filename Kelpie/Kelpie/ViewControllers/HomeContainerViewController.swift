//
//  HomeContainerViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import KeyboardObserver
import UIKit

class HomeContainerViewController: UIViewController {
    
    enum ResultMode: CaseIterable {
        case quick, detailed
    }
    
    // MARK: - ivars
    private let keyboard = KeyboardObserver()
    private var homeViewController: HomeViewController!
    private var searchViewController: AdvancedSearchViewController!
    private var resultMode: ResultMode = .quick
    private var isFirstAppearance = true
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerHome: UIView!
    @IBOutlet weak var containerSearch: UIView!
    @IBOutlet weak var constraintSearchHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintBetweenBothCotainers: NSLayoutConstraint!
    
    // MARK: - View Lifecyce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let homeVC = self.children.filter({ (vc) -> Bool in
            vc is HomeViewController
        }).first as? HomeViewController else {
            fatalError("Check storyboard for missing HomeViewController")
        }
        self.homeViewController = homeVC
        
        guard let searchVC = self.children.filter({ (vc) -> Bool in
            vc is AdvancedSearchViewController
        }).first as? AdvancedSearchViewController else {
            fatalError("Check storyboard for missing AdvancedSearchViewController")
        }
        self.searchViewController = searchVC
        self.constraintBetweenBothCotainers.constant = -self.containerSearch.layer.cornerRadius
        self.constraintSearchHeight.constant = 20.0 + 44.0 + 20.0 + self.view.safeAreaInsets.bottom
        self.view.layoutIfNeeded()
        
        keyboard.observe { [weak self] event -> Void in
            self?.keyboardDidChange(event: event)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        switch self.keyboard.state {
        case .showing, .shown:
            break
        default:
            self.constraintSearchHeight.constant = self.searchViewController.searchBar.frame.maxY
                + 20.0 + self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - KeyboardObserver
    private func keyboardDidChange(event: KeyboardEvent) {
        switch event.type {
        case .willShow, .willHide, .willChangeFrame:
            let keyboardFrameEnd = event.keyboardFrameEnd
            let height = max(self.view.safeAreaInsets.bottom, self.view.bounds.size.height - keyboardFrameEnd.origin.y)
            self.constraintSearchHeight.constant = height + self.searchViewController.searchBar.frame.maxY
                + 20.0
            self.view.layoutIfNeeded()
        default:
            break
        }
    }

}
