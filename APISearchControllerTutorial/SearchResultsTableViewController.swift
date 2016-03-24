//
//  SearchResultsTableViewController.swift
//  
//
//  Created by Kc on 24/03/2016.
//
//

import UIKit
import SwiftyJSON

class SearchResultsTableViewController: UITableViewController {
    
    var searchResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var validatedText: String {
        return searchController.searchBar.text!.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let requestManager = RequestManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Enter tag..."
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchResultsTableViewController.updateSearchResults), name: "searchResultsUpdated", object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateSearchResults() {
        searchResults = requestManager.searchResults
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)

        cell.textLabel?.text = searchResults[indexPath.row]["owner"]["display_name"].stringValue
        cell.detailTextLabel?.text = searchResults[indexPath.row]["title"].stringValue
        
        if indexPath.row == searchResults.count - 10 {
            if requestManager.hasMore {
                requestManager.getNextPage(validatedText)
            }
        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        requestManager.resetSearch()
        updateSearchResults()
        requestManager.search(validatedText)
    }
}
