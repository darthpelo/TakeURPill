//
//  IntentHandler.swift
//  TakePillIntents
//
//  Created by Alessio Roberto on 16/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Intents

class IntentHandler: INExtension, TakePillIntentHandling {
    @available(iOSApplicationExtension 13.0, *)
    func resolveAmount(for intent: TakePillIntent, with completion: @escaping (TakePillAmountResolutionResult) -> Void) {
        if let amount = intent.amount?.intValue, amount > 0 {
            completion(.success(with: amount))
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveTitle(for intent: TakePillIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let name = intent.title {
            completion(.success(with: name))
        } else {
            completion(.needsValue())
        }
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

//    func confirm(intent: TakePillIntent, completion: @escaping (TakePillIntentResponse) -> Void) {
//        <#code#>
//    }

    func handle(intent: TakePillIntent, completion: @escaping (TakePillIntentResponse) -> Void) {
        if let pill = Pill(from: intent) {
            let storage = Storage()
            if storage.store(pill) {
                completion(TakePillIntentResponse.success(pillName: pill.name))
            } else {
                completion(TakePillIntentResponse(code: .failure, userActivity: nil))
            }
        } else {
            completion(TakePillIntentResponse(code: .failure, userActivity: nil))
        }
    }
    
    
}
