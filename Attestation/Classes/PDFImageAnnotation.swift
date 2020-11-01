//
//  PDFImageAnnotation.swift
//  Attestation
//
//  Created by Maxime on 31/10/2020.
//

import UIKit
import PDFKit

class PDFImageAnnotation: PDFAnnotation {
	
	var image: CIImage?
	
	convenience init(_ image: CIImage?, bounds: CGRect, properties: [AnyHashable : Any]?) {
		self.init(bounds: bounds, forType: PDFAnnotationSubtype.square, withProperties: properties)
		self.image = image
	}
	
	override func draw(with box: PDFDisplayBox, in context: CGContext) {
		super.draw(with: box, in: context)
		
		// Drawing the image within the annotation's bounds.
		
		guard let cgImage = convertCIImageToCGImage(inputImage: image!) else { return }
		
		context.draw(cgImage, in: bounds)
	}
}
