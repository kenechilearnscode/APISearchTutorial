//
//  RequestManager.swift
//  APISearchControllerTutorial
//
//  Created by Kc on 24/03/2016.
//  Copyright © 2016 Kenechi Okolo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestManager {
    
    var searchResults = [JSON]()
    
    var pageString: String {
        if pageNumber == 1 {
            return ""
        } else {
            return "page=\(pageNumber)&"
        }
    }
    
    var pageNumber = 1
    var hasMore = false
    
    func search(searchText: String) {
        let url = "https://api.stackexchange.com/2.2/search?\(pageString)order=desc&sort=activity&tagged=\(searchText)&site=stackoverflow"
        print(url)
        Alamofire.request(.GET, url).responseJSON { response in
            if let results = response.result.value as? [String:AnyObject] {
                print("Results: \(results)")
                let items = JSON(results["items"]!).arrayValue
                self.hasMore = JSON(results["has_more"]!).boolValue
                self.searchResults += items
                
                NSNotificationCenter.defaultCenter().postNotificationName("searchResultsUpdated", object: nil)
            }
        
        }
    }
    
    func getNextPage(searchText: String) {
        pageNumber += 1
        search(searchText)
    }
    
    func resetSearch() {
        searchResults = []
    }
}
