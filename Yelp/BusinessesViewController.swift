//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchResultsUpdating,  UIScrollViewDelegate   {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchController: UISearchController!
    var isMoreDataLoading = false

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        ///
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        
        //tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        loadData()
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    
    }
    
    func loadData() {
        
       
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if(self.businesses == nil) {
                self.businesses = businesses
            } else {
                
                self.businesses.appendContentsOf(businesses)
            }
            
            self.isMoreDataLoading = false
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
            //for business in businesses {
                //print(business.name!)
                //print(business.address!)
            //}
        })
        
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else  {
            return 0
        }
    
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        //print(indexPath.row)
        
       
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
        
    
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filteredBusinesses = searchText.isEmpty ? businesses : businesses!.filter{$0.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) !=  nil}

        
        }
               tableView.reloadData()
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                loadData()
            }
        }
        
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
