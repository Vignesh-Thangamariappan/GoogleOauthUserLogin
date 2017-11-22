//
//  HomeScreen.swift
//  UserLogin
//
//  Created by user on 11/20/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController {
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    let alert = Alert()
    let defaults = UserDefaults.standard
    let session = URLSession(configuration: .default)
    @IBOutlet weak var ProfilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = defaults.value(forKey: "email") as? String,let name = defaults.value(forKey: "name") as? String,let firstName = defaults.value(forKey: "firstName") as? String,let lastName = defaults.value(forKey: "lastName") as? String {
            emailLabel.text = "Email: \(email)"
            welcomeLabel.text = "Welcome \(name)"
            firstNameLabel.text = "Given Name: \(firstName)"
            lastNameLabel.text = "Family Name: \(lastName)"
        }
        if let picture = defaults.value(forKey: "picture") as? String {
            print(picture)
            let url = URL(string: picture)
            do {
                ProfilePicture.image = UIImage(data: try Data(contentsOf:url!))
            } catch {
                print("Image cannot be generated from link")
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title = "Home"
    }
    
}


