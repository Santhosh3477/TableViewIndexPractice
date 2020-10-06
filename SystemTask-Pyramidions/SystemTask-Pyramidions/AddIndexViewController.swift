//
//  AddIndexViewController.swift
//  SystemTask-Pyramidions
//
//  Created by Santhosh on 03/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit

protocol addIndexDelegate : AnyObject {
    func addedRowWithSectionIndex(_ sectionIndex : Int)
}

class AddIndexViewController: UIViewController {

    // Dictionary of indexes with keys holding the section index and values containing an array of boolean values mapping the tableview row switch ON/OFF state
    var sectionCount : Int = 0
    
    // Index addition delegate object
    weak var delegate : addIndexDelegate?
    
    // Index selected by the user stored to add row in add action
    var selectedIndex : Int = 0
    
    // Section list stack view
    @IBOutlet weak var sectionStackview: UIStackView!
    
    // Section list button outlet collection
    @IBOutlet var sectionButtons: [UIButton]!
    // Section list stack view top constraint to animate dropdown
    @IBOutlet weak var stackViewTopconstraint: NSLayoutConstraint!
    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }


    // MARK: IBOutlet Button Actions
    /// Navigation Left bar button Item - Add button action
    /// - Parameter sender: UIButton
    @IBAction func AddTableViewRow(_ sender: Any) {
        self.delegate?.addedRowWithSectionIndex(selectedIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// Dropdown select/unselect button action
    /// - Parameter sender: UIButton
    @IBAction func dropdownAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTopconstraint.constant = !sender.isSelected ? -200 : 5
            self.view.layoutIfNeeded()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }, completion: nil)
        

    }
    
    
    /// Dropdown list options selection action
    /// - Parameter sender: UIButton
    @IBAction func sectionSelectAction(_ sender: UIButton) {
        selectedIndex = sender.tag
        resetBackgroundforSections()
        sender.backgroundColor = UIColor.lightGray
    }
    
    
    /// Method to reset the section options list background before setting the selected cell
    func resetBackgroundforSections(){
        for button in sectionButtons {
            button.backgroundColor = UIColor.white
        }
    }

}

