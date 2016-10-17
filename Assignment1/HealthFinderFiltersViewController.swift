//
//  HealthFinderFiltersViewController.swift
//
//
//  Created by Dunchadhn Lyons on 10/16/16.
//
//

import UIKit

protocol HealthFinderFiltersDelegate {
    func filtersWereUpdated(gender: String, age: Int)
}

class HealthFinderFiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var agePickerView: UIPickerView!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var filtersSwitch: UISwitch!
    @IBOutlet var filtersView: UIView!
    
    
    var delegate:HealthFinderFiltersDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        agePickerView.delegate = self
        agePickerView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 65
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filtersDidChange(pickerView)
    }
    
    
    @IBAction func filtersDidChange(_ sender: AnyObject) {
        delegate?.filtersWereUpdated(gender: genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!, age: agePickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func switchDidChange(_ sender: AnyObject) {
        if (filtersSwitch.isOn) {
            filtersView.isHidden = false
        } else {
            filtersView.isHidden = true
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
