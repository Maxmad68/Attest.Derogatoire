//
//  ListTableViewController.swift
//  Attestation
//
//  Created by Maxime on 31/10/2020.
//

import UIKit
import PDFKit

struct DisplayAttestation {
	var firstname: String!
	var name: String!
	var date: Date!
	var motifs: [Int]!
	var pdfName: String!
}

class ListTableViewController: UITableViewController {
	
	var list: [DisplayAttestation] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.main.listTableViewController = self
		
		loadAttestations()
	}
	
	/// Load list of saved attestations, in defaults
	///
	func loadAttestations() {
		self.list = []
		let certDefaults = UserDefaults.standard.array(forKey: "Certificates") as! [[String: Any?]]
		
		for cert in certDefaults {
			let firstName = cert["firstname"] as! String
			let name = cert["name"] as! String
			let date = cert["date"] as! Date
			
			var motifs: [Int] = []
			if cert["motif"] != nil {
				let motif = cert["motif"] as! Int
				if motif != -1 {
					motifs.append(motif)
				}
			}
			
			if cert["motifs"] != nil {
				motifs = cert["motifs"] as! [Int]
			}
			
			let pdfName = cert["pdfName"] as! String
			let display = DisplayAttestation(firstname: firstName, name: name, date: date, motifs: motifs, pdfName: pdfName)
			self.list.append(display)
		}
		
		self.tableView.reloadData()
	}
	

	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return nil
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.list.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let data = self.list[indexPath.row]
			
			// Delete defaults entry
			var certDefaults = UserDefaults.standard.array(forKey: "Certificates") as! [[String: Any?]]
			certDefaults.remove(at: indexPath.row)
			UserDefaults.standard.set(certDefaults, forKey: "Certificates")
			
			// Delete pdf
			let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
			let documentsDirectory = documents.first
			var docURL = URL(string: documentsDirectory!)!
			docURL.appendPathComponent(data.pdfName)
			
			do {
				print (docURL.absoluteURL)
				try FileManager.default.removeItem(atPath: docURL.absoluteString)
			} catch {
				print ("Err")
			}
			
			// Delete from list
			self.list.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = list[indexPath.row]
		
		// Format dates
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		let outDateString = formatter.string(from: data.date)
		formatter.dateFormat = "HH'h'mm"
		let outHourString = formatter.string(from: data.date)
		
		// Init cell
		let cell = tableView.dequeueReusableCell(withIdentifier: "attestationCell", for: indexPath) as! AttestationDisplayCell
		
		// Present
		cell.setBadge(motifs: data.motifs)
		cell.nameLabel?.text = "\(data.firstname ?? "") \(data.name ?? "")"
		cell.dateLabel?.text = "\(outDateString) à \(outHourString)"
		
		cell.accessoryType = .disclosureIndicator // Small triangle
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = list[indexPath.row]
		
		// Find PDF
		let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentsDirectory = documents.first
		var docURL = URL(string: documentsDirectory!)!
		docURL.appendPathComponent(data.pdfName)
		
		// Open PDF
		let pdf = PDFDocument(url: URL(fileURLWithPath: docURL.absoluteString))
		let pdfVc = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
		let navVC = UINavigationController(rootViewController: pdfVc)
		self.present(navVC, animated: true, completion: nil)
		pdfVc.pdf = pdf
		pdfVc.filename = docURL.absoluteString
	}
	
	@IBAction func removeAll(_ sender: Any) {
		let alert = UIAlertController(title: "Tout effacer?", message: "Ça va être tout blanc", preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { action in
			
			var idx = 0
			for data in self.list {
				// Delete pdf
				let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
				let documentsDirectory = documents.first
				var docURL = URL(string: documentsDirectory!)!
				docURL.appendPathComponent(data.pdfName)
				
				do {
					print (docURL.absoluteURL)
					try FileManager.default.removeItem(atPath: docURL.absoluteString)
				} catch {
					print ("Err")
				}
				
				idx += 1
			}
			
			// Clean defaults entry
			UserDefaults.standard.set([], forKey: "Certificates")
			
			self.list = []
			
			self.tableView.reloadData()
			
		}))
		alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
		
		self.present(alert, animated: true)
	}
	
}
