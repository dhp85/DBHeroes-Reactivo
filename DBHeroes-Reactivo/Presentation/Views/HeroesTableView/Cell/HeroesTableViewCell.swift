//
//  HeroesTableTableViewCell.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    
    @IBOutlet weak var nameHero: UILabel!
    
    @IBOutlet weak var descriptionHero: UILabel!
    
    @IBOutlet weak var nextView: UILabel!
    
    
    static var identifier: String {
        String(describing: HeroesTableViewCell.self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
