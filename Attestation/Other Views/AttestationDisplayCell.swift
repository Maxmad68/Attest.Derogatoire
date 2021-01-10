//
//  AttestationDisplayCell.swift
//  Attestation
//
//  Created by Maxime on 31/10/2020.
//

import UIKit

class AttestationDisplayCell: UITableViewCell {

	static let colors: [UIColor] = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]

	
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var motifBadge: UILabel!
	
	func setBadge(motifs: [Int]) {
		if UIDevice.current.Is4Inches() {
			self.motifBadge.text = ""
			self.motifBadge.backgroundColor = .clear
			return
		}
		
		self.motifBadge.layer.cornerRadius = 4
		self.motifBadge.layer.masksToBounds = true
		
		if motifs.count == 0 {
			self.motifBadge.text = ""
			self.motifBadge.backgroundColor = .clear
		} else if motifs.count == 1 {
			let descriptions = GenerateViewController.motifs
			
			self.motifBadge.text = descriptions[motifs[0]]
			self.motifBadge.backgroundColor = AttestationDisplayCell.colors[motifs[0]]
			
		} else {
			self.motifBadge.text = "\(motifs.count) motifs"
			self.motifBadge.backgroundColor = AttestationDisplayCell.colors[motifs[0]]
		}
	}
	
	
}
