//
//  ViewController.swift
//  Assignment1
//
//  Created by Sherman Leung on 9/21/16.
//  Copyright © 2016 Sherman Leung. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, HealthFinderFiltersDelegate {

    var topics: [NSDictionary]?
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 110.0;
        searchBar.delegate = self
        
    }
    
    func searchWithQuery(query: String) {
        if (query == "") {
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading results..."
        let url = URL(string: "https://healthfinder.gov/api/v2/topicsearch.json?api_key=demo_api_key&Keyword=\(query)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task = session.dataTask(with: request) { (dataOrNil, response, err) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let results = responseDictionary["Result"] as? NSDictionary {
                        if let resources = results["Resources"] as? NSDictionary {
                            if let topics = resources["Resource"] as? [NSDictionary] {
                                print("response \(topics)")
                                self.topics = topics
                                self.tableView.reloadData()
                                hud.hide(animated: true)
                            }
                        }
                    }
                }
            } else {
                hud.hide(animated: true)
                let alertController = UIAlertController(title: "Error", message: "No results retrieved", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()

    }
    
    func searchWithFilters(gender: String, age: Int) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading results..."
        let url = URL(string: "https://healthfinder.gov/developer/MyHFSearch.json?api_key=demo_api_key&who=child&age=\(age)&gender=\(gender)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task = session.dataTask(with: request) { (dataOrNil, response, err) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let results = responseDictionary["Result"] as? NSDictionary {
                        print("response \(results["Topics"])")
                        self.topics = results["Topics"] as? [NSDictionary]
                        self.tableView.reloadData()
                        hud.hide(animated: true)
                    }
                }
            } else {
                hud.hide(animated: true)
                let alertController = UIAlertController(title: "Error", message: "No results retrieved", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    //HealthFinderFilters Delegate
    
    func filtersWereUpdated(gender: String, age: Int) {
        searchWithFilters(gender: gender, age: age)
    }
    
    //UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWithQuery(query: searchText)
    }

    
    // UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let topics = topics {
            return topics.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthFinderTableViewCell") as! HealthFinderTableViewCell
        let topic = topics![indexPath.row]
        let url = URL(string: topic["ImageUrl"] as! String)
        cell.topicImage.setImageWith(url!)
        cell.topicTitle.text = topic["Title"] as? String
        cell.topicLastUpdated.text = topic["LastUpdate"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "section_segue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "section_segue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let destinationVC = segue.destination as! HealthFinderDetailViewController
            destinationVC.sections = topics![indexPath!.row]["Sections"] as? [NSDictionary]
        }
        if (segue.identifier == "filters_segue") {
            let destinationVC = segue.destination as! HealthFinderFiltersViewController
            destinationVC.delegate = self
        }
    }
}

