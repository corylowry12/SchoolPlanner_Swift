//
//  GradesTableViewCell.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit

class GradesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
