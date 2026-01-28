//
//  NetworkManager.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    private var currentKey: UnsplashKey = .access
    private var header: HTTPHeaders {
        [
            "Authorization": currentKey.headerValue
        ]
    }
    
    func request(endpoint: UnsplashEndpoint, completionHandler: @escaping () -> Void) {
        
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
            
            guard let urlResponse = response.response else {
                print("ERROR: response.response 없음")
                return
            }
            
            // rate limit 확인
            print("X-Ratelimit-Remaining: \(urlResponse.value(forHTTPHeaderField: "X-Ratelimit-Remaining") ?? "없음")")
            
            if let rateLimitText = urlResponse.value(forHTTPHeaderField: "X-Ratelimit-Remaining"),
            let rateLimit = Int(rateLimitText),
            rateLimit == 0 {
                print("호출횟수 제한으로 다음 호출에는 키 교체 예정")
                self.changeToNextKey()
            }
            
            // statusCode 확인 & data 검증
            let statusCode = UnsplashStatusCode(rawValue: urlResponse.statusCode) ?? .undefinedError
            print("statusCode >>>>", statusCode)
            
            guard let data = response.data else {
                print("ERROR: response.data 없음")
                return
            }

            do {
                if statusCode == .ok {
                    let decodedData = try JSONDecoder().decode(endpoint.reponseType.self, from: data)
                    dump(decodedData)
                    
                    completionHandler()
                    
                } else {
                    let decodedData = try JSONDecoder().decode(UnsplashError.self, from: data)

                    dump(decodedData)
                }
            } catch {
                print("Decoding error: \(error)")
            }
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


