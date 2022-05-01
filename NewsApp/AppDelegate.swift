//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Kristian Bredin on 2022-03-24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        readFavouritesFromDefaults()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    //    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    //        // Called when the user discards a scene session.
    //        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    //        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    //        writeFavouritesToDefaults()
    //    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("applicationDidReceiveMemoryWarning")
        
    }
    
    func readFavouritesFromDefaults() {
        print("readFavouritesFromDefaults")
        if let data = UserDefaults.standard.data(forKey: "favourites") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let favourites = try decoder.decode([Article].self, from: data)
                Favourites.shared.articles = favourites
                //                print("readFavouritesFromDefaults Favourites.shared.articles: \(Favourites.shared.articles)")
            } catch {
                print("Unable to Decode Favourites (\(error))")
            }
        }
    }
    
    
    
}

