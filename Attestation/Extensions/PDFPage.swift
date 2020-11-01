//
//  PDFPage.swift
//  Attestation
//
//  Created by Maxime on 01/11/2020.
//

import UIKit
import PDFKit

extension PDFPage {
	
	/// Draw text on a PDF Page
	///
	/// Parameters:
	///		- _ (String) : Text to draw
	///		- x (Int) : X coord
	///		- y (Int) : Y coord
	///		- size (Int) : Font size (def = 11)
	///
	func drawText(_ string: String, x: Int, y: Int, size: CGFloat = 11) {
		let annotation = PDFAnnotation(bounds: CGRect(x: x, y: y, width: 250, height: 20), forType: .freeText, withProperties: nil)
		annotation.contents = string
		annotation.font = UIFont(name: "Helvetica", size: size)
		annotation.fontColor = .black
		annotation.color = .clear
		self.addAnnotation(annotation)
	}
}
