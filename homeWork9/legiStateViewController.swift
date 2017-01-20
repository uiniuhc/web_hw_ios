//
//  legiStateViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

var allLegi=Array<JSON>()
class legiStateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var currUsing=Array<JSON>()
    var sectionUsing=Array<Array<JSON>>()
    var sectionTitle=Array<String>()
    var withSection=true
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    func loadData(json:JSON){
        allLegi.removeAll()
        currUsing.removeAll()
        sectionTitle.removeAll()
        sectionUsing.removeAll()
        var nowSectionArray=Array<JSON>()
        var lastSectionTitle="A"
        if let items = json["results"].array{
            for item in items{
                allLegi.append(item)
                currUsing.append(item)
                if let state=item["state_name"].string{
                    let pre=String(state[state.startIndex])
                    if pre==lastSectionTitle{
                        nowSectionArray.append(item)
                    }else{
                        sectionUsing.append(nowSectionArray)
                        sectionTitle.append(lastSectionTitle)
                        lastSectionTitle=pre
                        nowSectionArray=Array<JSON>()
                        nowSectionArray.append(item)
                    }
                }
            }
            sectionUsing.append(nowSectionArray)
            //sectionTitle.append(lastSectionTitle)
        }
        
    }
    func loadWithFilter(items:Array<JSON>,f:String ){
        withSection=false;
        currUsing.removeAll()
        for item in items{
            if f=="All"{
                currUsing.append(item)
                withSection=true
                continue
            }
            if let state_abbr=item["state"].string{
                if state_abbr==statesDictionary[f]{
                        currUsing.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
    
    @IBAction func getMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myTableView.delegate=self
        myTableView.dataSource=self
        // Do any additional setup after loading the view.
        if currUsing.count>0 {
            return
        }
        mySpinner.center=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        print("width: \(UIScreen.main.bounds.width)")
        print("height: \(UIScreen.main.bounds.height)")
        let url = URL(string:"http://cs-server.usc.edu:10365/uinuin_hw8_query.php?all_legi_state=1")!
        mySpinner.startAnimating()
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result.isSuccess {
                
            case true:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.loadData(json: json)
                    print("get data")
                    if let counts=json["count"].number{
                        print("get result",counts)
                        self.myTableView.reloadData()
                    }
                }
                self.mySpinner.stopAnimating()
            case false:
                self.mySpinner.stopAnimating()
                print(response.result.error ?? "error")
            }
        }

    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if withSection{
            return sectionTitle
        }
        return Array<String>()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if withSection{
            return sectionTitle.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if withSection{
            return sectionTitle[section]
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if withSection{
            return sectionUsing[section].count
        }
        if allLegi.count>0 {
            return currUsing.count
        }
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if withSection{
            let sectionCurrUsing = sectionUsing[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegiTableViewCell", for: indexPath) as! LegiTableViewCell
            if sectionCurrUsing.count==0 {
                cell.legiName.text=""
                cell.legiState.text=""
                return cell
            }
            var name:String=""
            if let fName=sectionCurrUsing[indexPath.row]["first_name"].string{
                if let lName=sectionCurrUsing[indexPath.row]["last_name"].string{
                    name="\(lName), \(fName)"
                }
            }
            cell.legiName.text=name
            //cell.legiState.text="haha"
            if let stateName=sectionCurrUsing[indexPath.row]["state_name"].string{
                cell.legiState.text=stateName
            }
            if let bioID=sectionCurrUsing[indexPath.row]["bioguide_id"].string{

                Alamofire.request("https://theunitedstates.io/images/congress/225x275/\(bioID).jpg").responseImage { response in
                    if let image = response.result.value {
                        cell.legiImage.image=image
                            
                    }
                }

            }
            return cell
        
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LegiTableViewCell", for: indexPath) as! LegiTableViewCell
        if currUsing.count==0 {
            cell.legiName.text=""
            cell.legiState.text=""
            return cell
        }
        var name:String=""
        if let fName=currUsing[indexPath.row]["first_name"].string{
            if let lName=currUsing[indexPath.row]["last_name"].string{
                name="\(lName), \(fName)"
            }
        }
        cell.legiName.text=name
        //cell.legiState.text="haha"
        if let stateName=currUsing[indexPath.row]["state_name"].string{
            cell.legiState.text=stateName
        }
        if let bioID=currUsing[indexPath.row]["bioguide_id"].string{
            Alamofire.request("https://theunitedstates.io/images/congress/225x275/\(bioID).jpg").responseImage { response in
                if let image = response.result.value {
                    cell.legiImage.image=image
                    
                }
            }
        }
        // Configure the cell...
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if withSection{
            if segue.destination is LegiDetailViewController{
            let vc=segue.destination as! LegiDetailViewController
            if let rowNum=myTableView.indexPathForSelectedRow?.row{
                if let secNum=myTableView.indexPathForSelectedRow?.section{
                    vc.oneLegi=OneLegi()
                    let json=sectionUsing[secNum][rowNum]
                    if let bioID=json["bioguide_id"].string{
                        vc.oneLegi.bioID=bioID
                    }
                    if let firstName=json["first_name"].string{
                        vc.oneLegi.firstName=firstName
                    }
                    if let lastName=json["last_name"].string{
                        vc.oneLegi.lastName=lastName
                    }
                    if let state=json["state_name"].string{
                        vc.oneLegi.state=state
                    }
                    if let birthDate=json["birthday"].string{
                        vc.oneLegi.birthDate=birthDate
                    }
                    if let gender=json["gender"].string{
                        vc.oneLegi.gender=gender
                    }
                    if let chamber=json["chamber"].string{
                        vc.oneLegi.chamber=chamber
                    }
                    if let faxNo=json["fax"].string{
                        vc.oneLegi.faxNo=faxNo
                    }
                    if let twitter=json["twitter_id"].string{
                        vc.oneLegi.twitter=twitter
                    }
                    if let facebook=json["facebook_id"].string{
                        vc.oneLegi.facebook=facebook
                    }
                    if let website=json["website"].string{
                        vc.oneLegi.website=website
                    }
                    if let officeNo=json["office"].string{
                        vc.oneLegi.officeNo=officeNo
                    }
                    if let termEndsOn=json["term_end"].string{
                        vc.oneLegi.termEndsOn=termEndsOn
                    }
                    if let party=json["party"].string{
                        vc.oneLegi.party=party
                    }
                }
            }
            }
        }else{
            if segue.destination is LegiDetailViewController{
                let vc=segue.destination as! LegiDetailViewController
                if let rowNum=myTableView.indexPathForSelectedRow?.row{
                        vc.oneLegi=OneLegi()
                        let json=currUsing[rowNum]
                        if let bioID=json["bioguide_id"].string{
                            vc.oneLegi.bioID=bioID
                        }
                        if let firstName=json["first_name"].string{
                            vc.oneLegi.firstName=firstName
                        }
                        if let lastName=json["last_name"].string{
                            vc.oneLegi.lastName=lastName
                        }
                        if let state=json["state_name"].string{
                            vc.oneLegi.state=state
                        }
                        if let birthDate=json["birthday"].string{
                            vc.oneLegi.birthDate=birthDate
                        }
                        if let gender=json["gender"].string{
                            vc.oneLegi.gender=gender
                        }
                        if let chamber=json["chamber"].string{
                            vc.oneLegi.chamber=chamber
                        }
                        if let faxNo=json["fax"].string{
                            vc.oneLegi.faxNo=faxNo
                        }
                        if let twitter=json["twitter_id"].string{
                            vc.oneLegi.twitter=twitter
                        }
                        if let facebook=json["facebook_id"].string{
                            vc.oneLegi.facebook=facebook
                        }
                        if let website=json["website"].string{
                            vc.oneLegi.website=website
                        }
                        if let officeNo=json["office"].string{
                            vc.oneLegi.officeNo=officeNo
                        }
                        if let termEndsOn=json["term_end"].string{
                            vc.oneLegi.termEndsOn=termEndsOn
                        }
                        if let party=json["party"].string{
                            vc.oneLegi.party=party
                        }
                    
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func saveLegiStateFilter(segue:UIStoryboardSegue) {
        loadWithFilter(items: allLegi,f: stateFilter)
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
