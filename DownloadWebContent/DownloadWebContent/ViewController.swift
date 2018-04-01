//
//  ViewController.swift
//  DownloadWebContent
//
//  Created by Ei Phyu on 7/3/18.
//  Copyright © 2018 Ei Phyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    
    @IBAction func getWeather(_ sender: Any) {
        
        if (cityTextField.text?.isEmpty)!{
            resultLabel.text = "Please enter the city."
        }else{
            
            self.view.endEditing(true)
            
            let city = cityTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
            
            if let url = URL(string: "https://www.weather-forecast.com/locations/" + city! + "/forecasts/latest") {
                let request = NSMutableURLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in
                    
                    var message = ""
                    
                    if error != nil{
                        print(error ?? "Ei error")
                    }else{
                        if let unwrappedData = data{
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            var stringSeparator = "</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                            
                            if let contentArray = dataString?.components(separatedBy: stringSeparator){
                                
                                if contentArray.count > 1 {
                                    
                                    stringSeparator = "</span>"
                                    
                                    let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                    
                                    if newContentArray.count > 1 {
                                        
                                        message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                        // print(message)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if message == ""{
                        message = "The weather there couldn't be found. Please try again."
                    }
                    
                    
                    DispatchQueue.main.sync {
                        self.resultLabel.text = message
                    }
                    
                }
                task.resume()
            }else{
                resultLabel.text = "The weather there couldn't be found. Please try again."
            }
            cityTextField.text = ""
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

