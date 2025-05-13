//
//  Untitled.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import Foundation
import Alamofire

struct OAuthCredential: AuthenticationCredential, Codable {
    var requiresRefresh: Bool { false }
    let accessToken: String
    let refreshToken: String
}

struct ResAccessToken: Codable {
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

class OAuthAuthenticator: RequestInterceptor {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ oauth: OAuthCredential?) -> Void

    static let shared = OAuthAuthenticator()

    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    var countApiRequest = 0
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        countApiRequest += 1
        var adaptedRequest = urlRequest
        guard let oath = APIServiceManager.shared.getUserCredential() else {
            completion(.success(adaptedRequest))
            return
        }
        adaptedRequest.setValue("Bearer \(oath.accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
    }
    
    // MARK: - RequestRetrier
    private var isRefreshFail = false
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        // requestsToRetry call doNotRetry make this function call again
        if isRefreshFail == true {
            completion(.doNotRetry)
            return
        }
        print(error)
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if countApiRequest == requestsToRetry.count && !isRefreshing {
                
                refreshTokens { [weak self] succeeded, oauth in
                    guard let strongSelf = self else { return }

                    let currentCount = strongSelf.requestsToRetry.count // in case waitting refresh token finish, there's new api called and response 401 first
                    if succeeded {
                        strongSelf.requestsToRetry.forEach { $0(.retry) }
                        strongSelf.countApiRequest -= currentCount // substract countApiRequest twice because countApiRequest add one more time when retry
                    } else {
                        strongSelf.isRefreshFail = true
                        strongSelf.requestsToRetry.forEach { $0(.doNotRetry) }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            strongSelf.isRefreshFail = false
                        })
                        NotificationCenter.default.post(name: .tokenExpiredNoti, object: nil, userInfo: nil)
                    }
                    
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        guard let oath = APIServiceManager.shared.getUserCredential() else {
            completion(false, nil)
            return
        }
        isRefreshing = true
        
        let tokenRequestParameters = ["refresh_token": oath.refreshToken]
        let endPoint = APIEndpoint.refreshToken
        AF.request(
            URL(string: endPoint.baseURL.absoluteString + endPoint.path)!,
            method: endPoint.method,
            parameters: tokenRequestParameters,
            encoder: JSONParameterEncoder.default,
            headers: nil
        )
        .responseDecodable(of: ResAccessToken.self) { [weak self] response in
            switch response.result {
            case .success(let token):
                let credential = OAuthCredential(accessToken: token.accessToken, refreshToken: token.refreshToken)
                APIServiceManager.shared.saveUserCredential(model: credential)
                completion(true, credential)
            case .failure(let error):
                // force logout user
                completion(false, nil)
            }
            self?.isRefreshing = false
        }
    }
}
