//
//  PasswordSettingsView.swift
//  OutfitGenerator
//
//  Created by Jason on 10/11/23.
//

import UIKit

class PasswordSettingsView: UIView {

    var delegate: PasswordSettingsViewDelegate?
    
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
    
    private let currentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Password"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Password"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
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
        
        stackView.addArrangedSubview(currentPasswordTextField)
        currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        currentPasswordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        currentPasswordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        stackView.addArrangedSubview(newPasswordTextField)
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        newPasswordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        stackView.addArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func backButtonTapped() {
        delegate?.dismiss()
    }
}

protocol PasswordSettingsViewDelegate {
    func dismiss()
}
