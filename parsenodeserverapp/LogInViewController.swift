//
//  LogInViewController.swift
//  parsenodeserverapp
//
//  Created by Garrett Barker on 10/25/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit
import Parse
class LogInViewController: UIViewController {

    var myUser: String = ""
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var warningLabel: UILabel!
    @IBAction func submitButton(_ sender: Any) {

        PFUser.logOutInBackground()
    
        PFUser.logInWithUsername(inBackground: emailTF.text!, password: passwordTF.text!, block: { (user, error) in
            if(user != nil){
                let query = PFQuery(className:"_User")
                query.whereKey("username", equalTo: self.emailTF.text)
                query.findObjectsInBackground { (objects, error) in
                    if error == nil {
                        if (objects!.count > 0){
                            for object in objects! {
                                self.myUser = object.objectId as! String
                                self.emailTF.text = ""
                                self.passwordTF.text = ""
                                self.warningLabel.isHidden = true
                                self.performSegue(withIdentifier: "logIn", sender: nil)
                            }
                        }else{
                           print("cannot get userID")
                        }
                    } else {
                        print("Error: \(error!) \(error!._userInfo ?? "" as AnyObject)")
                    }
                }
            }else{
                self.warningLabel.text = "Username and Password are not correct"
                self.warningLabel.isHidden = false
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        warningLabel.isHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ContactsTableViewController
        vc.userID = myUser
        myUser = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
