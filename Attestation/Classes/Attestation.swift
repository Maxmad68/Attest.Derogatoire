//
//  Attestation.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import Foundation
import PDFKit

enum FieldNames: String {
	case name = "Nom Prénom"
	case birthday = "Date de naissance"
	case birthplace = "Lieu de naissance"
	case address = "Adresse du domicile"
	case city = "Lieu d'établissement du justificatif"
	case date = "Date"
	case hour = "Heure"
	case sig = "Champ de signature"
}

class Attestation {
	
	var name: String? = ""
	var firstName: String? = ""
	var birthday: Date? = Date()
	var birthPlace: String? = ""
	
	var address: String? = ""
	var city: String? = ""
	var postCode: String? = ""
	
	var outDate: Date? = nil
	
	var motifs: [Int] = []
	
	init() {}
	
	func LoadPDF() -> PDFDocument {
		let pdfURL = Bundle.main.url(forResource: "template", withExtension: "pdf")
		let pdfDocument = PDFDocument(url: pdfURL!)
		return pdfDocument!
	}
	
	func generate() -> PDFDocument {
		// Format address text
		let addressText: String = "\(String(describing: address!)) \(String(describing:postCode!)) \(String(describing:city!))"
		
		// Format dates (out date & birthday date)
		let formatter = DateFormatter()
		
		formatter.dateFormat = "dd/MM/yyyy"
		let outDateString = formatter.string(from: outDate!)
		let bDate = formatter.string(from: birthday!)
		formatter.dateFormat = "HH'h'mm"
		let outHourString = formatter.string(from: outDate!)
		
		// Load template pdf
		let pdfDocument = LoadPDF()
		let page1 = pdfDocument.page(at: 0)

//		let annotations = page1!.annotations
//		for annotation in annotations{
//			print("Annotation Name :: \(annotation.fieldName ?? "")")
//
//			annotation.widgetStringValue = annotation.fieldName
//
//		}
//
//		return pdfDocument
//
//
		
		// Draw on PDF
		page1?.drawText("\(firstName ?? "") \(name ?? "")", x: 119, y: 665 - 9)
		page1?.drawText(bDate, x: 119, y: 645 - 9)
		page1?.drawText(birthPlace!, x: 312, y: 645 - 9)
		page1?.drawText(addressText, x: 133, y: 625 - 9)
		
		page1?.drawText(city!, x: 105, y: 286 - 8)
		page1?.drawText(outDateString, x: 91, y: 267 - 9)
		page1?.drawText(outHourString, x: 312, y: 267 - 9)
		
		// Tick motifs
		
		for motif in motifs {
			let yTicks = [540, 508, 474, 441, 418, 397, 363, 330]
			let chosenY = yTicks[motif]
			
			page1?.drawText("X", x: 73 - 4, y: chosenY - 8, size: 15)
		}
		
		
		// Create a second page for QR Code
		let page2 = PDFPage()
		
		if let qr = GenerateQR() {
			
			// Draw QR on second page
			let bounds = page2.bounds(for: PDFDisplayBox.mediaBox)
			let size = bounds.size
			
			let imageAnnotation = PDFImageAnnotation(qr, bounds:
														CGRect(x: 50,
															   y: size.height - 350,
															   width: 300,
															   height: 300
														), properties: nil)
			
			page2.addAnnotation(imageAnnotation)
			
			// Draw QR on first page, on botton-right corner
			let bounds1 = page1!.bounds(for: PDFDisplayBox.mediaBox)
			let size1 = bounds1.size
			
			let imageAnnotation2 = PDFImageAnnotation(qr, bounds:
														CGRect(x: size1.width - 156,
															   y: 125,
															   width: 92,
															   height: 92
														),properties: nil)
			page1!.addAnnotation(imageAnnotation2)
		}
		pdfDocument.insert(page2, at: 1)

		
		
		return pdfDocument
		
	}
	
	/// Generate a QR Code for this attestation
	///
	func GenerateQR() -> CIImage? {
		// Format address text
		let addressText: String = "\(String(describing: address!)) \(String(describing:postCode!)) \(String(describing:city!))"
		
		// Format dates
		let formatter = DateFormatter()
		
		formatter.dateFormat = "dd/MM/yyyy"
		let outDateString = formatter.string(from: outDate!)
		let bDate = formatter.string(from: birthday!)
		formatter.dateFormat = "HH'h'mm"
		let outHourString = formatter.string(from: outDate!)
		formatter.dateFormat = "HH':'mm"
		let outHourString2 = formatter.string(from: outDate!)
		
		// Get motifs string
		var motifsStrings: [String] = []
		for motif in self.motifs {
			motifsStrings.append(["travail","sante","famille","handicap","convocation","missions", "transits", "animaux"][motif])
		}
		let motifsString = motifsStrings.joined(separator: ", ")
		
		// Get whole string
		let string = "Cree le: \(outDateString) a \(outHourString);\n Nom: \(name ?? "Unknown");\n Prenom: \(firstName ?? "Unknown");\n Naissance: \(bDate) a \(birthPlace ?? "Unknown");\n Adresse: \(addressText);\n Sortie: \(outDateString) a \(outHourString2);\n Motifs: \(motifsString)"

		print (string)
		
		// Draw QR Code
		let data = string.data(using: String.Encoding.utf8)
		
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(data, forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 5, y: 5) // Make the QR bigger
			
			if let output = filter.outputImage?.transformed(by: transform) {
				return output
			}
		}
		
		return nil
		
	}
	
	/// Write the attestation to defaults
	///
	/// Parameters:
	///		- filename (String) : Filename of the PDF file
	///
	func WriteToDefaults(filename: String) {
		let dict: [String: Any?] = ["firstname": firstName, "name": name, "date": outDate, "motifs": motifs , "pdfName": filename]
		
		var certDefaults = UserDefaults.standard.array(forKey: "Certificates")
		certDefaults?.insert(dict, at: 0)
		UserDefaults.standard.set(certDefaults, forKey: "Certificates")
	}
}
