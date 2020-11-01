//
//  PDFViewController.swift
//  Attestation
//
//  Created by Maxime on 31/10/2020.
//

import UIKit
import PDFKit



class PDFViewController: UIViewController {

	@IBOutlet var pdfView: PDFView!
	
	var pdf_ : PDFDocument? = nil
	var filename: String? = nil
		
	var pdf: PDFDocument? {
		get {
			return pdf_
		}
		
		set {
			pdf_ = newValue
			if isViewLoaded {
				self.pdfView.document = newValue
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if self.pdf_ != nil {
			self.pdfView.document = self.pdf_
			self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit
		}
	}
	
	@IBAction func close(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func share(_ sender: Any) {
		if filename != nil {
			let documento = NSData(contentsOfFile: filename!)
			let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
			activityViewController.popoverPresentationController?.sourceView=self.view
			present(activityViewController, animated: true, completion: nil)
		}
	}
	
}
