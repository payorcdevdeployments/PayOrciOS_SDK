//
//  FormViewController.swift
//  Alamofire
//
//  Created by Ramanathan on 30/01/25.
//

import UIKit

// MARK: - ViewController
public class FormViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    private var sections: [FormSection] = []
    private var collectionView: UICollectionView!
    private let submitButton = UIButton(type: .system)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
        setupSubmitButton()
    }
    
    private func setupData() {
        sections = [
            FormSection(title: "Order Details", fields: [
                FormField(title: "Order ID", placeholder: "Enter Order ID", value: nil, keyboardType: .numberPad, validation: { !$0.isEmpty }),
                FormField(title: "Amount", placeholder: "Enter Amount", value: nil, keyboardType: .decimalPad, validation: { !$0.isEmpty })
            ]),
            FormSection(title: "Customer Details", fields: [
                FormField(title: "Customer Name", placeholder: "Enter Name", value: nil, keyboardType: .default, validation: { !$0.isEmpty }),
                FormField(title: "Email", placeholder: "Enter Email", value: nil, keyboardType: .emailAddress, validation: { $0.contains("@") })
            ])
        ]
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FormCollectionViewCell.self, forCellWithReuseIdentifier: "FormCell")
        view.addSubview(collectionView)
    }
    
    private func setupSubmitButton() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc
    private func submitForm() {
        for section in sections {
            for field in section.fields {
                if let value = field.value, !value.isEmpty {
                    continue
                } else {
                    AlertHelper.showAlert(on: self, message: "Please fill in all fields")
                    return
                }
            }
        }
        AlertHelper.showAlert(on: self, message: "Form submitted successfully!")
    }
        
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].fields.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormCell", for: indexPath) as! FormCollectionViewCell
        let field = sections[indexPath.section].fields[indexPath.item]
        cell.configure(with: field)
        return cell
    }
}

// MARK: - UICollectionViewCell
public class FormCollectionViewCell: UICollectionViewCell {
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with field: FormField) {
        textField.placeholder = field.placeholder
        textField.keyboardType = field.keyboardType
    }
}
