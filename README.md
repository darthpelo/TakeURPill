# TakeURPill

This project shows how integrate **Siri Shortcuts** functionalities into a project. 

It's a simple _pill track_ application, that a user can use to log every time he/she took a pill.

## Siri Shortcuts
We showing to implementation of Siri Shortcuts
- NSUserActivity
- INIntent

The first one is used when a user visualizes a ViewController:

In `HistoryViewController.swift` when `viewDidAppear` is called

```swift
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let information = presenter?.information {
            activitySetup(information)
        }
    }_
```

The second one when a user makes an action:

In `StorageService.swift` when the application stores the pill took into the memory

```swift
    func store(_ pill: Pill) -> Bool {

        SiriService.donateInteraction(pill.intent) { error in
            if let error = error {
                logger(error)
            }
        }_
```

## Apple Reference
This project shows only how to implement, there is nothing more than what explained by Apple in this two WWDC sessions:

* [Introduction to Siri Shortcuts](https://developer.apple.com/videos/play/wwdc2018/211/)
* [Building for Voice with Siri Shortcuts](https://developer.apple.com/videos/play/wwdc2018/214/)