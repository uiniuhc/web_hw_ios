//
//  CommTableViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
var allHouseComm=Array<JSON>()
var allSenateComm=Array<JSON>()
var allJointComm=Array<JSON>()

class CommTableViewController: UIViewController  ,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate{
    var showingWho=""
    var currUsing=Array<JSON>()
    let searchBar=UISearchBar()
    let originalTitle=UILabel()
    var isSearching:Bool=false
    @IBOutlet weak var searchIcon: UIBarButtonItem!
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    @IBOutlet weak var myTabBarItem: UITabBarItem!
    @IBOutlet weak var myNaviItem: UINavigationItem!
    
    
    @IBAction func getMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func searchStart(_ sender: UIBarButtonItem) {
        if(!isSearching){
            print("searchStart")
            myNaviItem.titleView=searchBar
            searchIcon.image = #imageLiteral(resourceName: "Cancel-50")
            isSearching=true
        }else{
            //
            myNaviItem.titleView=originalTitle
            originalTitle.text="Bills"
            searchIcon.image = #imageLiteral(resourceName: "Search-50")
            isSearching=false
            cancelFilter()
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        searchBar.showsCancelButton=false
        searchBar.placeholder="filter with title"
        searchBar.delegate=self
        originalTitle.text="Bills"
        myTableView.delegate=self
        myTableView.dataSource=self
        print("ready to show")
        // Do any additional setup after loading the view.
        let url = URL(string:"http://cs-server.usc.edu:10365/uinuin_hw8_query.php?all_comm=1")!

        mySpinner.center=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        print("width: \(UIScreen.main.bounds.width)")
        print("height: \(UIScreen.main.bounds.height)")
        
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

        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///////////
    //load and filter load
    func loadData(json:JSON){
        if let my_title = myTabBarItem.title{
            if(my_title == "House"){
                allHouseComm.removeAll()
            }else if(my_title == "Senate"){
                allSenateComm.removeAll()
            }else if(my_title == "Joint"){
                allJointComm.removeAll()
            }
        }
        currUsing.removeAll()
        if let my_title = myTabBarItem.title{
            if let items = json["results"].array{
                for item in items{
                    if let chamber=item["chamber"].string{
                        if(chamber=="house" && my_title=="House"){
                            allHouseComm.append(item)
                            currUsing.append(item)
                        }else if(chamber=="senate" && my_title=="Senate"){
                            allSenateComm.append(item)
                            currUsing.append(item)
                        }else if (chamber=="joint" && my_title=="Joint"){
                            allJointComm.append(item)
                            currUsing.append(item)
                        }
                    }
                }
            }
        }
    }
    
    func loadWithFilter(items:Array<JSON>,f:String ){
        currUsing.removeAll()
        print("arrayLen: \(items.count) filter:\(f)")
        
        for item in items{
            if f==""{
                currUsing.append(item)
                continue
            }
            if let firstName=item["name"].string{
                print(firstName.lowercased())
                if firstName.lowercased().range(of: f) != nil{
                    currUsing.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
    func cancelFilter(){
        if let my_title = myTabBarItem.title{
            if(my_title == "House"){
                loadWithFilter(items: allHouseComm, f: "")
            }else if(my_title == "Senate"){
                loadWithFilter(items: allSenateComm, f: "")
            }else{
                loadWithFilter(items: allJointComm, f: "")
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currUsing.count>0 {
            return currUsing.count
        }
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommTableViewCell", for: indexPath) as! CommTableViewCell
        if currUsing.count==0 {
            cell.commID.text=""
            cell.commName.text=""
            
            return cell
        }
        
        //cell.legiState.text="haha"
        if let commName=currUsing[indexPath.row]["name"].string{
            cell.commName.text=commName
        }
        //cell.legiState.text="haha"
        if let commID=currUsing[indexPath.row]["committee_id"].string{
            cell.commID.text=commID
        }
 
        
        // Configure the cell...
        
        return cell
    }
    
    //search view
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var filter=""
        if searchBar.text != nil{
            filter=searchBar.text!.lowercased()
            
        }
        if let my_title = myTabBarItem.title{
            if(my_title == "House"){
                loadWithFilter(items: allHouseComm, f: filter)
            }else if(my_title == "Senate"){
                loadWithFilter(items: allSenateComm, f: filter)
            }else{
                loadWithFilter(items: allJointComm, f: filter)
            }
        }
        
        searchBar.endEditing(true)
    }

    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CommDetailViewController{
            let vc=segue.destination as! CommDetailViewController
            if let rowNum=myTableView.indexPathForSelectedRow?.row{
                if rowNum<currUsing.count{
                    vc.oneComm=OneComm()
                    let json=currUsing[rowNum]
                    if let committeeID=json["committee_id"].string{
                        vc.oneComm.committeeID=committeeID
                    }
                    if let committeeID=json["parent_committee_id"].string{
                        vc.oneComm.parentCommittee=committeeID
                    }
                    if let name=json["name"].string{
                        vc.oneComm.name=name
                    }
                    if let chamber=json["chamber"].string{
                        vc.oneComm.chamber=chamber
                    }
                    if let office=json["office"].string{
                        vc.oneComm.office=office
                    }
                    if let contact=json["phone"].string{
                        vc.oneComm.contact=contact
                    }
                    
                }
            }
        }
    }

    @IBAction func cancelToCommViewController(segue:UIStoryboardSegue) {
        
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
