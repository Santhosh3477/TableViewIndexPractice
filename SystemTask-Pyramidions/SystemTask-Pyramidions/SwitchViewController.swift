//
//  SwitchViewController.swift
//  SystemTask-Pyramidions
//
//  Created by Santhosh on 03/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit
import Foundation

class SwitchViewController: UIViewController, addIndexDelegate {
    
    // Index dictionary with keys holding the section header switch states and the values holding an array of row values based on index
    var indexesDict = [[0, 0, 0 , 0] : [[0, 0 , 0], [0, 0 , 0, 0, 0], [0, 0 , 0, 0], [0, 0 , 0, 0, 0, 0, 0]]]
    
    // Tableview to list the indexes with section
    @IBOutlet weak var indexListTableView : UITableView!

    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Tableview section and row switch value update methods
    
    /// Selector method called when tableview header switch value changed
    /// - Parameter sender: tableview header UISwitch
    @objc func sectionHeaderSwitchUIUpdate(sender : UISwitch) {
        let sectionarr = Array(indexesDict.keys)[0]
        let rowsArr = Array(indexesDict.values)[0]
        let rowArr = rowsArr[sender.tag]
        let result = (sectionarr[sender.tag] == 1) ? 0 : 1
        let tempSectionArr = NSMutableArray(array: sectionarr)
        tempSectionArr.replaceObject(at: sender.tag, with: result)
        var arr = [Int]()
        for _ in 0..<rowArr.count {
            arr.append(result)
        }
        let tempRowArr = NSMutableArray(array: rowsArr)
        tempRowArr.replaceObject(at: sender.tag, with: arr)
        indexesDict = [tempSectionArr as! [Int] : tempRowArr as! [[Int]]]
        DispatchQueue.main.async {
            print("Reloading data")
            self.indexListTableView.reloadData()
        }
    }
    
    /// Selector method called when tableview row switch value changed
    /// - Parameter sender: tableview row UISwitch
    @objc func updateIndexDictForSection(sender : UISwitch) {
        let rowsArr = Array(indexesDict.values)[0]
        let sectionArr = Array(indexesDict.keys)[0]
        let rowsCount = self.indexListTableView.numberOfRows(inSection: sender.tag)
        var selectedcount : Int = 0
        var unSelectedcount : Int = 0
        var rowArr = [Int]()
        for i in 0..<rowsCount  {
            guard let cell = self.indexListTableView.cellForRow(at: IndexPath(row: i, section: sender.tag)) as? CustomTableViewCell
            else {
                rowArr.append(rowsArr[sender.tag][i])
                continue
            }
            let result = cell.switchButton.isOn ? 1 : 0
            rowArr.append(result)
            selectedcount = selectedcount + (cell.switchButton.isOn ? 1 : 0)
            unSelectedcount = unSelectedcount + (cell.switchButton.isOn ? 0 : 1)
        }
        let tempRowArr = NSMutableArray(array: rowsArr)
        tempRowArr.replaceObject(at: sender.tag, with: rowArr)
        indexesDict.removeAll()
        indexesDict = [sectionArr : tempRowArr as! [[Int]]]

        if (rowsCount == selectedcount || rowsCount == unSelectedcount) {
            let tempSectionArr = NSMutableArray(array: sectionArr)
            let result = (rowsCount == selectedcount) ? 1 : 0
            tempSectionArr.replaceObject(at: sender.tag, with: result)
            indexesDict = [tempSectionArr as! [Int] : tempRowArr as! [[Int]]]
            DispatchQueue.main.async {
                self.indexListTableView.reloadData()
            }
        }
    }

    // MARK: Index addition delegate method
    func addedRowWithSectionIndex(_ sectionIndex: Int) {
        let rowsArr = Array(indexesDict.values)[0]
        var rowArr = rowsArr[sectionIndex]
        rowArr.append(0)
        let arr = NSMutableArray(array: rowsArr)
        arr.replaceObject(at: sectionIndex, with: rowArr)
        let sectionarr = Array(indexesDict.keys)[0]
        indexesDict.removeAll()
        indexesDict = [sectionarr : arr as! [[Int]]]
        DispatchQueue.main.async {
            self.indexListTableView.reloadData()
        }
    }
    
    // MARK: IBOutlet Button Actions
    /// Navigation Left bar button Item - Add button action
    /// - Parameter sender: UIButton
    @IBAction func AddIndexaction(_ sender: Any) {
        guard let addindexVC = self.storyboard?.instantiateViewController(identifier: "AddIndexViewController") as? AddIndexViewController else { return }
        addindexVC.delegate = self
        self.navigationController?.pushViewController(addindexVC, animated: true)
    }

}

// MARK: Tableview Datasource and Delegate Methods
extension SwitchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(indexesDict.keys)[0].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: 20, y: 0, width: 100, height: 50)
        headerTitle.text = "Section \(section)"
        
        let headerSwitch = UISwitch()
        headerSwitch.frame = CGRect(x: tableView.frame.size.width - 71, y: 11, width: 51, height: 31)
        headerSwitch.tag = section
        let arr = Array(indexesDict.keys)[0]
        if (arr[section] == 0) {
            headerSwitch.setOn(false, animated: false)
        } else {
            headerSwitch.setOn(true, animated: false)
        }
        headerSwitch.addTarget(self, action: #selector(sectionHeaderSwitchUIUpdate(sender:)), for: .valueChanged)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        headerView.addSubview(headerTitle)
        headerView.addSubview(headerSwitch)
        headerView.backgroundColor = UIColor.lightGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(indexesDict.values)[0][section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell") as? CustomTableViewCell else { return UITableViewCell() }
        cell.rowIndexLabel.text = "row \(indexPath.row + 1)"
        let arr = Array(indexesDict.values)[0][indexPath.section]
        if (arr[indexPath.row] == 0) {
            cell.switchButton.setOn(false, animated: false)
        } else {
            cell.switchButton.setOn(true, animated: false)
        }
        cell.switchButton.tag = indexPath.section
        cell.switchButton.addTarget(self, action: #selector(updateIndexDictForSection(sender:)), for: .valueChanged)
        return cell
    }
}
