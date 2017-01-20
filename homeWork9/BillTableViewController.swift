//
//  BillTableViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
var allNewBill=Array<JSON>()
var allActiveBill=Array<JSON>()
class BillTableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate{
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
        var url = URL(string:"http://cs-server.usc.edu:10365/uinuin_hw8_query.php?act_bill=1")!
        if let my_title = myTabBarItem.title{
            if(my_title == "New"){
                if allNewBill.count>0 {
                    return
                }
                url = URL(string:"http://cs-server.usc.edu:10365/uinuin_hw8_query.php?new_bill=1")!
            }else{
                if allActiveBill.count>0 {return}
            }
        }
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
    
    //////////////////////////////////////////
    //load and filter load
    func loadData(json:JSON){
        
        var isShowingNew:Bool=true
        if let my_title = myTabBarItem.title{
            if(my_title == "New"){
                allNewBill.removeAll()
                isShowingNew=true
            }else{
                allActiveBill.removeAll()
                isShowingNew=false
            }
        }
        currUsing.removeAll()
        if let items = json["results"].array{
            for item in items{
                
                if isShowingNew{
                    allNewBill.append(item)
                    currUsing.append(item)
                }else{
                    
                    allActiveBill.append(item)
                    currUsing.append(item)

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
            if let firstName=item["official_title"].string{
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
            if(my_title == "New"){
                loadWithFilter(items: allNewBill, f: "")
            }else{
                loadWithFilter(items: allActiveBill, f: "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
        if currUsing.count==0 {
            cell.billID.text=""
            cell.billTitle.text=""
            cell.billDate.text=""
            
            return cell
        }
        
        //cell.legiState.text="haha"
        if let billID=currUsing[indexPath.row]["bill_id"].string{
            cell.billID.text=billID
        }
        //cell.legiState.text="haha"
        if let billTitle=currUsing[indexPath.row]["official_title"].string{
            cell.billTitle.text=billTitle
        }
        //cell.legiState.text="haha"
        if let billDate=currUsing[indexPath.row]["introduced_on"].string{
            cell.billDate.text = changeDateFormat(mydate: billDate)
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
            if(my_title == "New"){
                loadWithFilter(items: allNewBill, f: filter)
            }else{
                loadWithFilter(items: allActiveBill, f: filter)
            }
        }
        
        searchBar.endEditing(true)
    }

//segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillDetailViewController{
            let vc=segue.destination as! BillDetailViewController
            if let rowNum=myTableView.indexPathForSelectedRow?.row{
                if rowNum<currUsing.count{
                    vc.oneBill=OneBill()
                    let json=currUsing[rowNum]
                    if let billID=json["bill_id"].string{
                        vc.oneBill.billID=billID
                    }
                    if let billTitle=json["official_title"].string{
                        vc.oneBill.officialTitle=billTitle
                    }
                    if let billType=json["bill_type"].string{
                        vc.oneBill.billType=billType
                    }
                    if let sponsorFirstName=json["sponsor"]["first_name"].string{
                        if let sponsorLastName=json["sponsor"]["last_name"].string{
                            let sponsor="\(sponsorLastName), \(sponsorFirstName)"
                            vc.oneBill.sponsor=sponsor
                        }
                    }
                    if let lastAction=json["last_action_at"].string{
                        vc.oneBill.lastAction=changeDateFormat(mydate: lastAction)
                    }
                    if let pdf=json["last_version"]["urls"]["pdf"].string{
                        vc.oneBill.pdf=pdf
                    }
                    if let chamber=json["chamber"].string{
                        vc.oneBill.chamber=chamber
                    }
                    if let lastVote=json["last_vote_at"].string{
                        vc.oneBill.lastVote = changeDateFormat(mydate: lastVote)
                        
                    }
                    if let date=json["introduced_on"].string{
                        vc.oneBill.date = changeDateFormat(mydate: date)
                    }
                    if let isActive=json["history"]["active"].bool{
                        if isActive{
                            vc.oneBill.status="Active"
                        }else{
                            vc.oneBill.status="New"
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func cancelToBillViewController(segue:UIStoryboardSegue) {
        
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
