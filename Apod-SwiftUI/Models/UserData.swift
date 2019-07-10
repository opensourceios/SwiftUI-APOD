//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: BindableObject, Subscriber {
    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        serverData = input
        if serverData.count == 0 {
            return .max(1)
        }else {
            return .none            
        }
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        
    }
    
    typealias Input = [ApodResult]
    
    typealias Failure = URLSession.DataTaskPublisher.Failure
    
    let didChange = PassthroughSubject<UserData, Never>()
    
    func requestApod() {
        var requestObj = ApodRequest(api_key: apiKey)
        requestObj.hd = true
        requestObj.count = 10
        
        requestObj.makeRequest(subscriber: self)
    }
    
    var apiKey: String = "DEMO_KEY" {
        didSet {
            didChange.send(self)
        }
    }
    
    var loadHdImage: Bool = true {
        didSet {
            didChange.send(self)
        }
    }
    
    var serverData: [ApodResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
}
