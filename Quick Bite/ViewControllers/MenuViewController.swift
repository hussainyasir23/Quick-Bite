//
//  MenuViewController.swift
//  Quick Bite
//
//  Created by Mohammad on 07/08/21.
//

import UIKit
import SQLite3

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UpdateItems, SyncItems  {
    
    var menuList = [Item](){
        didSet{
            filteredMenuList = menuList
            updateSearchResults(for: resultSearchController)
        }
    }
    
    var filteredMenuList = [Item](){
        didSet{
            itemListTable.reloadData()
        }
    }
    
    weak var delegate: SyncItems?
    
    let welcomeLabel = UILabel()
    let itemListTable = UITableView()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    func setViews(){
        view.addSubview(welcomeLabel)
        view.addSubview(itemListTable)
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search here..."
            controller.searchBar.searchTextField.backgroundColor = .white
            controller.searchBar.layer.cornerRadius = 7.0
            controller.searchBar.barTintColor = UIColor(red: 240/250.0, green: 240/250.0, blue: 240/250.0, alpha: 1.0)
            controller.searchBar.delegate = self
            
            itemListTable.tableHeaderView = controller.searchBar
            itemListTable.tableHeaderView?.tintColor = #colorLiteral(red: 0.9183054566, green: 0.3281622529, blue: 0.3314601779, alpha: 1)
            
            return controller
        })()
    }
    
    func setConstraints(){
        title = "Menu"
        view.backgroundColor = UIColor(red: 240/250.0, green: 240/250.0, blue: 240/250.0, alpha: 1.0)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome to ABC Restaurant!"
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = .boldSystemFont(ofSize: 24)
        welcomeLabel.textColor = #colorLiteral(red: 0.9183054566, green: 0.3281622529, blue: 0.3314601779, alpha: 1)
        welcomeLabel.adjustsFontForContentSizeCategory = true
        welcomeLabel.textAlignment = .center
        welcomeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        
        itemListTable.delegate = self
        itemListTable.dataSource = self
        itemListTable.allowsSelection = false
        itemListTable.isUserInteractionEnabled = true
        itemListTable.allowsSelection = false
        itemListTable.separatorStyle = .none
        itemListTable.isUserInteractionEnabled = true
        itemListTable.backgroundColor = UIColor(red: 240/250.0, green: 240/250.0, blue: 240/250.0, alpha: 1.0)
        itemListTable.translatesAutoresizingMaskIntoConstraints = false
        itemListTable.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        itemListTable.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16).isActive = true
        itemListTable.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        itemListTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        itemListTable.register(ItemListTableViewCell.self, forCellReuseIdentifier: "ItemListTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as! ItemListTableViewCell
        cell.item = filteredMenuList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 112
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text!.lowercased()
        if(searchString == "") {
            filteredMenuList = menuList
        }
        else{
            filteredMenuList = []
            for item in menuList {
                if item.item_name.lowercased().contains(searchString) {
                    filteredMenuList.append(item)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        filteredMenuList = menuList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemListTable.reloadData()
    }
    
    func updateItems() {
        menuList = DataBaseQueries.getMenuItems()
        delegate?.syncItems()
    }
    
    func syncItems() {
        menuList = DataBaseQueries.getMenuItems()
    }
}
