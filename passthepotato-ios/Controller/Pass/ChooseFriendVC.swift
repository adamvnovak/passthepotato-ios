//
//  ChooseFriendViewController.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation
import UIKit
import Contacts

class ChooseFriendViewController: UIViewController {
    
    //MARK: - Properties
    
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBarTextField: UITextField!
    var passButton: UIButton!
    
    //Data
    var potentialRecipients: [User] = []
    var filteredRecipients: [User] = []
    var selectedRecipient: User? = nil {
        didSet {
            backButton.isEnabled = selectedRecipient != nil
            let newButtonTitle = "Pass the potato" + ((selectedRecipient != nil) ? " to " + selectedRecipient!.firstName : "")
            passButton.setTitle(newButtonTitle, for: .normal)
            passButton.setTitleColor(selectedRecipient != nil ? .white : .black, for: .normal)
            passButton.backgroundColor = selectedRecipient != nil ? .accentColor : .white
        }
    }
    
    let contactStore = CNContactStore()
    
    //MARK: - Initialization
    
    class func create() -> ChooseFriendViewController {
        let newVC = UIStoryboard(name: Constants.SBID.SB.Main, bundle: nil).instantiateViewController(withIdentifier: Constants.SBID.VC.ChooseFriend) as! ChooseFriendViewController
        return newVC
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.becomeFirstResponder()
        setupTableView()
        setupTextField()
        
        potentialRecipients = Feederdata.users
        filterRecipients()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleContactsAccess()
    }
    
    //MARK: - Setup
    
    func handleContactsAccess() {
        ContactsManager.requestContactsIfNecessary(onController: self) { approved in
            if approved {
                let allContacts = ContactsManager.fetchAllContacts()
                self.potentialRecipients = allContacts.compactMap( {
                    guard let phoneNumber = $0.bestPhoneNumberPretty else { return nil }
                    return User(id: "", firstName: $0.givenName, lastName: $0.familyName, username: "from contacts", phoneNumber: phoneNumber)
                })
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - Fetch
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupTextField() {
        searchBarTextField.delegate = self
        searchBarTextField.layer.cornerRadius = 10
        searchBarTextField.layer.cornerCurve = .continuous
        setupToolbar()
    }
    
    func setupToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 60))//1
        toolBar.barTintColor = .white
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let flexibleTwo = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2

        passButton = UIButton(frame: toolBar.bounds)
        passButton.addTarget(self, action: #selector(passButtonPressed), for: .touchUpInside)
        passButton.tintColor = .black
        passButton.setTitle("Pass the potato to...", for: .normal)
//        let customAttributes = [NSAttributedString.Key.font: UIFont(name: Constants.Font.Medium, size: 17)!]
        passButton.backgroundColor = .white
        passButton.setTitleColor(.black, for: .normal)
        
        let asdf = UIBarButtonItem(customView: passButton!)
        let items = [flexible, asdf, flexibleTwo]
        toolBar.setItems(items, animated: false)//4
        
        searchBarTextField.inputAccessoryView = toolBar//5
    }
    
    //MARK: - Interaction
    
    @objc func passButtonPressed() {
        
        print("Meep")
        
        //FOR V1: you can only send a potato to those who have the app
        
        //decide to either send them a text or a notification
        
        let name = "adam"
        
        let alert = UIAlertController(title: "potato passed",
                                      message: "you passed the potato to " + name,
                                      preferredStyle: UIAlertController.Style.alert)
//        alert.view.tintColor = .tintColor
        alert.addAction(UIAlertAction(title: "nice",
                                      style: UIAlertAction.Style.default, handler: { alertAction in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - UITextFieldDelegate

extension ChooseFriendViewController: UITextFieldDelegate {
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        filterRecipients()
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
}

extension ChooseFriendViewController {
    
    //MARK: - Helpers
    
    func filterRecipients() {
        let query = searchBarTextField.text!
        if query.isEmpty { filteredRecipients = potentialRecipients }
        else {
            filteredRecipients = potentialRecipients.filter( { ($0.firstName+$0.lastName+$0.username).contains(query) })
        }
    }
    
}

//MARK: - UITableViewDelegate, DataSource

extension ChooseFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRecipients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "hi")
        let user = filteredRecipients[indexPath.row]
        print("USER:", user)
        defaultCell.textLabel?.text = user.firstName + " " + user.lastName
        defaultCell.detailTextLabel?.text = "@" + user.username
        defaultCell.imageView!.image = UIImage(systemName: "magnifyingglass")
        defaultCell.textLabel?.textColor = .black
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //put that user as the selected recipient
        selectedRecipient = filteredRecipients[indexPath.row]
    }
    
}
