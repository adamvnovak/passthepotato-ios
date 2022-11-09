//
//  ConfirmCodeVC.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import Foundation
import UIKit

class ConfirmCodeViewController: KUIViewController, UITextFieldDelegate {
    
    enum ConfirmMethod: String, CaseIterable {
        case phoneNumber
    }
    
    enum ResendState {
        case notsent, sending, sent
    }
    
    var recipient: String!
    var confirmMethod: ConfirmMethod = .phoneNumber

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!

    var isValidInput: Bool! {
        didSet {
            continueButton.isEnabled = isValidInput
        }
    }
    var isSubmitting: Bool = false {
        didSet {
            continueButton.setTitle(isSubmitting ? "" : "continue", for: .normal)
            continueButton.loadingIndicator(isSubmitting)
            resendButton.isEnabled = !isSubmitting && resendState == .notsent
        }
    }
    
//    let resendAttributes = [NSAttributedString.Key.font: UIFont(name: Constants.Font.Medium, size: 12)!]
    var resendState: ResendState = .notsent {
        didSet {
            switch resendState {
            case .notsent:
                resendButton.loadingIndicator(false)
                resendButton.isEnabled = true
                resendButton.setTitle("resend", for: .normal)
            case .sending:
                resendButton.isEnabled = false
                resendButton.loadingIndicator(true)
                resendButton.setTitle("", for: .normal)
            case .sent:
                resendButton.isUserInteractionEnabled = false
                resendButton.loadingIndicator(false)
                resendButton.setTitle("resent", for: .normal)
            }
        }
    }
    
    //MARK: - Initialization
    
    class func create(confirmMethod: ConfirmMethod) -> ConfirmCodeViewController {
        let vc = UIStoryboard(name: Constants.SBID.SB.Auth, bundle: nil).instantiateViewController(withIdentifier: Constants.SBID.VC.ConfirmCode) as! ConfirmCodeViewController
        switch confirmMethod {
        case .phoneNumber:
            vc.recipient = AuthContext.phoneNumber.asNationalPhoneNumber ?? AuthContext.phoneNumber
            vc.confirmMethod = confirmMethod
            return vc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateInput()
        shouldNotAnimateKUIAccessoryInputView = true
        setupConfirmEmailTextField()
        setupContinueButton()
        setupLabel()
        confirmTextField.becomeFirstResponder()
        validateInput()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableInteractivePopGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableInteractivePopGesture()
    }
    
    //MARK: - Setup
    
    func setupConfirmEmailTextField() {
        confirmTextField.delegate = self
        confirmTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        confirmTextField.layer.cornerRadius = 5
        let xconstraints: CGFloat = 50
        let textFieldWidth = view.frame.size.width - xconstraints
        let numberWidth: CGFloat = 14
        let spacing = (textFieldWidth / 7) - numberWidth
        confirmTextField.setLeftPaddingPoints(spacing)
        confirmTextField.defaultTextAttributes.updateValue(spacing, forKey: NSAttributedString.Key.kern)
    }
    
    func setupContinueButton() {
        continueButton.roundCornersViaCornerRadius(radius: 10)
        continueButton.clipsToBounds = true
        continueButton.isEnabled = false
        continueButton.setBackgroundImage(UIImage.imageFromColor(color: .red), for: .normal)
        continueButton.setBackgroundImage(UIImage.imageFromColor(color: .red.withAlphaComponent(0.2)), for: .disabled)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitleColor(.white, for: .disabled)
        continueButton.setTitle("continue", for: .normal)
    }
    
    func setupLabel() {
        sentToLabel.text! += recipient
    }
    
    //MARK: - User Interaction
    
    @IBAction func backButtonDidPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressedContinueButton(_ sender: Any) {
        tryToContinue()
    }
    
    @IBAction func didPressedResendButton(_ sender: UIButton) {
        resendState = .sending
        Task {
            do {
                try await resend()
            } catch {
                handleError(error)
            }
            resendState = .sent
        }
    }
    
    //MARK: - TextField Delegate
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        validateInput()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidInput {
            tryToContinue()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let didAutofillTextfield = range == NSRange(location: 0, length: 0) && string.count > 1
        if didAutofillTextfield {
            DispatchQueue.main.async {
                self.tryToContinue()
            }
        } else {
            detectAutoFillFromTexts(textField: textField, range: range, string: string)
        }
        return textField.shouldChangeCharactersGivenMaxLengthOf(6, range, string)
    }
    
    //MARK: DetectAutoFill

    private var fieldPossibleAutofillReplacementAt: Date?
    private var fieldPossibleAutofillReplacementRange: NSRange?
    func detectAutoFillFromTexts(textField: UITextField, range: NSRange, string: String) {
        // To detect AutoFill, look for two quick replacements. The first replaces a range with a single space
        // (or blank string starting with iOS 13.4).
        // The next replaces the same range with the autofilled content.
        if string == " " || string == "" {
            self.fieldPossibleAutofillReplacementRange = range
            self.fieldPossibleAutofillReplacementAt = Date()
        } else {
            if fieldPossibleAutofillReplacementRange == range, let replacedAt = self.fieldPossibleAutofillReplacementAt, Date().timeIntervalSince(replacedAt) < 0.1 {
                DispatchQueue.main.async { [self] in
                    tryToContinue()
                }
            }
            self.fieldPossibleAutofillReplacementRange = nil
            self.fieldPossibleAutofillReplacementAt = nil
        }
    }
    
    //MARK: - Helpers
    
    func tryToContinue() {
        guard let code = confirmTextField.text else { return }
        isSubmitting = true
        Task {
            do {
                try await validate(validationCode: code)
                DispatchQueue.main.async {
                    self.continueToNextScreen()
                }
            } catch {
                handleError(error)
            }
        }
    }
    
    func validateInput() {
        isValidInput = confirmTextField.text?.count == 6
    }
    
    func handleError(_ error: Error) {
        isSubmitting = false
        confirmTextField.text = ""
//        CustomSwiftMessages.displayError(error)
    }
    
    //MARK: - ConfirmMethod Functions
    
    func resend() async throws {
        switch confirmMethod {
        case .phoneNumber:
            break
        }
    }
    
    func validate(validationCode: String) async throws {
        switch confirmMethod {
        case .phoneNumber:
            break
        }
    }
    
    @MainActor
    func continueToNextScreen() {
        switch confirmMethod {
        case .phoneNumber:
            transitionToHomeAndRequestPermissions() { }
            AuthContext.reset()
        }
    }
}
