//
//  BillDetailViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

 
var allFavoBill=Array<OneBill>()
func hasFavoBill(oneBill:OneBill) -> Bool{
    for oneFavoBill in allFavoBill{
        if oneBill.billID == oneFavoBill.billID {
            return true
        }
    }
    return false
}
func delFavoBill(oneBill:OneBill){
    for (index,oneFavoBill) in allFavoBill.enumerated(){
        if oneBill.billID == oneFavoBill.billID {
            allFavoBill.remove(at: index)
            return
        }
    }
}

class BillDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var billDetailTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    var oneBill = OneBill()
    let LegiDetailLabels=["Bill ID","Bill Type","Sponsor","Last Action","PDF","Chamber","Last Vote", "Status"]
    let LegiDetailNotShowButtons=[true,true,true,true,false,true,true,true]
    var legiDetailData=Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        billDetailTitle.text=oneBill.officialTitle
        
        legiDetailData.append(oneBill.billID)
        legiDetailData.append(oneBill.billType)
        legiDetailData.append(oneBill.sponsor)
        legiDetailData.append(oneBill.lastAction)
        legiDetailData.append(oneBill.pdf)
        legiDetailData.append(oneBill.chamber)
        legiDetailData.append(oneBill.lastVote)
        legiDetailData.append(oneBill.status)
        
        if hasFavoBill(oneBill: oneBill){
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
    
//////////////////////////////
    var shareURL=URL(string: "https://www.usc.edu")
    
    @IBAction func pressButtonToOpenPDF(_ sender: UIButton) {
        print("openpdf \(oneBill.pdf)")
        shareURL=URL(string: "\(oneBill.pdf)")
        UIApplication.shared.open(shareURL!, options: [:], completionHandler: nil)
        
    }
    
    /////////////
    @IBOutlet weak var favoButton: UIBarButtonItem!
    @IBAction func labelAsFavorite(_ sender: UIBarButtonItem) {
        if favoButton.image == #imageLiteral(resourceName: "Star-50"){
            favoButton.image = #imageLiteral(resourceName: "Star Filled-50")
            if(!hasFavoBill(oneBill: oneBill)){
                allFavoBill.append(oneBill)
            }
        }else{
            delFavoBill(oneBill: oneBill)
            favoButton.image = #imageLiteral(resourceName: "Star-50")
        }
        print(allFavoBill.count)
    }
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
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
//segue
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
