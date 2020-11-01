//
//  AttestationDisplayCell.swift
//  Attestation
//
//  Created by Maxime on 31/10/2020.
//

import UIKit

class AttestationDisplayCell: UITableViewCell {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var motifBadge: UILabel!
	
	func setBadge(motif: Int?) {
		if UIDevice.current.Is4Inches() {
			self.motifBadge.text = ""
			self.motifBadge.backgroundColor = .clear
			return
		}
		
		if motif == nil {
			self.motifBadge.text = ""
			self.motifBadge.backgroundColor = .clear
		} else {
			let descriptions = GenerateViewController.motifs
			let colors: [UIColor] = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)]
			
			self.motifBadge.text = descriptions[motif!]
			self.motifBadge.backgroundColor = colors[motif!]
			self.motifBadge.layer.cornerRadius = 4
			self.motifBadge.layer.masksToBounds = true
		}
	}
	
	
}
