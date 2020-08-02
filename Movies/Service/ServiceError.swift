//
//  ServiceError.swift
//  Eventos
//
//  Created by Douglas Hennrich on 22/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case badRequest             // Status code 400
    case notFound               // Status code 404
    case toManyRequests         // Status code 429
    case internalServerError    // Status code 500
    
    case cantCreateUrl
    case noService
    case unknow(error: Error)
    
    var message: String {
        switch self {
        case .badRequest:
            return "API inválida"
            
        case .notFound:
            return "API não encontrada"
            
        case .toManyRequests:
            return "API indisponível no momento"
            
        case .internalServerError:
            return "Erro na API"
            
        case .cantCreateUrl:
            return "Erro ao montar a API"
            
        case .noService:
            return "Sem serviço"
            
        case .unknow:          
            return "Erro inesperado"
        }
    }
    
    var type: ServiceError {
        switch self {
        case .badRequest:
            return .badRequest
        case .notFound:
            return .notFound
        case .toManyRequests:
            return .toManyRequests
        case .internalServerError:
            return .internalServerError
        case .cantCreateUrl:
            return .cantCreateUrl
        case .noService:
            return .noService
        case .unknow(let error):
            return .unknow(error: error)
        }
    }
    
}
