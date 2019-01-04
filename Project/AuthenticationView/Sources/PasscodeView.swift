//
//  NumberPad.swift
//  AuthenticationView
//
//  Created by Alex Ilies on 16/08/2018.


import UIKit

public protocol PasscodeViewDelegate: class {
  func authDidSucceed(succes: Bool, message: String?)
  func passcodeDidComplete(passcode: String?)
}

public class PasscodeView: UIView {
  
  private lazy var passcodeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
    label.textColor = .roseColor
    label.text = String()
    
    return label
  }()
  
  private var combinationKey: String = String() {
    didSet {
      let color: UIColor = combinationKey.count > 0 ? .red : .white
      clearButton.setTitleColor(color, for: .normal)
    }
  }
  
  private var passcodeLenght: Int = 4
  private var clearButton: UIButton!
  private let touchMe = BiometricIDAuth()
  
  var localAuthButton: UIButton!
  
  open var delegate: PasscodeViewDelegate?
  
  var viewStyle: Style = .dark {
    didSet {
      prepareView()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  fileprivate func prepareView() {
    self.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    
    let verticalStackView = UIStackView()
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    var buttonNumber = 0
    
    for _ in 1...3 {
      let horizontalStackView = UIStackView()
      horizontalStackView.distribution = .fillEqually
      horizontalStackView.axis = .horizontal
      horizontalStackView.spacing = 20
      
      for _ in 1...3 {
        let button = UIButton()
        buttonNumber += 1
        button.setTitle("\(buttonNumber)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        button.tag = buttonNumber
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch viewStyle {
        case .dark:
          button.setTitleColor(.lightColor, for: .normal)
        case .light:
          button.setTitleColor(.darkColor, for: .normal)
        }
        
        button.addTarget(self, action: #selector(keyButtonDidPress(sender:)), for: .touchUpInside)
        horizontalStackView.addArrangedSubview(button)
        verticalStackView.addArrangedSubview(horizontalStackView)
      }
    }
    
    // Add buttom buttons: 0 and Touch/Face ID
    
    let bottomButtons = bottomButtonsView()
    verticalStackView.addArrangedSubview(bottomButtons)
    
    verticalStackView.spacing = 20
    verticalStackView.frame = frame
    verticalStackView.distribution = .fillEqually
    verticalStackView.axis = .vertical
    
    addSubview(passcodeLabel)
    addSubview(verticalStackView)
    
    NSLayoutConstraint.activate([
      passcodeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 80),
      passcodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      passcodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      passcodeLabel.heightAnchor.constraint(equalToConstant: 50),
      
      verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.3),
      verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      ])
  }
  
  fileprivate func bottomButtonsView() -> UIStackView {
    let horizontalStackView = UIStackView()
    horizontalStackView.distribution = .fillEqually
    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = 20
    
    prepareClearButton()
    
    horizontalStackView.addArrangedSubview(prepareLocalAuthButton())
    horizontalStackView.addArrangedSubview(zeroButton())
    horizontalStackView.addArrangedSubview(clearButton)
    
    return horizontalStackView
  }
  
  fileprivate func zeroButton() -> UIButton {
    let zeroButton = UIButton()
    zeroButton.setTitle("0", for: .normal)
    zeroButton.tag = 0
    zeroButton.addTarget(self, action: #selector(keyButtonDidPress(sender:)), for: .touchUpInside)
    zeroButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    
    switch viewStyle {
    case .dark:
      zeroButton.setTitleColor(.lightColor, for: .normal)
    case .light:
      zeroButton.setTitleColor(.darkColor, for: .normal)
    }
    
    return zeroButton
  }
  
  fileprivate func prepareClearButton() {
    clearButton = UIButton()
    clearButton.setTitle("←", for: .normal)
    clearButton.addTarget(self, action: #selector(clearButtonDidPress(sender:)), for: .touchUpInside)
    clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
  }
  
  fileprivate func prepareLocalAuthButton() -> UIButton  {
    localAuthButton = UIButton()
    
    if !touchMe.canEvaluatePolicy() {
      localAuthButton.isUserInteractionEnabled = false
      return localAuthButton
    }
    
    localAuthButton.addTarget(self, action: #selector(localAuthButtonDidPress(sender:)), for: .touchUpInside)
    
    localAuthButton.isHidden = !touchMe.canEvaluatePolicy()
    
    switch touchMe.biometricType() {
    case .faceID:
      let faceIdImage = UIImage(named: "ic-face-id", in: Bundle(for: type(of: self)), compatibleWith: nil)
      localAuthButton.setImage(faceIdImage!, for: .normal)
      localAuthButton.imageView?.contentMode = .scaleAspectFit
    default:
      localAuthButton.setImage(UIImage(named: "ic-touch-id"),  for: .normal)
    }
    
    return localAuthButton
  }
  
  fileprivate func checkPasscode() {
    do {
      let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                              account: KeychainConfiguration.account,
                                              accessGroup: KeychainConfiguration.accessGroup)
      
      let keychainPassword = try passwordItem.readPassword()
      let passcodeMatch = combinationKey == keychainPassword
      
      let message = passcodeMatch ? "" : "Wrong passcode"
      
      self.delegate?.authDidSucceed(succes: passcodeMatch, message: message)
      
    } catch {
      print(("Error reading password from keychain - \(error)"))
    }
  }
  
  @objc private func keyButtonDidPress(sender: UIButton) {
    combinationKey += "\(sender.tag)"
    passcodeLabel.text?.append("*")
    
    if combinationKey.count == passcodeLenght {
      delegate?.passcodeDidComplete(passcode: combinationKey)
      checkPasscode()
      combinationKey = String()
      passcodeLabel.text? = String()
    }
  }
  
  @objc private func localAuthButtonDidPress(sender: UIButton) {
    touchMe.authenticateUser { (message) in
      if message == message {
        self.delegate?.authDidSucceed(succes: false, message: message)
      } else {
        self.delegate?.authDidSucceed(succes: true, message: nil)
      }
    }
  }
  
  @objc private func clearButtonDidPress(sender: UIButton) {
    combinationKey = String(combinationKey.dropLast())
    passcodeLabel.text = String(passcodeLabel.text?.dropLast() ?? "")
  }
}

