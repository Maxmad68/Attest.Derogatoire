//
//  AppDelegate.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


	var generateViewController: GenerateViewController? = nil
	var listTableViewController: ListTableViewController? = nil
	
	var preloadProperties = [String: Any]()
	

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Create "Certificates" defaults if doesn't exist
		if UserDefaults.standard.object(forKey: "Certificates") == nil {
			UserDefaults.standard.set([], forKey: "Certificates")
		}
		
		// Update "Last Motif" to multiple selection
		if let lm = UserDefaults.standard.object(forKey: "Last Motif") {
			UserDefaults.standard.set([lm], forKey: "Last Motifs")
			UserDefaults.standard.removeObject(forKey: "Last Motif")
		}
		
		// Create documents directory if doesn't exist
		let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		print (documents.first!)
		let documentsDirectory = documents.first
		let docURL = URL(string: documentsDirectory!)!
		
		if !FileManager.default.fileExists(atPath: docURL.absoluteString) {
			do {
				try FileManager.default.createDirectory(atPath: docURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error.localizedDescription);
			}
		}
		
		return true
	}
	
		
	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}



}

extension AppDelegate {
	static var main: AppDelegate {
		get {
			return UIApplication.shared.delegate as! AppDelegate
		}
	}
}
