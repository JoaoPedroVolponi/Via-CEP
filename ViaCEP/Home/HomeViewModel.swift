//
//  HomeViewModel.swift
//  ViaCEP
//
//  Created by João Pedro Volponi on 06/10/24.
//

import UIKit

protocol HomeViewModelProtocol {
    func buscarCEP(cep: String, completion: @escaping (Result<(logradouro: String, bairro: String, cidade: String, estado: String), Error>) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {

    func buscarCEP(cep: String, completion: @escaping (Result<(logradouro: String, bairro: String, cidade: String, estado: String), Error>) -> Void) {
        let urlString = "https://viacep.com.br/ws/\(cep)/json/"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL inválida", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Nenhum dado retornado", code: 400, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let logradouro = json["logradouro"] as? String ?? ""
                    let bairro = json["bairro"] as? String ?? ""
                    let cidade = json["localidade"] as? String ?? ""
                    let estado = json["uf"] as? String ?? ""

                    completion(.success((logradouro, bairro, cidade, estado)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
