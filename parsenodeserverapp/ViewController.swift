//
//  ViewController.swift
//  parsenodeserverapp
//
//  Created by Garrett Barker on 10/25/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    var myUser: String = ""
    @IBOutlet var warningTF: UILabel!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBAction func submitButton(_ sender: Any) {
        
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: email.text)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if (objects!.count > 0){
                    self.warningTF.text = "Username already exists"
                    self.warningTF.isHidden = false;
                }else{
                    let user = PFUser()
                    user.username = self.email.text
                    user.password = self.passwordTF.text
                    user.email = self.email.text
                    user.signUpInBackground { (success, error) in
                        if let error = error {
                            self.warningTF.text = "Please enter a username and password"
                            self.warningTF.isHidden = false
                        } else {
                            let query = PFQuery(className:"_User")
                            query.whereKey("username", equalTo: self.email.text)
                            query.findObjectsInBackground { (objects, error) in
                                if error == nil {
                                    if (objects!.count > 0){
                                        for object in objects! {
                                            self.myUser = object.objectId as! String
                                            self.email.text = ""
                                            self.passwordTF.text = ""
                                            self.warningTF.isHidden = true
                                            self.performSegue(withIdentifier: "signUp", sender: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!) \(error!._userInfo ?? "" as AnyObject)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        warningTF.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(myUser != ""){
            let vc = segue.destination as! ContactsTableViewController
            vc.userID = myUser
            myUser = ""
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

