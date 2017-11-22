//
//  SettingScreen.swift
//  UserLogin
//
//  Created by user on 11/20/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit

class SettingScreen: UITableViewController {
    
    let defaults = UserDefaults.standard
    let session = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        revokeToken()
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        navigationController?.setViewControllers([loginController], animated: true)
    }
    
    func revokeToken() {
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as! String
        let url = URL(string:"https://accounts.google.com/o/oauth2/revoke?token=\(accessToken)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data,response,error)->Void in
            
            if error == nil {
                
                print(response)
                print(data)
                self.defaults.set(nil, forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "name")
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "firstName")
                UserDefaults.standard.set(nil, forKey: "lastName")
                UserDefaults.standard.set(nil, forKey: "Tokens")
                self.defaults.synchronize()
            }
            else {
                print(error)
                print(response)
            }
            
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title = "Settings"
    }
    
}
