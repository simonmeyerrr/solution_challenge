import UIKit
import Flutter

import "GoogleMaps/GoogleMaps.h"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey:@"AIzaSyAh3Jvh2T5uBBSUxZHCPUMsjecPX9ys_lQ"];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
