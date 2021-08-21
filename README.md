# FunLittleAdsSDK

The FunLittleAds SDK allows you to insert ads into your iOS and macOS applications. Visit https://funlittleads.com to create an account and get started!

This Swift Package includes demo projects for iOS, macOS using AppKit, and SwiftUI targets for both iOS and macOS. 

The steps that you should follow include:

1. Create an account on https://funlittleads.com
2. In the Developer section, create a new Application. Fill out the details, and you should end up with an SDK token. 
3. Install this package in your Xcode project.

Your integration depends on the way platform you're building with. For example, for an iOS app built with UIKit:

1. In your view controller, create a property of type `AdUnitController`, providing the SDK token you got from the website:

```var funLittleController = AdUnitController(adId: "8c9a5649-64d8-40fa-8c38-8231e759502a")```

2. Create a _container view_ in which the ads will appear. You can do this in a Storyboard, or create it in code (the demo app names it `funLittleAdView`).
3. In your view controller's `viewDidLoad()` method, embed the ad into this view!

```funLittleController.embedAdUnit(for: funLittleAdView)```

That's it! 

### Help or Feedback?
Hit me up via email: aaron@innoveghtive.com.
