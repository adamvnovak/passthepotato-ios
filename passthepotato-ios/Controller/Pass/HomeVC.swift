//
//  HomeViewController.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation
import UIKit

enum HomeState: Int, CaseIterable {
    case newSendable, received, waiting
}

class HomeViewController: UIViewController {

    //MARK: - Properties
    
    //UI
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var emojiTitleLabel: UILabel!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var passButtonTopLabel: UILabel!
    @IBOutlet weak var passButtonBottomLabel: UILabel!
    
    //Data?
    var homeState: HomeState = .newSendable

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadUI()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationsManager.shared.askForNewNotificationPermissionsIfNecessary(onVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
    
    //MARK: - Interaction
    
    @IBAction func passButtonDidPressed(_ sender: UIButton) {
        switch homeState {
        case .newSendable, .received:
            let chooseFriendVC = ChooseFriendViewController.create()
            navigationController?.pushViewController(chooseFriendVC, animated: true)
        case .waiting:
            break
        }
    }
    
    func setupUI() {
        passButton.roundCornersViaCornerRadius(radius: 10)
        passButton.applyMediumShadow()
    }
    
    func reloadUI() {
        if PassService.singleton.newPasses.count > 0 {
            homeState = .received
        } else {
            if
                let lastPass = PassService.singleton.userPasses.last,
                NSDate().timeIntervalSince1970.getElapsedTime(since: lastPass.timestamp.timeIntervalSince1970).days == 0 {
                homeState = .waiting
            } else {
                homeState = .newSendable
            }
        }
        
        renderUIForCurrentState()
    }
    
    func renderUIForCurrentState() {
        switch homeState {
        case .newSendable:
            emojiLabel.text = "🥔"
            emojiTitleLabel.text = "Omg you have a potato"
            passButtonTopLabel.text = ""
            passButton.setTitle("Pass the potato", for: .normal)
            passButton.setTitleColor(.black, for: .normal)
            passButtonBottomLabel.text = ""
        case .received:
            let senderName = PassService.singleton.userPasses.last!.passer.firstName
            emojiLabel.text = "🥔"
            emojiTitleLabel.text = senderName + " passed you a potato"
            passButtonTopLabel.text = "Now it's your turn to"
            passButton.setTitle("pass the potato", for: .normal)
            passButtonBottomLabel.text = "to someone else"
        case .waiting:
            let receiverName = PassService.singleton.userPasses.last!.receiver.firstName
            emojiLabel.text = "👏"
            emojiTitleLabel.text = "You passed " + receiverName + " a potato"
            passButtonTopLabel.text = ""
            passButton.setTitle("Wait one day", for: .normal)
            passButtonBottomLabel.text = "until you can pass a new one"
        }
    }

}
