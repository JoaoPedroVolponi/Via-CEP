//
//  HomeView.swift
//  ViaCEP
//
//  Created by João Pedro Volponi on 06/10/24.
//

import UIKit

import UIKit

class HomeView: UIView, UITextFieldDelegate {
    
    private let viewController: HomeViewController
    
    lazy var imageLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ilustration-home")
        return image
    }()
    
    lazy var imageBack: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "background")
        return image
    }()
    
    
    lazy var cepTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite o CEP"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var buscarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar Endereço", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buscarCEP), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "primary")
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var logradouroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bairroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cidadeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var estadoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        configBackGround()
        configHierarchy()
        configConstraints()
        cepTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configBackGround() {
        backgroundColor = .white
    }
    
    func configHierarchy() {
        addSubview(imageLogo)
        addSubview(cepTextField)
        addSubview(buscarButton)
        addSubview(logradouroLabel)
        addSubview(bairroLabel)
        addSubview(cidadeLabel)
        addSubview(estadoLabel)
        addSubview(imageBack)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            imageLogo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 254),
            imageLogo.widthAnchor.constraint(equalToConstant: 284),
            
            cepTextField.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 10),
            cepTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            cepTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            cepTextField.widthAnchor.constraint(equalToConstant: 200),
            
            buscarButton.topAnchor.constraint(equalTo: cepTextField.bottomAnchor, constant: 20),
            buscarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            buscarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            buscarButton.widthAnchor.constraint(equalToConstant: 230),
            
            logradouroLabel.topAnchor.constraint(equalTo: buscarButton.bottomAnchor, constant: 20),
            logradouroLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            logradouroLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            bairroLabel.topAnchor.constraint(equalTo: logradouroLabel.bottomAnchor, constant: 10),
            bairroLabel.leadingAnchor.constraint(equalTo: logradouroLabel.leadingAnchor),
            bairroLabel.trailingAnchor.constraint(equalTo: logradouroLabel.trailingAnchor),
            
            cidadeLabel.topAnchor.constraint(equalTo: bairroLabel.bottomAnchor, constant: 10),
            cidadeLabel.leadingAnchor.constraint(equalTo: logradouroLabel.leadingAnchor),
            cidadeLabel.trailingAnchor.constraint(equalTo: logradouroLabel.trailingAnchor),
            
            estadoLabel.topAnchor.constraint(equalTo: cidadeLabel.bottomAnchor, constant: 10),
            estadoLabel.leadingAnchor.constraint(equalTo: logradouroLabel.leadingAnchor),
            estadoLabel.trailingAnchor.constraint(equalTo: logradouroLabel.trailingAnchor),
            
            imageBack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            imageBack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            imageBack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
        ])
    }
    
    @objc func buscarCEP() {
        guard let cep = cepTextField.text?.replacingOccurrences(of: "-", with: ""), cep.count == 8 else {
            logradouroLabel.text = "Por favor, insira um CEP válido."
            clearAddressFields()
            return
        }
        
        viewController.viewModel.buscarCEP(cep: cep) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (logradouro, bairro, cidade, estado)):
                    self?.logradouroLabel.text = "Logradouro: \(logradouro)"
                    self?.bairroLabel.text = "Bairro: \(bairro)"
                    self?.cidadeLabel.text = "Cidade: \(cidade)"
                    self?.estadoLabel.text = "Estado: \(estado)"
                case .failure(let error):
                    self?.logradouroLabel.text = "Erro: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func clearAddressFields() {
        logradouroLabel.text = ""
        bairroLabel.text = ""
        cidadeLabel.text = ""
        estadoLabel.text = ""
    }
    
    // MARK: - Máscara de CEP
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let cleanText = updatedText.replacingOccurrences(of: "-", with: "")
        
        if cleanText.count > 8 {
            return false
        } else {
            clearAddressFields()
        }
        
        if cleanText.count <= 5 {
            textField.text = cleanText
        } else {
            let prefix = cleanText.prefix(5)
            let suffix = cleanText.suffix(from: cleanText.index(cleanText.startIndex, offsetBy: 5))
            textField.text = "\(prefix)-\(suffix)"
        }
        
        return false
    }
}
