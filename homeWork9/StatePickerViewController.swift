//
//  StatePickerViewController.swift
//  HW9_MOBILE_CON
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit
var stateFilter:String="All"
class StatePickerViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate{

    
    @IBOutlet weak var statePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate=self
        statePicker.dataSource=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(states[row])
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(states[row])
        stateFilter=states[row]
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
