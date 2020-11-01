//
//  PDF.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import UIKit
import PDFKit


/// Convert a CIImage to a CGImage
func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
	let context = CIContext(options: nil)
	if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
		return cgImage
	}
	return nil
}

/// Get value from defaults, but returns a default value if it doesn't exist.
///
///	Parameters:
///		- _ (String) : Key name
///		- _ (Any) : Default value
///
func GetDefaultValue(_ key: String, _ defaultValue: Any) -> Any {
	if let v = UserDefaults.standard.value(forKey: key) {
		return v
	}
	return defaultValue
}
