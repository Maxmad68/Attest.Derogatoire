//
//  ViewController.swift
//  Attestation
//
//  Created by Maxime on 30/10/2020.
//

import UIKit
import Eureka

class GenerateViewController: FormViewController {

	static let motifs = ["Travail", "Achats", "Santé", "Famille", "Accompagnement", "Sport/Animaux", "Convocation", "Missions", "Enfants"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.main.generateViewController = self
		
		// Get date
		let date = Date()
		
		var hour = Calendar.current.component(.hour, from: date)
		var minute = Calendar.current.component(.minute, from: date)
		
		minute += 2
		if (minute >= 60) {
			minute = minute - 60
			hour += 1
		}
		
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
		
			<<< TextRow() {
				$0.title = "Nom"
				$0.value = GetDefaultValue("Last Name", "Macron") as? String
				$0.tag = "name"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}
			
			<<< TextRow() {
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
				$0.value = Calendar.current.date(from: DateComponents.init(calendar: Calendar.current,hour: hour, minute: minute))
				$0.tag = "hour"
				$0.add(rule: RuleRequired())
				$0.validationOptions = .validatesOnChange
			}

			
			

			<<< MultipleSelectorRow<String>() {
				$0.title = "Motif"
				$0.options = GenerateViewController.motifs
				$0.value = lastMotifsTitles
				$0.tag = "motifs"
				$0.selectorTitle = "Choisir un motif:"
			}
			.onPresent { from, to in
				
				
				to.selectableRowSetup = { row in
					row.cellProvider = CellProvider<ListCheckCell<String>>(nibName: "MotifCell", bundle: Bundle.main)
				}
				to.selectableRowCellUpdate = { cell, row in
					var detailText: String?
					switch row.selectableValue {
					case "Travail": detailText = "Déplacements entre le domicile et le lieu d’exercice de l’activité professionnelle ou un établissement d’enseignement ou de formation, déplacements professionnels ne pouvant être différés, déplacements pour un concours ou un examen"
					case "Achats": detailText = "Déplacements pour effectuer des achats de fournitures nécessaires à l'activité professionnelle, des achats de première nécessité dans des établissements dont les activités demeurent autorisées, le retrait de commande et les livraisons à domicile"
					case "Santé": detailText = "Consultations, examens et soins ne pouvant être assurés à distance et l’achat de médicaments"
					case "Famille": detailText = "Déplacements pour motif familial impérieux, pour l'assistance aux personnes vulnérables et précaires ou la garde d'enfants"
					case "Accompagnement": detailText = "Déplacement des personnes en situation de handicap et leur accompagnant"
					case "Sport/Animaux": detailText = "Déplacements brefs, dans la limite d'une heure quotidienne et dans un rayon maximal d'un kilomètre autour du domicile, liés soit à l'activité physique individuelle des personnes, à l'exclusion de toute pratique sportive collective et de toute proximité avec d'autres personnes, soit à la promenade avec les seules personnes regroupées dans un même domicile, soit aux besoins des animaux de compagnie"
					case "Convocation": detailText = "Convocation judiciaire ou administrative et pour se rendre dans un service public"
					case "Missions": detailText = "Participation à des missions d'intérêt général sur demande de l'autorité administrative"
					case "Enfants": detailText = "Déplacement pour chercher les enfants à l’école et à l’occasion de leurs activités périscolaires"
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
	}
	
	/// User tapped "Generate" button:
	/// Make the certificate PDF from entered values
	///
	func generate() {
		let values = form.values()
		print (values)
		
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


}
