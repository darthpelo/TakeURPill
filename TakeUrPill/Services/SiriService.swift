//
//  SiriService.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 09/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Intents

struct SiriService {
    struct ActivityInformation {
        let activityType: String
        let activityTitle: String
        let activitySuggestedInvocation: String
    }

    static func donateInteraction(_ intent: INIntent, completion: ((Error?) -> Void)? = nil) {
        // Donate interaction to the system
        let interaction = INInteraction(intent: intent, response: nil)

        interaction.donate { error in
            completion?(error)
        }
    }

    static func activitySetup(_ information: ActivityInformation) -> NSUserActivity {
        // give our activity a unique ID
        let activity = NSUserActivity(activityType: information.activityType)

        // give it a title that will be displayed to users
        activity.title = information.activityTitle

        // allow Siri to index this and use it for voice-matched queries
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        }

        // give the activity a unique identifier so we can delete it later if we need to
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(information.activityType)
        }

        // You can also suggest the voice phrase that a user may want to use when adding a phrase to Siri
        activity.suggestedInvocationPhrase = information.activitySuggestedInvocation

        // make this activity active for the current view controller – this is what Siri will restore when the activity is triggered
        return activity
    }
}
