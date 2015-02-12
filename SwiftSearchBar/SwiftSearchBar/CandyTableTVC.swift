//
//  CandyTableTVC.swift
//  SwiftSearchBar
//
//  Created by David Hodge on 1/20/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class CandyTableTVC: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    //Instance Variables
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    
    //View initialization
    override func viewDidLoad() {
        self.candies = [
            Candy(category: "Chocolate", name: "Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy cane"),
            Candy(category:"Hard", name:"Jaw breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear")
        ]
        
        self.tableView.reloadData()
    }
    
    //Search filter
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        //The Array.filter method runs a closure with a candy parameter that returns a Bool
        //The inside of the closure runs just like a method. This resembles a block
        
        self.filteredCandies = self.candies.filter({
            (candy: Candy) -> Bool in
            
            let categoryMatch = (scope == "All")
            let stringMatch = candy.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        //TODO
        self.filterContentForSearchText(searchString, scope: "All")
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: "All")
        return true
    }
    
    //UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CandyCell") as UITableViewCell
        
        configureCell(cell, tableView: tableView, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, tableView: UITableView, indexPath: NSIndexPath)
    {
        var candy: Candy
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = self.filteredCandies[indexPath.row]
        } else {
            candy = self.candies[indexPath.row]
        }
        
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    //UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailSegue", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "DetailSegue" {
            
            let vc = segue.destinationViewController as UIViewController

            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                vc.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.candies[indexPath.row].name
                vc.title = destinationTitle
            }
        }
    }
    
}
