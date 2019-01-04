//
//  ViewController.swift
//  AuthenticationView
//
//  Created by Alex Ilies on 16/08/2018.


import UIKit

open class PasscodeViewController: UIViewController {
  
  private lazy var passcodeView: PasscodeView = {
    let view = PasscodeView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    
    return view
  }()
  
  public var passcodeViewStyle: Style = .dark {
    didSet {
      switch passcodeViewStyle {
      case .dark:
        view.backgroundColor = .darkColor
        passcodeView.viewStyle = .dark
        
      case.light:
        view.backgroundColor = .lightColor
        passcodeView.viewStyle = .light
      }
    }
  }
  
  private let touchMe = BiometricIDAuth()
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(passcodeView)
    
    preparePasscodeView()
  }
  
  fileprivate func preparePasscodeView() {
    NSLayoutConstraint.activate([
      passcodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
      passcodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      passcodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      passcodeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
      ])
  }
}

extension PasscodeViewController: PasscodeViewDelegate {
  
  public func passcodeDidComplete(passcode: String?) {}
  
  @objc open func authDidSucceed(succes: Bool, message: String?) {} // Handle in subclass
}

