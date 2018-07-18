//
//  IntentHandler.swift
//  TakePillIntents
//
//  Created by Alessio Roberto on 16/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Intents

class IntentHandler: INExtension, TakePillIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

    func handle(intent: TakePillIntent, completion: @escaping (TakePillIntentResponse) -> Void) {
        if let pill = Pill(from: intent) {
            let storage = Storage()
            if storage.store(pill) {
                completion(TakePillIntentResponse(code: .success, userActivity: nil))
            } else {
                completion(TakePillIntentResponse(code: .failure, userActivity: nil))
            }
        } else {
            completion(TakePillIntentResponse(code: .failure, userActivity: nil))
        }
    }
}
