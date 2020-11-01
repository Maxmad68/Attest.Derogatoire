//
//  UIDevice.swift
//  Attestation
//
//  Created by Maxime on 01/11/2020.
//

import UIKit

extension UIDevice {
	func Is4Inches() -> Bool {
		#if os(macOS) || targetEnvironment(macCatalyst)
		return false
		#else
		return UIScreen.main.nativeBounds.height < 1200
		#endif
	}
}
