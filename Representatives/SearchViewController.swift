//
//  SearchViewController.swift
//  Representatives
//
//  Created by Taylor Mott on 10/28/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var statesIndex = 0
    //MARK: - Properties
    let states = ["AK", "AL", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var representativesArray: [Representative] = []
    
    
    @IBOutlet weak var statePickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchAllButton: UIButton!
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        
        let statePickerValue = states[statePickerView.selectedRowInComponent(0)]
        
        RepresentativeController.searchRepresentatives(statePickerValue) { (representativesArray) -> Void in
            
            if let representativesArray = representativesArray {
                
                self.representativesArray = representativesArray
                
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("showResults", sender: self)
                    })
                    
                } else {
                    print("no representatives found")
                }
            
        }
        
        
    }
    
    @IBAction func showAllButtonTapped(sender: UIButton) {
        
        searchAllButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        for state in states {
            RepresentativeController.searchRepresentatives(state) { (representativesArray) -> Void in
                
                
                if let representativesArray = representativesArray {
                    
                    representativesArray.forEach({ (rep) -> () in
                        self.representativesArray.append(rep)
                    })
                    
                    self.statesIndex++
                    if self.statesIndex == self.states.count {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier("showResults", sender: self)
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
                            self.searchAllButton.hidden = false
                            self.statesIndex = 0
                            
                        })
                    }
                    
                    } else {
                        print("no representatives found")
                    }
                
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.hidden = true
        searchAllButton.hidden = false
    }
  
    
    // MARK: Pickerview
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showResults" {
            
            let detailView = segue.destinationViewController as! ResultsTableViewController
            
            detailView.representativesArray = self.representativesArray
        
        } else if segue.identifier == "showAll" {
            
            let detailView = segue.destinationViewController as! ResultsTableViewController
            
            detailView.representativesArray = self.representativesArray
            
        }
    }
    
}
