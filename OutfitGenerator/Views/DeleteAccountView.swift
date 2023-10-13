//
//  DeleteAccountView.swift
//  OutfitGenerator
//
//  Created by Jason on 10/11/23.
//

import UIKit

class DeleteAccountView: UIView {

    var delegate: DeleteAccountViewDelegate?
    
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
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
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
        
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        stackView.addArrangedSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func backButtonTapped() {
        delegate?.dismiss()
    }
}

protocol DeleteAccountViewDelegate {
    func dismiss()
}
