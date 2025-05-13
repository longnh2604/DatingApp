//
//  APIServiceManager.swift
//  DatingApp
//
//  Created by LongNH8 on 13/5/25.
//

import UIKit
import Alamofire
import Combine

enum EncodingType: Int {
    case params = 0
    case body
}

struct RequestNetWorkModel {
    let baseURL: URL
    let path: String
    let method: Alamofire.HTTPMethod
    let params: [String: Any]
    var headers: HTTPHeaders?
    let encoding: EncodingType? /// set for reuqest param or body (for post body: JSONEncoding.default, for params: URLEncoding.default)
    init(baseURL: URL, path: String,method: Alamofire.HTTPMethod, params: [String : Any] = [:], headers: HTTPHeaders? = HTTPHeaders.init([HTTPHeader(name: "Accept-Language", value: "ja")]), encoding: EncodingType? = .params){
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
        self.encoding = encoding
    }
}

class ConnectivityNetWork {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class APIServiceManager:NSObject {
    static let shared = APIServiceManager()
    private let kUserCredential = "KEY_USER_CREDENTIAL"
    
    private var isProcessingError = false
    private var isNetworkError = false // for timeout
    
    private override init() {}
    /// Save OAuth for refresh token
    /// - Parameter model: that saved token, refresh token
    func saveUserCredential(model: OAuthCredential) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            UserDefaults.standard.set(encoded, forKey: kUserCredential)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Remove saved info
    func removeUserCredential() {
        UserDefaults.standard.removeObject(forKey: kUserCredential)
        UserDefaults.standard.synchronize()
    }
    
    /// Return model of refresh token
    /// - Returns: token, refresh token
    func getUserCredential() -> OAuthCredential? {
        if let savedModel = UserDefaults.standard.object(forKey: kUserCredential) as? Data {
            let decoder = JSONDecoder()
            if let loadedModel = try? decoder.decode(OAuthCredential.self, from: savedModel) {
                return loadedModel
            }
            return nil
        }
        return nil
    }
}

extension APIServiceManager {
    
    func request<T>(object: T.Type, request: RequestNetWorkModel) -> AnyPublisher<Alamofire.DataResponse<T, NetworkError>, Never> where T : Decodable {
        
        let interceptor = OAuthAuthenticator.shared
        
        if !ConnectivityNetWork.isConnectedToInternet {
            return Just(DataResponse<T, NetworkError>(request: nil,
                                                      response: nil,
                                                      data: nil,
                                                      metrics: nil,
                                                      serializationDuration: 0,
                                                      result: .failure(NetworkError(statusCode: nil, backendError: nil)))).eraseToAnyPublisher()
        }
        
        return AF.request(URL(string: request.baseURL.absoluteString + request.path)!,
                          method: request.method,
                          parameters: request.params,
                          encoding: request.encoding == .params ? URLEncoding.default : JSONEncoding.default,
                          headers: request.headers,
                          interceptor: interceptor) { urlRequest in
            urlRequest.timeoutInterval = 60
        }
        .cURLDescription(calling: { value in
            print(value)
        })
        .validate()
        .publishDecodable(type: object.self)
        .map { response in
            // TODO: possible be wrong if api return 401 after refresh token success
            interceptor.countApiRequest = max(interceptor.countApiRequest - 1, 0)
            
            func handleToastError() {
                if self.isProcessingError {
                    NotificationCenter.default.post(name: .errorNetworkNoti, object: nil, userInfo: ["message": localized(key: .processingError)])
                } else if self.isNetworkError {
                    NotificationCenter.default.post(name: .errorNetworkNoti, object: nil, userInfo: ["message": localized(key: .networkError)])
                }
            }
            
            if response.error == nil {
                handleToastError()
            }
            
            return response.mapError { _ in
                let mappingError = self.mappingError(response)
                
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    if let nsError = error.underlyingError as? NSError, nsError.code == NSURLErrorTimedOut {
                        self.isNetworkError = true
                        handleToastError()
                        return mappingError
                    }
                }
                
                self.isProcessingError = true
                
                handleToastError()
                return mappingError
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func mappingError<T>(_ response: DataResponse<T, AFError>) -> NetworkError {
        guard let data = response.data else {
            print("=====>")
            return NetworkError(statusCode: response.response?.statusCode, backendError: nil)
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("=====>")
            return NetworkError(statusCode: response.response?.statusCode, backendError: nil)
        }
        print("jsonObject: ", jsonObject)
        let decoder = JSONDecoder()
        let parsedData = try? decoder.decode(BackendError.self, from: data)
        return NetworkError(statusCode: response.response?.statusCode, backendError: parsedData)
    }
}

struct NetworkError: Error {
    let statusCode: Int?
    let backendError: BackendError?
}

struct BackendError:Codable, Error {
    var error: Int?
    var message: String?
    
    var errorType: BackendErrorType? {
        return BackendErrorType(rawValue: error ?? -1)
    }
    
    enum CodingKeys: String, CodingKey {
        case error = "error_code"
        case message = "error_message"
    }
}

struct NetworkArrayError: Error {
    let statusCode: Int
    let backendError: BackendArrayError?
}

struct BackendArrayError:Codable, Error {
    var error: String?
    var messages: [String]?
}

enum BackendErrorType: Int {
    case notWeeklyData = 400003
    case trainingNotHaveComment = 400004
    case exerciseHistoryNotExist = 400006
    case exerciseTypeNotExist = 400007
    case invalidFitbit = 400008
    case duplicateHistoryId = 400009
    case historyIdNotExist = 400010
    case startTimeSmallerThanEndTime = 400012
    case invalidMissionId = 400013
    case multipleMissionADay = 400014
    case hairStyleNotExist = 400016
    case weeklyAggregateNotExist = 400017
    case userMissionNotExist = 400019
    case exerciseAndEndTimeEmpty = 400021
    case exerciseNotFinished = 400022
    case invalidEndTime = 400023
    case invalidExerciseTypeId = 400024
    case invalidQuestionId = 400025
    case invalidToken = 401003
    case invalidSASToken = 401005
    case alreadyRegistered = 401006
    case accountNotExist = 401007
    case invalidRefreshToken = 401009
    case fitbitNotEnoughPermission = 403001
}
