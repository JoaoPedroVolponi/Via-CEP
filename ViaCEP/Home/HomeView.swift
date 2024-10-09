//
//  HomeView.swift
//  ViaCEP
//
//  Created by João Pedro Volponi on 06/10/24.
//

import UIKit

class HomeView: UIView {
    
    private let viewController: HomeViewController
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        configBackGround()
        configHierarchy()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cepTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite o CEP"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let buscarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar Endereço", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buscarCEP), for: .touchUpInside)
        return button
    }()
    
    let logradouroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bairroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cidadeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let estadoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configBackGround() {
        backgroundColor = .white
    }
    
    func configHierarchy() {
        addSubview(cepTextField)
        addSubview(buscarButton)
        addSubview(logradouroLabel)
        addSubview(bairroLabel)
        addSubview(cidadeLabel)
        addSubview(estadoLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            cepTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            cepTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            cepTextField.widthAnchor.constraint(equalToConstant: 200),
            
            buscarButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            buscarButton.topAnchor.constraint(equalTo: cepTextField.bottomAnchor, constant: 20),
            
            logradouroLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            logradouroLabel.topAnchor.constraint(equalTo: buscarButton.bottomAnchor, constant: 20),
            
            bairroLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bairroLabel.topAnchor.constraint(equalTo: logradouroLabel.bottomAnchor, constant: 10),
            
            cidadeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cidadeLabel.topAnchor.constraint(equalTo: bairroLabel.bottomAnchor, constant: 10),
            
            estadoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            estadoLabel.topAnchor.constraint(equalTo: cidadeLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func buscarCEP() {
        guard let cep = cepTextField.text, !cep.isEmpty else {
            logradouroLabel.text = "Por favor, insira um CEP válido."
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
}
