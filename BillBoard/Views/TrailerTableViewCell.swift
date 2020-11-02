//
//  TrailerTableViewCell.swift
//  BillBoard
//
//  Created by Héctor Cuevas Morfín on 02/11/20.
//

import UIKit

class TrailerTableViewCell: UITableViewCell {

	@IBOutlet weak var trailerLabel: UILabel!
	
	var trailer:Video? {
		didSet {
			setupCell()
		}
	}
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	func setupCell() {
		guard let trailer = self.trailer else {return}
		self.trailerLabel.text = trailer.name
	}
}
