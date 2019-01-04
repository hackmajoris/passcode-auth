//
//  ExampleLightMode.swift
//  AuthenticationView
//
//  Created by Alex Ilies on 17/08/2018.

import UIKit

class LightModeViewController: PasscodeViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    passcodeViewStyle = .light
  }
  
  fileprivate func handleSuccessAuthentication() {
    if let window = UIApplication.shared.keyWindow, window.rootViewController == self {
      window.rootViewController = HomeViewController()
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  fileprivate func handleWrongAuthentication() {
    let alert = UIAlertController(title: "Authentication", message: "Authentication problem. Try again", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  override func authDidSucceed(succes: Bool, message: String?) {
    if succes {
      handleSuccessAuthentication()
    } else {
      handleWrongAuthentication()
    }
  }
  
}
