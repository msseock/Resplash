//
//  NetworkManager.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    private var currentKey: UnsplashKey = .access
    private var header: HTTPHeaders {
        [
            "Authorization": currentKey.headerValue
        ]
    }
    
    func request(
        endpoint: UnsplashEndpoint,
        completionHandler: @escaping (Result<Decodable, Error>) -> Void
    ) {
        
        let url = APIConstants.baseURL + endpoint.path
        
        AF.request(
            url,
            method: .get,
            parameters: endpoint.parameters,
            encoding: URLEncoding.queryString,
            headers: header
        )
        .validate(statusCode: 200..<300)
        .response { response in
            
            do {
                guard let urlResponse = response.response else {
                    print("ERROR: response.response 없음")
                    throw UnsplashError(errors: ["response 없음"])
                }
                
                // rate limit 확인
                self.checkRateLimit(response: urlResponse)
                
                // statusCode 확인 & data 검증
                let statusCode = UnsplashStatusCode(rawValue: urlResponse.statusCode) ?? .undefinedError
                print("statusCode >>>>", statusCode)
                
                guard let data = response.data else {
                    print("ERROR: response.data 없음")
                    throw UnsplashError(errors: ["응답 데이터 없음"])
                }
                
                switch statusCode {
                case .ok:
                    let decodedData = try JSONDecoder().decode(endpoint.reponseType.self, from: data)
                    dump(decodedData)
                    completionHandler(.success(decodedData))
                    
                default:
                    let decodedError = try JSONDecoder().decode(UnsplashError.self, from: data)
                    dump(decodedError)
                    
                    completionHandler(.failure(statusCode))
                    
                }
            } catch {
                print("error localizedDescription: \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }

    }
    
    private func checkRateLimit(response: HTTPURLResponse) {
        guard let rateLimitText = response.value(forHTTPHeaderField: "X-Ratelimit-Remaining"), let rateLimit = Int(rateLimitText) else {
            print("X-Ratelimit-Remaining: 없음")
            return
        }
        
        print("currentKey: \(currentKey.rawValue)\nX-Ratelimit-Remaining:\(rateLimit)")
        if rateLimit == 0 {
            print("호출횟수 제한으로 다음 호출에는 키 교체 예정")
            self.changeToNextKey()
        }

    }
    
    private func changeToNextKey() {
        switch self.currentKey {
        case .access:
            self.currentKey = .spare1
        case .spare1:
            self.currentKey = .spare2
        case .spare2:
            self.currentKey = .access
        }
    }
}


