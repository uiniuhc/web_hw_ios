//
//  FavoBillViewController.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/29/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

class FavoBillViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate{

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var searchIcon: UIBarButtonItem!
    
    
    @IBOutlet weak var myNaviItem: UINavigationItem!
    let searchBar=UISearchBar()
    let originalTitle=UILabel()
    var isSearching:Bool=false
    var currUsing=Array<OneBill>()
    
    @IBAction func getMenu(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func searchStart(_ sender: UIBarButtonItem!) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(items: allFavoBill)
        myTableView.dataSource=self
        myTableView.delegate=self
        searchBar.delegate=self
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(items: Array<OneBill>){
        print("reload for favo \(items.count)")
        currUsing.removeAll()
        for item in items{
            currUsing.append(item)
        }
        print("reload for favo \(currUsing.count)")
    }
    func cancelFilter(){
        loadWithFilter(items: allFavoBill, f: "")
    }
    func loadWithFilter(items:Array<OneBill>,f:String ){
        currUsing.removeAll()
        print("arrayLen: \(items.count) filter:\(f)")
        
        for item in items{
            if f==""{
                currUsing.append(item)
                continue
            }
            let firstName=item.officialTitle
            print(firstName.lowercased())
            if firstName.lowercased().range(of: f) != nil{
                currUsing.append(item)
            }
            
        }
        myTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        loadWithFilter(items: allFavoBill, f: filter)
        
        
        searchBar.endEditing(true)
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
        
        
        cell.billID.text=currUsing[indexPath.row].billID
        cell.billTitle.text=currUsing[indexPath.row].officialTitle
        cell.billDate.text=currUsing[indexPath.row].date
        //cell.legiState.text="haha"

        
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillDetailViewController{
            let vc=segue.destination as! BillDetailViewController
            
            if let rowNum=myTableView.indexPathForSelectedRow?.row{
                if rowNum<currUsing.count{
                    vc.oneBill=currUsing[rowNum]
                }
            }
        }
    }
    @IBAction func cancelToFavoBillViewController(segue:UIStoryboardSegue) {
      
        print("will appear")
        loadData(items: allFavoBill)
        myTableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData(items: allFavoBill)
        myTableView.reloadData()
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
