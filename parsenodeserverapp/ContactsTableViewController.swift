//
//  ContactsTableViewController.swift
//  parsenodeserverapp
//
//  Created by Garrett Barker on 10/25/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit
import Parse
class ContactsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var userID: String = ""
    var contacts = [PFObject]()
    var selectedObject = [PFObject]()
    @IBOutlet var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        myTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        let query = PFQuery(className:"Contacts")
        query.whereKey("userId", equalTo: userID)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if (objects!.count > 0){
                    self.contacts = objects!
                    self.myTable.reloadData()
                }else{
                    print("no contacts")
                }
            } else {
                print("Error: \(error!) \(error!._userInfo ?? "" as AnyObject)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contactName = contacts[indexPath.row]
        cell.textLabel?.text = contactName["name"] as! String

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedObject = [contacts[indexPath.row]]
        performSegue(withIdentifier: "contact", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let query = PFQuery(className:"Contacts")
            query.getObjectInBackground(withId: contacts[indexPath.row].objectId!) {
                (update, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let update = update {
                        update.deleteInBackground() {
                            (success: Bool, error: Error?) in
                            if (success) {
                                // The object has been saved.
                                print(success)
                            } else {
                                // There was a problem, check error.description
                                print("save failed")
                            }
                        }
                    }
                }
            }
        }
        myTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ContactViewController
        vc.myUser = userID
        if (!selectedObject.isEmpty){
            vc.contact = selectedObject
            selectedObject.removeAll()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        myTable.reloadData()
    }
}
