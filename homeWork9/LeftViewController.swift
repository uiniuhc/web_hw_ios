//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import SlideMenuControllerSwift
enum LeftMenu: Int {
    case legis = 0
    case bills
    case comms
    case favo
    case about
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol,UITableViewDelegate ,UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legis, .bills , .comms, .favo, .about:
                return BaseTableViewCell.height()
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(menus.count)")
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ujujjj \(LeftMenu(rawValue: indexPath.row)?.rawValue)" )
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legis, .bills , .comms, .favo, .about:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }

    
    
    var menus = ["Legislators", "Bills", "Committe", "Favorite", "About"]

    var mainViewController:MainViewController?
    var billsViewController:BillsViewController?
    var commsViewController:CommsViewController?
    var favosViewController:FavosViewController?
    var aboutViewController:AboutViewController?
    //var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let identifier = "BaseTableViewCell"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: identifier)
        if let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController?{
            self.mainViewController = mainViewController
        }
        if let billsViewController = storyboard?.instantiateViewController(withIdentifier: "BillsViewController") as! BillsViewController?{
            self.billsViewController = billsViewController
        }
        if let commsViewController = storyboard?.instantiateViewController(withIdentifier: "CommsViewController") as! CommsViewController?{
            self.commsViewController = commsViewController
        }
        if let favosViewController = storyboard?.instantiateViewController(withIdentifier: "FavosViewController") as! FavosViewController?{
            self.favosViewController = favosViewController
        }
        if let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController?{
            self.aboutViewController = aboutViewController
        }
        //self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let javaViewController = storyboard.instantiateViewController(withIdentifier: "JavaViewController") as! JavaViewController
        self.javaViewController = UINavigationController(rootViewController: javaViewController)
        
        let goViewController = storyboard.instantiateViewController(withIdentifier: "GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let nonMenuController = storyboard.instantiateViewController(withIdentifier: "NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
 
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
       switch menu {
       case .legis:
        self.slideMenuController()?.changeMainViewController(self.mainViewController!, close: true)
        print("legi")
       case .bills:
        self.slideMenuController()?.changeMainViewController(self.billsViewController!, close: true)
        print("bills")
       case .comms:
        self.slideMenuController()?.changeMainViewController(self.commsViewController!, close: true)
        print("comms")
       case .favo:
        self.slideMenuController()?.changeMainViewController(self.favosViewController!, close: true)
        
        print("favo")
       case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController!, close: true)
            print("about")
        /*
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .swift:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .java:
            self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
        case .go:
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .nonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
 */
        }
    }
}


