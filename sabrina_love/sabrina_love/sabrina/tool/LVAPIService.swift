//
//  LVAPIService.swift
//  sabrina_love
//
//  Created by Jumbo on 2020/1/15.
//  Copyright © 2020 Jumbo. All rights reserved.
//

import UIKit

struct LVAPIService {
//    let baseURL = URL(string: "")!
    static var shared = LVAPIService()
    let apiKey = Bundle.main.bundleIdentifier
    let decoder = JSONDecoder()
    var lvReconnectTime = 0
    
    enum APIError: Error {
        case noResponse
        case noNetwork
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    enum Endpoint {
        case lv_initSabrina
        
        func path() -> String {
            switch self {
            case .lv_initSabrina:
                return "aHR0cHM6Ly9zYWJyaW5haG9uZy5naXRlZS5pby9zYWJyaW5hX2xvdmUvaW5pdC5qc29u".lv_fromBase64()!
            }
        }
    }
    
    /// GET请求
    func GET<T: Codable>(endpoint: Endpoint,
                         params: [String: String]?,
                         completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let queryURL = URL(string: endpoint.path())!
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey?.lv_md5),
            URLQueryItem(name: "language", value: Locale.preferredLanguages[0]),
            URLQueryItem(name: "refresh", value: String(arc4random()))
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        print("-- 请求 type: \(endpoint)\n-- 请求 url: \(components.url!)")
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                LVAPIService.shared.lv_networkReconnect(endpoint: endpoint, params: params, completionHandler: completionHandler)
//                DispatchQueue.main.async {
//                    completionHandler(.failure(.noResponse))
//                }
                return
            }
            guard error == nil else {
//                DispatchQueue.main.async {
//                    completionHandler(.failure(.networkError(error: error!)))
//                }
                LVAPIService.shared.lv_networkReconnect(endpoint: endpoint, params: params, completionHandler: completionHandler)
                return
            }
            do {
                #if DEBUG
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("返回数据：", json)
                #endif
                let object = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    #if DEBUG
                    print("JSON Decoding Error: \(error)")
                    #endif
                    LVAPIService.shared.lv_networkReconnect(endpoint: endpoint, params: params, completionHandler: completionHandler)
//                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        task.resume()
    }
    
    mutating func lv_networkReconnect<T: Codable>(endpoint: Endpoint, params: [String: String]?, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        print("开始重新连接。。。time: \(lvReconnectTime)")
        lvReconnectTime += 1
        if lvReconnectTime < INT_MAX {
            let time: TimeInterval = 2.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                LVAPIService.shared.GET(endpoint: endpoint, params: params, completionHandler: completionHandler)
            }
        }else {
            lvReconnectTime = 0
        }
    }
    
    /// 请求 - 初始化
    func lv_sabrinaServiceInit(success: @escaping () -> Void ) {
        self.GET(endpoint: .lv_initSabrina, params: [:]) { (result: Result<LVInitModel, LVAPIService.APIError>) in
            switch result {
            case let .success(response):
                lvInitModel = response
                success()
            case let .failure(error):
                print(error)
            }
        }
    }
}
