//
//  mainViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToLegiStateViewController(segue:UIStoryboardSegue) {
        
    }
    var sel=0
    override func viewWillDisappear(_ animated: Bool) {
        print("\(self.selectedIndex) is selected ")
        sel=self.selectedIndex
    }
    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex=sel
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
