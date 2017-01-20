//
//  LegiViewController.swift
//  
//
//  Created by Zhang.Hanqiu on 11/28/16.
//
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

var allHouseLegi=Array<JSON>()
var allSenateLegi=Array<JSON>()
class LegiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate{
    var currUsing=Array<JSON>()
    
    
    //@IBOutlet weak var tabLabel: UITabBarItem!
    func loadData(json:JSON){
        //allLegi.removeAll()
        if let my_title = myTabBarItem.title{
            if(my_title == "Senate"){
                allSenateLegi.removeAll()
            }else{
                allHouseLegi.removeAll()
            }
        }
        currUsing.removeAll()
        var senate:Bool=true
        if let my_title = myTabBarItem.title{
            if(my_title == "Senate"){
                senate=true
            }else{
                senate=false
            }
        }
        if let items = json["results"].array{
            for item in items{
                //allLegi.append(item)
                if senate{
                    if let chamber=item["chamber"].string{
                        if chamber=="senate"{
                            allSenateLegi.append(item)
                            currUsing.append(item)
                        }
                    }
                }else{
                    if let chamber=item["chamber"].string{
                        if chamber=="house"{
                            allHouseLegi.append(item)
                            currUsing.append(item)
                        }
                    }
                }
            }
        }
    }
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    @IBOutlet weak var myTabBarItem: UITabBarItem!
    @IBOutlet weak var searchIcon: UIBarButtonItem!
    @IBOutlet weak var myNaviItem: UINavigationItem!
    
    let searchBar=UISearchBar()
    let originalTitle=UILabel()
    var isSearching:Bool=false
    @IBAction func searchStart(_ sender: Any) {
        if(!isSearching){
            print("searchStart")
            myNaviItem.titleView=searchBar
            searchIcon.image = #imageLiteral(resourceName: "Cancel-50")
            isSearching=true
        }else{
            //
            myNaviItem.titleView=originalTitle
            originalTitle.text="Legislators"
            searchIcon.image = #imageLiteral(resourceName: "Search-50")
            isSearching=false
            cancelFilter()
        }
    }
    @IBAction func getMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    func cancelFilter(){
        if let my_title = myTabBarItem.title{
            if(my_title == "Senate"){
                loadWithFilter(items: allSenateLegi, f: "")
            }else{
                loadWithFilter(items: allHouseLegi, f: "")
            }
        }
    }
    @IBAction func searchStart2(_ sender: Any) {
        if(!isSearching){
            print("searchStart")
            myNaviItem.titleView=searchBar
            searchIcon.image = #imageLiteral(resourceName: "Cancel-50")
            isSearching=true
        }else{
            //
            myNaviItem.titleView=originalTitle
            originalTitle.text="Legislators"
            searchIcon.image = #imageLiteral(resourceName: "Search-50")
            isSearching=false
            cancelFilter()
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
            if let firstName=item["first_name"].string{
                print(firstName.lowercased())
                if firstName.lowercased().range(of: f) != nil{
                    currUsing.append(item)
                }
            }
        }
        myTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton=false
        searchBar.placeholder="filter with first Name"
        searchBar.delegate=self
        originalTitle.text="Legislators"
        myTableView.delegate=self
        myTableView.dataSource=self
        print("ready to show")
        // Do any additional setup after loading the view.

        /*
        if let my_title = myTabBarItem.title{
            if(my_title == "Senate"){
                if allSenateLegi.count>0 {return}
            }else{
                if allHouseLegi.count>0 {return}
            }
        }*/
        if currUsing.count>0 {
            return
        }
        mySpinner.center=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        print("width: \(UIScreen.main.bounds.width)")
        print("height: \(UIScreen.main.bounds.height)")
        let url = URL(string:"http://cs-server.usc.edu:10365/uinuin_hw8_query.php?all_legi=1")!
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
            if(my_title == "Senate"){
                loadWithFilter(items: allSenateLegi, f: filter)
            }else{
                loadWithFilter(items: allHouseLegi, f: filter)
            }
        }
        
        searchBar.endEditing(true)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LegiDetailViewController{
            let vc=segue.destination as! LegiDetailViewController
            if let rowNum=myTableView.indexPathForSelectedRow?.row{
                if rowNum<currUsing.count{
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
