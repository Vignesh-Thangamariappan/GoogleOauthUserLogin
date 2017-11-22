//
//  MainNavigationController.swift
//  UserLogin
//
//  Created by user on 11/20/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    let defaults = UserDefaults.standard
    let alert = Alert()
    let session = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backItem?.backBarButtonItem?.isEnabled = false
        
        let accessToken = defaults.value(forKey: "accessToken")
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Dashboard")
        if accessToken == nil {
            setViewControllers([loginController], animated: true)
        }
        else{
            checkValidity()
            setViewControllers([dashboard], animated: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func checkValidity() {
        if let accessToken = defaults.value(forKey: "accessToken") {
            let url = URL(string: "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(accessToken)")!
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                
                if error == nil {
                    print(data!)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                        print(json)
                        return
                    } catch {
                        print(error)
                    }
                }
                else{
                    print(error)
                    self.refreshToken()
                }
                
            }
            task.resume()
        }
        
    }
    
    func refreshToken() {
        
        let refreshToken = defaults.value(forKey: "refreshToken") as! String
        let url = URL(string: "https://www.googleapis.com/oauth2/v4/token?")!
        let clientID = defaults.value(forKey: "clientID") as! String
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "client_id=\(clientID)&grant_type=refresh_token&refresh_token=\(refreshToken)".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let idToken = json!["id_token"] as? String
                    let accessToken = json!["access_token"] as? String
                    self.defaults.set(accessToken, forKey: "accessToken")
                    self.getDetails()
                } catch {
                    print(error)
                }
            } else {
                print(error)
                self.loginAgain()
            }
        }
        task.resume()
    }
    
    func getDetails() {
        
        
        if let accessToken =  UserDefaults.standard.value(forKey: "accessToken") {
            let url = URL(string: "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=\(accessToken)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                
                if error==nil {
                    do {
                        let myjson = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any])!
                        print(myjson)
                        let email = myjson["email"]
                        let pic = myjson["picture"]
                        let name = myjson["name"]
                        let lastName = myjson["family_name"]
                        let firstName = myjson["given_name"]
                        UserDefaults.standard.set(email,forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        UserDefaults.standard.set(lastName, forKey: "lastName")
                        UserDefaults.standard.set(pic, forKey: "picture")
                        UserDefaults.standard.synchronize()
                        self.login()
                        
                    } catch {
                        print(error)
                    }
                    
                }else {
                    print(error)
                }
                return
            }
            
            task.resume()
        }
    }
    
    func loginAgain() {
        alert.showAlert(title: "Token Expired", message: "Please Sign In again", vc: self)
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        navigationController?.setViewControllers([login],animated:true)
    }
    
    func login() {
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Dashboard")
        navigationController?.setViewControllers([tabBarController], animated: true)
    }
}

