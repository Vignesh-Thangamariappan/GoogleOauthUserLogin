//
//  ViewController.swift
//  UserLogin
//
//  Created by user on 11/15/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import SafariServices


class ViewController: UIViewController, SFSafariViewControllerDelegate {
    let defaults = UserDefaults.standard
    let clientID = "360257128994-c3aqfg23he0ra64plu8he4srhlrr5ge3.apps.googleusercontent.com"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var safari = SFSafariViewController(url: URL(string:"https://www.google.com")!)
    let alert = Alert()
    let session = URLSession(configuration: .default)
    let mainNavgVC = MainNavigationController()
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        defaults.set(clientID, forKey: "clientID")
        defaults.set("com.example.UserLogin:/Oauth2callback", forKey: "redirecturi")
        signInButton.isHidden = false
        loadingIcon.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        
        let myURL = URL(string: "https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile%20https://www.googleapis.com/auth/user.birthday.read%20https://www.googleapis.com/auth/plus.login&response_type=code&redirect_uri=com.example.UserLogin:/Oauth2callback&client_id=360257128994-c3aqfg23he0ra64plu8he4srhlrr5ge3.apps.googleusercontent.com&key=AIzaSyBM440JunN_sabn6eJ5rBX4voa_SMzNtbA")
        NotificationCenter.default.addObserver(self, selector: #selector(googleLogin(notification:)), name: Notification.Name("LoginNotification"), object: nil)
        
        safari = SFSafariViewController( url:myURL!)
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
        signInButton.isHidden = true
        loadingIcon.isHidden = false
        loadingIcon.startAnimating()
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Safari closed before authorization")
        alert.showAlert(title: "Authorization terminated by user", message: "Please try again", vc: self)
        signInButton.isHidden = false
        loadingIcon.isHidden = true
        loadingIcon.stopAnimating()
    }
    
    @objc func googleLogin(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LoginNotification"), object: nil)
        
        guard let url = notification.object as? NSURL, let query = url.query else{
            
            return
        }
        
        let authorization = query
        self.safari.dismiss(animated: true , completion: nil)
        
        
        if authorization == "error=access_denied" {
            alert.showAlert(title: "Access Denied", message: "Authorization Failed. Try Again", vc: self)
            signInButton.isHidden = false
            loadingIcon.isHidden = true
        } else {
            generateAccessToken(authorization)
        }
        
        
    }
    
    
    
    func generateAccessToken(_ code: String) {
        
        let authCode = code
        let url = URL(string:"https://www.googleapis.com/oauth2/v4/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&redirect_uri=com.example.UserLogin:/Oauth2callback&client_id=360257128994-c3aqfg23he0ra64plu8he4srhlrr5ge3.apps.googleusercontent.com&\(authCode)".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            if error == nil {
                
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        self.defaults.set(json, forKey: "Tokens")
                        let accessToken = json!["access_token"] as? String
                        let refreshToken = json!["refresh_token"] as? String
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        UserDefaults.standard.synchronize()
                        self.mainNavgVC.getDetails()
                    }
                    catch {
                        print("Json Object Not Obtained")
                        self.errorOccured()
                    }
                    
                }
                    
                else {
                    print("Data not available")
                }
            }
            else {
                self.errorOccured()
                print(error)
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                self.navigationController?.setViewControllers([login],animated:true)
            }
        }
        
        task.resume()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    func errorOccured() {
        
        alert.showAlert(title: "Oops! Something went wrong", message: "Please Try Again", vc: self)
    }
    
}
