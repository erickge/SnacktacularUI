//
//  SnacktacularUIApp.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/19/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SnacktacularUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // Add location manager
    @State var locationManager = LocationManager()
    @State var selectedPlace: Place?
    
//    @StateObject var spotVM = SpotViewModel()
//    @StateObject var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            LoginView()
                //.environmentObject(locationManager)
        }
    }
}
