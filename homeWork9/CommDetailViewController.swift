//
//  CommDetailViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

var allFavoComm=Array<OneComm>()
func hasFavoComm(oneComm:OneComm) -> Bool{
    for oneFavoComm in allFavoComm{
        if oneComm.committeeID == oneFavoComm.committeeID {
            return true
        }
    }
    return false
}
func delFavoComm(oneComm:OneComm){
    for (index,oneFavoComm) in allFavoComm.enumerated(){
        if oneComm.committeeID == oneFavoComm.committeeID {
            allFavoComm.remove(at: index)
            return
        }
    }
}

class CommDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var commDetailTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var favoButton: UIBarButtonItem!
    
    var oneComm = OneComm()
    let LegiDetailLabels=["Committee ID","Parent Committee","Chamber","Office","Contact"]
    let LegiDetailNotShowButtons=[true,true,true,true,true]
    var legiDetailData=Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()

        commDetailTitle.text=oneComm.name
        
        legiDetailData.append(oneComm.committeeID)
        legiDetailData.append(oneComm.parentCommittee)
        legiDetailData.append(oneComm.chamber)
        legiDetailData.append(oneComm.office)
        legiDetailData.append(oneComm.contact)
        
        if hasFavoComm(oneComm: oneComm){
            favoButton.image = #imageLiteral(resourceName: "Star Filled-50")
        }
        myTableView.delegate=self
        myTableView.dataSource=self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func labelAsFavorite(_ sender: UIBarButtonItem) {
        if favoButton.image == #imageLiteral(resourceName: "Star-50"){
            favoButton.image = #imageLiteral(resourceName: "Star Filled-50")
            if(!hasFavoComm(oneComm: oneComm)){
                allFavoComm.append(oneComm)
            }
        }else{
            delFavoComm(oneComm: oneComm)
            favoButton.image = #imageLiteral(resourceName: "Star-50")
        }
        print(allFavoComm.count)
    }
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LegiDetailTableViewCell", for: indexPath) as! LegiDetailTableViewCell
        // Configure the cell...
        let rowNum=indexPath.row
        cell.legiDetailLabel.text=LegiDetailLabels[rowNum]
        cell.legiDetailButton.isHidden=LegiDetailNotShowButtons[rowNum]
        cell.legiDetailButton.setTitle(LegiDetailLabels[rowNum], for: .normal)
        //cell.legiDetailButton.titleLabel=LegiDetailLabels[rowNum]
        cell.legiDetaiContent.isHidden = !LegiDetailNotShowButtons[rowNum]
        cell.legiDetaiContent.text=legiDetailData[rowNum]
        if !LegiDetailNotShowButtons[rowNum]{
            if legiDetailData[rowNum] != ""{
                
            }else{
                cell.legiDetailButton.isEnabled=false
            }
        }else{
            if legiDetailData[rowNum] == ""{
                cell.legiDetaiContent.text="N.A"
            }
        }
        return cell
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
