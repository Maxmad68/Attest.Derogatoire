//
//  TabBarController.swift
//  Attestation
//
//  Created by Maxime on 06/11/2020.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if let vc = AppDelegate.main.generateViewController {
			vc.reloadDates()
		}
	}
}
