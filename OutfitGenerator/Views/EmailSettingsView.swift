//
//  EmailSettingsView.swift
//  OutfitGenerator
//
//  Created by Jason on 10/10/23.
//

import UIKit

class EmailSettingsView: UIView {
    
    var delegate: EmailSettingsViewDelegate?
    
    let backButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(
            systemName: "chevron.left",
            withConfiguration: configuration
        )?.withTintColor(
            .systemGreen,
            renderingMode: .alwaysOriginal
        )
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.setTitle(" Back", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.sizeToFit()
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
        return stackView
    }()
    
    private let emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        stackView.addArrangedSubview(emailAddressTextField)
        emailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        emailAddressTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        emailAddressTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        emailAddressTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func backButtonTapped() {
        delegate?.dismiss()
    }
}

protocol EmailSettingsViewDelegate {
    func dismiss()
}
