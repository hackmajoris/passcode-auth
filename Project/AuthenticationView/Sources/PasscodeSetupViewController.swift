//
//  PasscodeSetupViewController.swift
//  AuthenticationView
//
//  Created by Alex Ilies on 22/08/2018.
//

import UIKit

class PasscodeSetupViewController: UIViewController {
  
  private lazy var infoLabel : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Setup the passcode"
    label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    label.numberOfLines = 0
    label.textColor = .white
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var passcodeView: PasscodeView = {
    let view = PasscodeView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.localAuthButton.setImage(UIImage(), for: .normal)
    view.localAuthButton.isUserInteractionEnabled = false
    view.delegate = self
    
    return view
  }()
  
  private var firstPasscodeAttempt: String!
  private var secondPasscodeAttempt: String!
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(passcodeView)
    view.addSubview(infoLabel)
    
    preparePasscodeView()
  }
  
  // The KeychainPasswordItem is design to save password but in this case we will save the passcode 🤡.
  private func saveUserPasscodeInKeychain(passcode: String) {
    do {
      // Override each time the passcode
      let passcodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                              account: KeychainConfiguration.account,
                                              accessGroup: KeychainConfiguration.accessGroup)
      // Save the password for the new item.
      try passcodeItem.savePassword(passcode)
      
      handleSuccessPasscodeSetup()
      
    } catch {
      fatalError("Error updating keychain - \(error)")
    }
  }
  
  fileprivate func preparePasscodeView() {
    NSLayoutConstraint.activate([
      infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      infoLabel.heightAnchor.constraint(equalToConstant: 40),
      infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
      infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
      
      passcodeView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
      passcodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
      passcodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      passcodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      ])
  }
  
  fileprivate func handleSuccessPasscodeSetup() {
    let alert = UIAlertController(title: "Authentication", message: "Passcode succesfully saved", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
      
      if let _ = UIApplication.shared.keyWindow {
        //Handle success authentication
        
        //window.rootViewController = HomeViewController()
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  fileprivate func handleWrongPasscodeSetup() {
    firstPasscodeAttempt = nil
    secondPasscodeAttempt = nil
    infoLabel.text = "Setup the passcode"
    
    let alert = UIAlertController(title: "Authentication", message: "Passcode does not match. Try again", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
}

extension PasscodeSetupViewController: PasscodeViewDelegate {
  func authDidSucceed(succes: Bool, message: String?) {}
  
  func passcodeDidComplete(passcode: String?) {
    //self.present(self, animated: true, completion: nil)
    if let passcode = passcode {
      if firstPasscodeAttempt == nil {
        firstPasscodeAttempt = passcode
        infoLabel.text = "Set the passcode again"
      } else {
        secondPasscodeAttempt = passcode
        if firstPasscodeAttempt == secondPasscodeAttempt {
          saveUserPasscodeInKeychain(passcode: passcode)
        } else {
          handleWrongPasscodeSetup()
        }
      }
    }
  }
}
