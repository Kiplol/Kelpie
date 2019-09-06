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
        }).first else {
            fatalError("Check storyboard for missing HomeViewController")
        }
        self.homeViewController = (homeVC as! HomeViewController)
        
        guard let searchVC = self.children.filter({ (vc) -> Bool in
            vc is AdvancedSearchViewController
        }).first else {
            fatalError("Check storyboard for missing AdvancedSearchViewController")
        }
        self.searchViewController = (searchVC as! AdvancedSearchViewController)
        
        self.constraintSearchHeight.constant = 20.0 + 44.0 + 20.0 + self.view.safeAreaInsets.bottom
        self.constraintBetweenBothCotainers.constant = -self.containerSearch.layer.cornerRadius
        self.view.layoutIfNeeded()
        
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let keyboardFrameEnd = event.keyboardFrameEnd
                let height = keyboardFrameEnd.height
                self.constraintSearchHeight.constant = height + self.searchViewController.textFieldSearch.frame.maxY
                    + 20.0
                self.view.layoutIfNeeded()
            default:
                break
            }
        }

    }

}
