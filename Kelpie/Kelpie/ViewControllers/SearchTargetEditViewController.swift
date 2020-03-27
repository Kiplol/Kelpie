//
//  SearchTargetEditViewController.swift
//  Kelpie
//
//  Created by Elliott Kipper on 3/26/20.
//  Copyright © 2020 Kip. All rights reserved.
//

import Former
import UIKit

class SearchTargetEditViewController: FormViewController {

    private static let errorAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.red]
    
    // MARK: - ivars
    var searchTarget: SearchTarget? {
        didSet {
            self.title = self.searchTarget?.name ?? "New Search Target"
        }
    }
    private var hasChanges = false
    private var nameRow: TextFieldRowFormer<FormTextFieldCell>!
    private var urlRow: TextFieldRowFormer<FormTextFieldCell>!
    private var colorRow: LabelRowFormer<FormLabelCell>!
    private var color: UIColor = .kelpieAccent
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        self.title = self.searchTarget?.name ?? "New Search Target"
        super.viewDidLoad()
        self.parent?.presentationController?.delegate = self
        self.presentationController?.delegate = self
        self.buildForm()
        self.prepopulate()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                           action: #selector(SearchTargetEditViewController.actuallyDismiss))
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                            action: #selector(SearchTargetEditViewController.doneTapped(_:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = confirmButton
    }
    
    // MARK: - Form
    private func buildForm() {
        self.nameRow = TextFieldRowFormer<FormTextFieldCell>(instantiateType: .Class) { cell in
            cell.formTitleLabel()?.text = "Name"
        }.configure { rowFormer in
            rowFormer.placeholder = "Google"
            rowFormer.onTextChanged(self.onNameRowTextChanged(_:))
        }
        self.urlRow = TextFieldRowFormer<FormTextFieldCell>(instantiateType: .Class) { cell in
            cell.formTitleLabel()?.text = "URL"
        }.configure { rowFormer in
            rowFormer.placeholder = "https://www.google.com/search?q=\(SearchTarget.queryToken)"
            rowFormer.onTextChanged(self.onURLRowTextChanged(_:))
        }
        let urlExplanationRow = LabelRowFormer<FormLabelCell>(instantiateType: .Class) { cell in
            cell.formSubTextLabel()?.numberOfLines = 0
            cell.formSubTextLabel()?.lineBreakMode = .byWordWrapping
            cell.formSubTextLabel()?.textAlignment = .left
        }.configure { rowFormer in
            rowFormer.subText = "Replace your search term with \(SearchTarget.queryToken) in the URL."
        }
        self.colorRow = LabelRowFormer<FormLabelCell>(instantiateType: .Class, cellSetup: { cell in
            cell.formSubTextLabel()?.backgroundColor = self.color
        }).onSelected(self.onColorRowTapped(_:)).configure(handler: { rowFormer in
            rowFormer.text = "Color"
        })
        let section = SectionFormer(rowFormer: self.nameRow, self.urlRow, urlExplanationRow, self.colorRow)
        self.former.append(sectionFormer: section)
    }
    
    private func onNameRowTextChanged(_ text: String) {
        self.hasChanges = true
        let nameIsValid = self.nameIsValid()
        if !nameIsValid {
            self.title = "New Search Target"
            self.nameRow.cell.formTitleLabel()?.attributedText =
                NSAttributedString(string: "Name", attributes: SearchTargetEditViewController.errorAttributes)
        } else {
            self.title = text
            self.nameRow.cell.formTitleLabel()?.attributedText = NSAttributedString(string: "Name")
        }
    }
    
    private func onURLRowTextChanged(_ text: String) {
        self.hasChanges = true
        let isValid = self.urlIsValid()
        if isValid {
            self.urlRow.cell.formTitleLabel()?.attributedText = NSAttributedString(string: "URL")
        } else {
            self.urlRow.cell.formTitleLabel()?.attributedText =
                NSAttributedString(string: "URL", attributes: SearchTargetEditViewController.errorAttributes)
        }
    }
    
    private func onColorRowTapped(_ sender: Any) {
        let colorVC = ColorPickerViewController()
        self.show(colorVC, sender: self)
    }
    
    private func prepopulate() {
        guard self.isViewLoaded, let searchTarget = self.searchTarget else { return }
        self.nameRow.cell.textField.text = searchTarget.name
        self.urlRow.cell.textField.text = searchTarget.url
        self.colorRow.cell.formSubTextLabel()?.backgroundColor = self.color
    }
    
    // MARK: - Validation
    private func nameIsValid() -> Bool {
        return !(self.nameRow.cell.formTextField().text?.isEmpty ?? true)
    }
    
    private func urlIsValid() -> Bool {
        guard let string = self.urlRow.cell.formTextField().text else { return false }
        return URL(string: string.replacingOccurrences(of: SearchTarget.queryToken, with: "kelpie")) != nil
    }
    
    // MARK: - Navigation
    private func confirmDismiss() {
        let alert = UIAlertController(title: "You Have Unsaved Changes",
                                      message: "Your changes will be lost.  Are you sure you want to exit?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes, Exit", style: .destructive, handler: { _ in
            self.actuallyDismiss()
        }))
        alert.addAction(UIAlertAction(title: "Yikes, No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func actuallyDismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped(_ sender: Any) {
        guard self.nameIsValid(), self.urlIsValid(), let name = self.nameRow.cell.formTextField().text,
            let urlString = self.urlRow.cell.formTextField().text else {
                //@TODO: Error alert
                return
        }
         // Dupe check
        guard SearchTarget.named(name) == nil else {
            let dupeAlert = UIAlertController(title: "Duplicate",
                                              message: "There is already a search target named '\(name)'.  Please choose a different name.",
                preferredStyle: .alert)
            dupeAlert.addAction(UIAlertAction(title: "Ugh fine", style: .default, handler: { [weak self] _ in
                self?.nameRow.cell.textField.becomeFirstResponder()
            }))
            self.present(dupeAlert, animated: true, completion: nil)
            return
        }
        let newSearchTarget = SearchTarget(name: name, url: urlString)
        newSearchTarget.addToDefaultRealm()
        self.actuallyDismiss()
    }

}

extension SearchTargetEditViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        if let navigationController = self.navigationController {
            if navigationController.topViewController != self {
                return false
            }
        }
        return !self.hasChanges
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if self.hasChanges {
            self.confirmDismiss()
        }
    }
}
