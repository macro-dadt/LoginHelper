//
//  LoginViewController.swift
//  LoginKit
//
//  Created by DT Dat on 2018/5/27.
//  Copyright © 2017 Trim, Inc. All rights reserved.
//

import UIKit
import Validator

public protocol LoginViewControllerDelegate: AnyObject {

    func didSelectLogin(_ viewController: UIViewController, email: String, password: String)
    func didSelectForgotPassword(_ viewController: UIViewController)
    func loginDidSelectBack(_ viewController: UIViewController)

}

open class LoginViewController: UIViewController, BackgroundMovable, KeyboardMovable {

    // MARK: - Properties

    public weak var delegate: LoginViewControllerDelegate?

	public lazy var configuration: ConfigurationSource = {
		return DefaultConfiguration()
	}()

    var loginAttempted = false

    var loginInProgress = false {
        didSet {
            loginButton.isEnabled = !loginInProgress
        }
    }

    // MARK: Keyboard movable

    var selectedField: UITextField?

    var offset: CGFloat = 0.0

    // MARK: Background Movable

    var movableBackground: UIView { return backgroundImageView }

    // MARK: Outlet's

    @IBOutlet var fields: Array<SkyFloatingLabelTextField> = []
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: GradientImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!

    // MARK: - UIViewController

	override open func viewDidLoad() {
        super.viewDidLoad()
		_ = loadFonts
        setupValidation()
        initKeyboardMover()
        initBackgroundMover()
        customizeAppearance()
    }

	override open func loadView() {
        self.view = viewFromNib(optionalName: "LoginViewController")
    }

	override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyKeyboardMover()
    }

	override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Setup

    func customizeAppearance() {
        applyConfiguration()
        setupFonts()
    }

    func applyConfiguration() {
        backgroundImageView.image = configuration.backgroundImage
		backgroundImageView.gradientType = configuration.backgroundImageGradient ? .normalGradient : .none
        backgroundImageView.gradientColor = configuration.tintColor
        backgroundImageView.fadeColor = configuration.tintColor
        logoImageView.image = configuration.secondaryLogoImage

        emailTextField.placeholder = configuration.emailPlaceholder
        emailTextField.errorColor = configuration.errorTintColor
        passwordTextField.placeholder = configuration.passwordPlaceholder
        passwordTextField.errorColor = configuration.errorTintColor

        loginButton.setTitle(configuration.loginButtonText, for: .normal)
        loginButton.setTitleColor(configuration.tintColor, for: .normal)
        forgotPasswordButton.isHidden = !configuration.shouldShowForgotPassword
        forgotPasswordButton.setTitle(configuration.forgotPasswordButtonText, for: .normal)

        stackViewHeight.constant = configuration.shouldShowForgotPassword ? 200 : 125
    }

    func setupFonts() {
        emailTextField.font = Font.montserratRegular.get(size: 13)
        passwordTextField.font = Font.montserratRegular.get(size: 13)
        forgotPasswordButton.titleLabel?.font = Font.montserratLight.get(size: 13)
        loginButton.titleLabel?.font = Font.montserratRegular.get(size: 15)
    }

    // MARK: - Action's

    @IBAction func didSelectBack(_ sender: AnyObject) {
        delegate?.loginDidSelectBack(self)
    }

    @IBAction func didSelectLogin(_ sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        loginAttempted = true
        validateFields {
            delegate?.didSelectLogin(self, email: email, password: password)
        }
    }

    @IBAction func didSelectForgotPassword(_ sender: AnyObject) {
        
        delegate?.didSelectForgotPassword(self)
    }

}

// MARK: - Validation

extension LoginViewController {

    func setupValidation() {
        setupValidationOn(field: emailTextField, rules: ValidationService.emailRules)
        setupValidationOn(field: passwordTextField, rules: ValidationService.passwordRules)
    }

    func setupValidationOn(field: SkyFloatingLabelTextField, rules: ValidationRuleSet<String>) {
        field.validationRules = rules
        field.validateOnInputChange(enabled: true)
        field.validationHandler = validationHandlerFor(field: field)
    }

    func validationHandlerFor(field: SkyFloatingLabelTextField) -> ((ValidationResult) -> Void) {
        return { result in
            switch result {
            case .valid:
                guard self.loginAttempted == true else {
                    break
                }
                field.errorMessage = nil
            case .invalid(let errors):
                guard self.loginAttempted == true else {
                    break
                }
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
    }

    func validateFields(success: () -> Void) {
        var errorFound = false
        for field in fields {
            let result = field.validate()
            switch result {
            case .valid:
                field.errorMessage = nil
            case .invalid(let errors):
                errorFound = true
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
        if !errorFound {
            success()
        }
    }

}

// MARK: - UITextField Delegate

extension LoginViewController : UITextFieldDelegate {

	public func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField
    }

	public func textFieldDidEndEditing(_ textField: UITextField) {
        selectedField = nil
    }

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

        let nextTag = textField.tag + 1
        let nextResponder = view.viewWithTag(nextTag) as UIResponder!

        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            didSelectLogin(self)
        }
        
        return false
    }
    
}
