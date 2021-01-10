//
//  ViewController.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import UIKit
import Eureka

class GenerateViewController: FormViewController {

	static let motifs = ["Travail", "Santé", "Famille", "Accompagnement", "Convocation", "Missions", "Transport", "Animaux"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.main.generateViewController = self
		
		// Get last motifs
		var lastMotifsTitles: Set<String>
		if let lastMotifs = UserDefaults.standard.object(forKey: "Last Motifs") {
			let lastMotifsArray = lastMotifs as! [Int]
			lastMotifsTitles = Set(lastMotifsArray.map{GenerateViewController.motifs[$0]})
		} else {
			lastMotifsTitles = [GenerateViewController.motifs[5]]
		}
		
		// Render form
		
		form +++ Section("Identité")
		
			<<< NameRow() {
				$0.title = "Nom"
				$0.value = GetDefaultValue("Last Name", "Macron") as? String
				$0.tag = "name"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< NameRow() {
				$0.title = "Prénom"
				$0.value = GetDefaultValue("Last Firstname", "Emmanuel") as? String
				$0.tag = "firstname"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< DateInlineRow() {
				$0.title = "Date de naissance"
				$0.value = GetDefaultValue("Last Birthday",
										   Calendar.current.date(from: DateComponents.init(calendar: .current, year: 1977, month: 12, day: 21))) as? Date
				$0.tag = "birthday"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< TextRow() {
				$0.title = "Ville de naissance"
				$0.value = GetDefaultValue("Last Birth Place", "Amiens") as? String
				$0.tag = "birthplace"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			
			+++ Section("Adresse")
			
			<<< TextRow() {
				$0.title = "Adresse"
				$0.value = GetDefaultValue("Last Address", "55 rue du Faubourg St-Honoré") as? String
				$0.tag = "address"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< ZipCodeRow() {
				$0.title = "Code Postal"
				$0.value = GetDefaultValue("Last CP", "75008") as? String
				$0.tag = "cp"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< TextRow() {
				$0.title = "Ville"
				$0.value = GetDefaultValue("Last City", "Paris") as? String
				$0.tag = "city"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			+++ Section("Sortie")
			
			<<< DateInlineRow() {
				$0.title = "Date de sortie"
				$0.value = Date()
				$0.tag = "date"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< TimeInlineRow(){
				$0.title = "Heure de sortie"
				$0.value = Date()
				$0.tag = "hour"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}

			
			

			<<< MultipleSelectorRow<String>() {
				$0.title = "Motifs"
				$0.options = GenerateViewController.motifs
				$0.value = lastMotifsTitles
				$0.tag = "motifs"
				$0.selectorTitle = "Choisir un/des motif:"
			}
			.onPresent { from, to in
				
				
				to.selectableRowSetup = { row in
					row.cellProvider = CellProvider<ListCheckCell<String>>(nibName: "MotifCell", bundle: Bundle.main)
				}
				to.selectableRowCellUpdate = { cell, row in
					var detailText: String?
					switch row.selectableValue {
						
					case "Travail": detailText = "Déplacements entre le domicile et le lieu d'exercice de l'activité professionnelle ou le lieu d'enseignement et de formation, déplacements professionnels ne pouvant être différés"
						
					case "Santé": detailText = "Déplacements pour des consultations et soins ne pouvant être assurés à distance et ne pouvant être différés ou pour l'achat de produits de santé"
						
					case "Famille": detailText = "Déplacements pour motif familial impérieux, pour l'assistance aux personnes vulnérables ou précaires ou pour la garde d'enfants"
						
					case "Accompagnement": detailText = "Déplacements des personnes en situation de handicap et de leur accompagnant"
						
					case "Convocation": detailText = "Déplacements pour répondre à une convocation judiciaire ou administrative"
						
					case "Missions": detailText = "Déplacements pour participer à des missions d'intérêt général sur demande de l'autorité administrative"
						
					case "Transport": detailText = "Déplacements liés à des transits ferroviaires, aériens ou en bus pour des déplacements de longues distances"
						
					case "Animaux": detailText = "Déplacements brefs, dans un rayon maximal d'un kilomètre autour du domicile pour les besoins des animaux de compagnie"
						
					default: detailText = ""
					}
					(cell as! MotifCell).detailTextLabel!.text = detailText
				}
			}
				
			
				
			+++ Section()
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Générer"
			}.onCellSelection { [weak self] (cell, row) in
				self?.generate()
			}
		
		self.preload()
	}
	
	
	func reloadDates() {
		
		if let cell = self.form.rowBy(tag: "hour") as? TimeInlineRow {
			cell.value = Date()
			cell.reload()
		}
	}
	
	/// User tapped "Generate" button:
	/// Make the certificate PDF from entered values
	///
	func generate() {
		let values = form.values()
		//print (values)
		
		// Make Attestation instance
		let attestation = Attestation()
		attestation.firstName = values["firstname"] as? String ?? ""
		attestation.name = values["name"] as? String ?? ""
		attestation.birthday = values["birthday"] as? Date
		attestation.birthPlace = values["birthplace"] as? String ?? ""
		attestation.city = values["city"] as? String ?? ""
		attestation.address = values["address"] as? String ?? ""
		attestation.postCode = values["cp"] as? String ?? ""
		
		let motifs = values["motifs"]
		
		attestation.motifs = []
		for motif in Array(motifs as! Set<String>) {
			attestation.motifs.append(
				GenerateViewController.motifs.firstIndex(of: motif)!
			)
		}
		
		
		let outTime = values["hour"] as! Date
		let hour = Calendar.current.component(.hour, from: outTime)
		let min = Calendar.current.component(.minute, from: outTime)
		
		
		
		let outDateRaw = values["date"] as! Date
		attestation.outDate = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: outDateRaw)!
		
		let timeSince = Date().timeIntervalSince(attestation.outDate!)
		
		if timeSince > 119 { // More than 1 min: show alert
			let alert = UIAlertController(title: "Date dépassée", message: "La date/heure de sortie indiquée est dépassée de plus de 1 minute.", preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Continuer", style: .default, handler:  { action in
				self.ContinueGenerating(attestation: attestation)
			}))
			alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
			
			self.present(alert, animated: true)
		} else {
			self.ContinueGenerating(attestation: attestation)
		}
		
	}
	
	
	func ContinueGenerating(attestation: Attestation) {
		let doc = attestation.generate()
		
		
		// Save PDF
		let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		
		let documentsDirectory = documents.first
		var docURL = URL(string: documentsDirectory!)!
		let filename = "\(Date().timeIntervalSince1970).pdf"
		docURL.appendPathComponent(filename)
		print (docURL.absoluteString)
		
		doc.write(toFile: docURL.absoluteString)
		
		attestation.WriteToDefaults(filename: filename)
		
		
		// Present PDF
		let pdfVc = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
		let navVC = UINavigationController(rootViewController: pdfVc)
		self.present(navVC, animated: true, completion: nil)
		pdfVc.pdf = doc
		pdfVc.filename = docURL.absoluteString
		
		// Reload list if needed
		if let listVC = AppDelegate.main.listTableViewController {
			listVC.loadAttestations()
		}
		
		// Update infos in defaults
		UserDefaults.standard.set(attestation.firstName, forKey: "Last Firstname")
		UserDefaults.standard.set(attestation.name, forKey: "Last Name")
		UserDefaults.standard.set(attestation.address, forKey: "Last Address")
		UserDefaults.standard.set(attestation.postCode, forKey: "Last CP")
		UserDefaults.standard.set(attestation.city, forKey: "Last City")
		UserDefaults.standard.set(attestation.birthday, forKey: "Last Birthday")
		UserDefaults.standard.set(attestation.birthPlace, forKey: "Last Birth Place")
		UserDefaults.standard.set(attestation.motifs, forKey: "Last Motifs")
		UserDefaults.standard.synchronize()
	}
	
	
	// Open from URL
	func preload() {
		
		let preloadProperties = AppDelegate.main.preloadProperties
		
		
		if let address = preloadProperties["address"] {
			if let cell = self.form.rowBy(tag: "address") as? TextRow {
				cell.value = (address as! String)
				cell.reload()
			}
		}
		
		if let cp = preloadProperties["cp"] {
			if let cell = self.form.rowBy(tag: "cp") as? ZipCodeRow {
				cell.value = (cp as! String)
				cell.reload()
			}
		}
		
		if let city = preloadProperties["city"] {
			if let cell = self.form.rowBy(tag: "city") as? TextRow {
				cell.value = (city as! String)
				cell.reload()
			}
		}
		
		if let firstname = preloadProperties["firstname"] {
			if let cell = self.form.rowBy(tag: "firstname") as? NameRow {
				cell.value = (firstname as! String)
				cell.reload()
			}
		}
		
		if let name = preloadProperties["name"] {
			if let cell = self.form.rowBy(tag: "name") as? NameRow {
				cell.value = (name as! String)
				cell.reload()
			}
		}
		
		if let birthday = preloadProperties["birthday"] {
			if let cell = self.form.rowBy(tag: "birthday") as? DateInlineRow {

				let dateFormatter = DateFormatter()
				dateFormatter.locale = Locale(identifier: "fr_FR")
				dateFormatter.dateFormat = "yyyy-MM-dd"
				let date = dateFormatter.date(from:birthday as! String)!
				
				cell.value = date
				cell.reload()
			}
		}
		
		if let birthplace = preloadProperties["birthplace"] {
			if let cell = self.form.rowBy(tag: "birthplace") as? TextRow {
				cell.value = (birthplace as! String)
				cell.reload()
			}
		}
		
		if let motifsRaw = preloadProperties["motifs"] {
			
			var motifs = Int(motifsRaw as! String)!

			
			var motifsList = [String]()
			var bitIdx = 0
			while motifs > 0 {
				let bit = motifs % 2
				motifs >>= 1
				if bit == 1 {
					motifsList.append(GenerateViewController.motifs[bitIdx])
				}
				bitIdx += 1
			}
			
			if let cell = self.form.rowBy(tag: "motifs") as? MultipleSelectorRow<String> {
				cell.value = Set(motifsList)
				cell.reload()
			}
		}
		
		if preloadProperties["preGenerate", default: false] as! Bool {
			generate()
		}
		
	}


}
