//
//  APIEndpoint.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case login
    case register
    case logout
    case refreshToken
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: AppConfig.API.endPoint)!
    }

    var headers: [String: String]? {
        return [:]
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"
        case .register:
            return "/v1/auth/register"
        case .logout:
            return "/v1/auth/logout"
        case .refreshToken:
            return "/v1/auth/refresh-token"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .register, .logout, .refreshToken:
            return .post
        }
    }
}
