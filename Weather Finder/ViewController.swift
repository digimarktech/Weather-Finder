//
//  ViewController.swift
//  Weather Finder
//
//  Created by Marc Aupont on 12/17/15.
//  Copyright © 2015 Digimark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userInput: UITextField!
    
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func getWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        //Converting userInput into NSString
        let userInputNew = NSString(string: userInput.text!)
        
        
        
        //Remove all the whitespace before the first character and after the last character of string
        let trimmedString = userInputNew.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        //Store the url into the url variable
        let attemptedurl = NSURL(string: "http://www.weather-forecast.com/locations//" + trimmedString.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        

        
        if let url = attemptedurl {
        
        //This line essentially sets up the virtual browser window
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            //Check to make sure data exists
            if let urlContent = data {
                
                //Encode website data so that we can read html
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                //Here we are splitting the content up into 2 seperate strings so we can specifically parse what we need
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                //Check to see that we found content and that array isn't empty
                if websiteArray.count > 1 {
                    
                    
                    //We are using this part of the code to take what we've stored in the second portion of website array and splitting by the span tag. This essentially leaves us with the text we want in the first part of our new weatherArray
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                    
                    
                    //Check that the weather array has content
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        
                        //store the results in weather summary. The second piece of code replaces the &deg with the degrees symbol
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        
                        //This piece of code allows content to load without waiting for all of data to process first
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            
                            //display weatherSummary on screen
                            self.resultLabel.text = weatherSummary
                            
                    })//End of weatherArray check
                        
                        
                }//End of websiteArray check
                    
            }//End of data check
                
                
        }// End of attempted url echeck 
            
            
            
    }
        //Run the task
        task.resume()
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }



}

