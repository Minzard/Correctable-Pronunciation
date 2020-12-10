//
//  PronunciationRequest.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import Foundation
import Alamofire

class PronunciationRequest{
    static let sharedInstance: PronunciationRequest = {
        let instance = PronunciationRequest()
        return instance
    }()
    func request(_ url: URLConvertible,
                 method: HTTPMethod = .post,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil, completeHandler: @escaping (_ data: Data?, _ error: Error?) -> ()) -> () {
        Alamofire.request(url, method: method, parameters: parameters).responseData { (responseData) in
            if responseData.error == nil {
                completeHandler(responseData.data, nil)
            } else {
                completeHandler(nil, responseData.error)
            }
        }
    }
}
