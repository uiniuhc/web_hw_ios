//
//  LegiDetailViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit
import SwiftyJSON

var allFavoLegi=Array<OneLegi>()
func hasFavoLegi(oneLegi:OneLegi) -> Bool{
    for oneFavoLegi in allFavoLegi{
        if oneLegi.bioID == oneFavoLegi.bioID {
            return true
        }
    }
    return false
}
func delFavoLegi(oneLegi:OneLegi){
    for (index,oneFavoLegi) in allFavoLegi.enumerated(){
        if oneLegi.bioID == oneFavoLegi.bioID {
            allFavoLegi.remove(at: index)
            return
        }
    }
}

class LegiDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    

    
    var oneLegi=OneLegi()
    @IBOutlet weak var legiImage: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    let LegiDetailLabels=["First Name","Last Name","State","Gender","Birth Date","Chamber","Fax", "Twitter","Facebook","Website","Office","End of Term"]
    let LegiDetailNotShowButtons=[true,true,true,true,true,true,true,false,false,false,true,true]
    var legiDetailData=Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        if oneLegi.bioID != ""{
            if let url=URL(string: "https://theunitedstates.io/images/congress/225x275/\(oneLegi.bioID).jpg"){
                if let data=NSData(contentsOf: url ){
                    legiImage.image=UIImage(data:data as Data )
                }
            }
        }
        legiDetailData.append(oneLegi.firstName)
        legiDetailData.append(oneLegi.lastName)
        legiDetailData.append(oneLegi.state)
        legiDetailData.append(oneLegi.gender)
        legiDetailData.append(oneLegi.birthDate)
        legiDetailData.append(oneLegi.chamber)
        legiDetailData.append(oneLegi.faxNo)
        legiDetailData.append(oneLegi.twitter)
        legiDetailData.append(oneLegi.facebook)
        legiDetailData.append(oneLegi.website)
        legiDetailData.append(oneLegi.officeNo)
        legiDetailData.append(oneLegi.termEndsOn)
        myTableView.delegate=self
        myTableView.dataSource=self
        if hasFavoLegi(oneLegi: oneLegi){
            favoButton.image = #imageLiteral(resourceName: "Star Filled-50")
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    @IBOutlet weak var favoButton: UIBarButtonItem!
    @IBAction func labelAsFavorite(_ sender: UIBarButtonItem) {
        if favoButton.image == #imageLiteral(resourceName: "Star-50"){
            favoButton.image = #imageLiteral(resourceName: "Star Filled-50")
            if(!hasFavoLegi(oneLegi: oneLegi)){
                allFavoLegi.append(oneLegi)
            }
        }else{
            delFavoLegi(oneLegi: oneLegi)
            favoButton.image = #imageLiteral(resourceName: "Star-50")
        }
        print(allFavoLegi.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
    }

    var shareURL=URL(string: "https://twitter.com")
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
        if LegiDetailLabels[rowNum]=="Birth Date" || LegiDetailLabels[rowNum]=="End of Term"{
            cell.legiDetaiContent.text = changeDateFormat(mydate: legiDetailData[rowNum])
        }
        if LegiDetailLabels[rowNum]=="Gender"{
            if legiDetailData[rowNum] == "M"{
                cell.legiDetaiContent.text = "Male"
            }
            if legiDetailData[rowNum] == "F"{
                cell.legiDetaiContent.text = "Female"
            }
            
        }
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


    @IBAction func openURLForLegis(_ sender: UIButton) {
        if sender.titleLabel?.text == "Twitter"{
            shareURL=URL(string: "https://www.twitter.com/\(legiDetailData[7])")
            print("tw")
            UIApplication.shared.open(shareURL!, options: [:], completionHandler: nil)
        }else if sender.titleLabel?.text == "Facebook"{
            shareURL=URL(string: "https://www.facebook.com/\(legiDetailData[8])")
            print("fb")
            UIApplication.shared.open(shareURL!, options: [:], completionHandler: nil)
        }else if sender.titleLabel?.text == "Website"{
            shareURL=URL(string: "\(legiDetailData[9])")
            print("wb")
            UIApplication.shared.open(shareURL!, options: [:], completionHandler: nil)
        }else{
            print("no title \(sender.titleLabel)")
        }
        print("\(shareURL)")
        

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
