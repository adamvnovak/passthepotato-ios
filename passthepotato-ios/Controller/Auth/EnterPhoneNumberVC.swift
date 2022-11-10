//
//  ViewController.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import UIKit
import FirebaseAuth
import PhoneNumberKit

enum APIError: Error, Equatable {
    
    case CouldNotConnect
    case ClientError(String, String)
}

class EnterPhoneNumberViewController: KUIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var enterNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var enterNumberTextFieldWrapperView: UIView!
    
    var isValidInput: Bool! {
        didSet {
            continueButton.isEnabled = isValidInput
        }
    }
    var isSubmitting: Bool = false {
        didSet {
            continueButton.setTitle(isSubmitting ? "" : "continue", for: .normal)
            continueButton.loadingIndicator(isSubmitting)
        }
    }
    
    //MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        validateInput()
        shouldNotAnimateKUIAccessoryInputView = true
        setupEnterNumberTextField()
        setupContinueButton()
//        setupBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        AuthContext.reset()
        enableInteractivePopGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enterNumberTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableInteractivePopGesture()
    }
    
    //MARK: - Setup
    
    func setupEnterNumberTextField() {
        enterNumberTextFieldWrapperView.layer.cornerRadius = 5
        enterNumberTextFieldWrapperView.layer.cornerCurve = .continuous
        enterNumberTextField.delegate = self
        enterNumberTextField.countryCodePlaceholderColor = .red
        enterNumberTextField.withFlag = true
        enterNumberTextField.withPrefix = true
        enterNumberTextField.tintColor = .black
//        enterNumberTextField.withExamplePlaceholder = true
    }
    
    func setupContinueButton() {
        continueButton.roundCornersViaCornerRadius(radius: 10)
        continueButton.clipsToBounds = true
        continueButton.isEnabled = false
        continueButton.setBackgroundImage(UIImage.imageFromColor(color: .white), for: .normal)
        continueButton.setBackgroundImage(UIImage.imageFromColor(color: .lightGray.withAlphaComponent(0.7)), for: .disabled)
        continueButton.setTitleColor(.accentColor, for: .normal)
        continueButton.setTitleColor(.white, for: .disabled)
        continueButton.setTitle("continue", for: .normal)
    }
    
    func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
    }
    
    //MARK: - User Interaction
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressedContinueButton(_ sender: Any) {
        tryToContinue()
    }
    
    //MARK: - TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let didAutofillTextfield = range == NSRange(location: 0, length: 0) && string.count > 1
        if didAutofillTextfield {
            DispatchQueue.main.async {
                self.tryToContinue()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidInput {
            tryToContinue()
        }
        return false
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let maxLength = 17 //the max length for US numbers
        if sender.text!.count > maxLength {
            sender.deleteBackward()
        }
        validateInput()
    }
    
    //MARK: - Helpers
    
    func tryToContinue() {
        guard let number = enterNumberTextField.text?.asE164PhoneNumber else { return }
        isSubmitting = true
        
        //TODO: first check if an account associated with that phone number exists
        //if it does, then login
        //if not, then signup
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
              if let error = error {
                  self.handleFailure(error)
                  return
              }
              guard let verificationID else {
                  self.handleFailure(APIError.ClientError("lol", "lol"))
                  return
              }
              
              DispatchQueue.main.async { [self] in
                  AuthContext.phoneNumber = number
                  AuthContext.verificationID = verificationID
                  let vc = ConfirmCodeViewController.create(confirmMethod: .phoneNumber)
                  self.navigationController?.pushViewController(vc, animated: true, completion: { [weak self] in
                      self?.isSubmitting = false
                  })
              }
          }
    }
    
    func handleFailure(_ error: Error) {
        isSubmitting = false
        enterNumberTextField.text = ""
        validateInput()
//        CustomSwiftMessages.displayError(error)
    }
    
    func validateInput() {
        isValidInput = enterNumberTextField.text?.asE164PhoneNumber != nil
    }
    
}

//// UIGestureRecognizerDelegate (already inherited in an extension)
//
//extension EnterPhoneNumberViewController {
//
//    // Note: Must be called in viewDidLoad
//    //(1 of 2) Enable swipe left to go back with a bar button item
//    func setupPopGesture() {
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
//    }
//
//    //(2 of 2) Enable swipe left to go back with a bar button item
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
//

