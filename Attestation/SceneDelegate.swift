//
//  SceneDelegate.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		
		let components = NSURLComponents(url: URLContexts.first!.url, resolvingAgainstBaseURL: true)
		let action = components?.host
		
		for item in components!.queryItems! {
			AppDelegate.main.preloadProperties[item.name] = item.value
		}
		
		AppDelegate.main.preloadProperties["preGenerate"] = action == "generate"
		
		if let vc = AppDelegate.main.generateViewController {
			vc.preload()
		}
	}
	
	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		
		// Determine who sent the URL.
		if let urlContext = connectionOptions.urlContexts.first {
			
			let components = NSURLComponents(url: urlContext.url, resolvingAgainstBaseURL: true)
			let action = components?.host
			
			for item in components!.queryItems! {
				AppDelegate.main.preloadProperties[item.name] = item.value
			}
			
			AppDelegate.main.preloadProperties["preGenerate"] = action == "generate"
			
			if let vc = AppDelegate.main.generateViewController {
				vc.preload()
			}
			
			// Process the URL similarly to the UIApplicationDelegate example.
		}
		
		/*
		*
		*/
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
		if let generateVC = AppDelegate.main.generateViewController {
			generateVC.reloadDates()
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}


}

