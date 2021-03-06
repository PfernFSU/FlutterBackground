//
//  AppDelegate.swift
//  FlutterBackground
//
//  Created by Justin Pfenning on 1/25/22.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var flutterEngine: FlutterEngine?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = UIViewController()
        
        let rootNC = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        //we put this in a delay to really see the memory jump
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.flutterEngine = FlutterEngine(name: "my flutter engine")
            self.flutterEngine!.run()
            GeneratedPluginRegistrant.register(with: self.flutterEngine!);
            
            let flutterViewController = FlutterViewController(engine: self.flutterEngine!, nibName: nil, bundle: nil)
            
            self.window?.rootViewController = flutterViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("entering foreground")
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "my flutter engine")
            flutterEngine!.run()
        }

        let flutterViewController = FlutterViewController(engine: self.flutterEngine!, nibName: nil, bundle: nil)
        
        window?.rootViewController = flutterViewController
        window?.makeKeyAndVisible()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("entering background")
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        DispatchQueue.main.async {
            // running async to avoid crash; I guess we need to wait for the window to re-draw
            if let engine = self.flutterEngine {
                debugPrint("destroying engine")
                engine.viewController = nil
                engine.destroyContext()
                self.flutterEngine = nil
            }
        }
    }


}

