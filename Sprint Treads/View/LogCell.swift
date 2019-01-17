//
//  LogCellTableViewCell.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 17/01/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureRun(run: Run){
        durationLabel.text = run.duration.formatTimeDurationToString()
        distanceLabel.text = "\(run.distance.metresToMiles(places: 2)) mi"
        paceLabel.text = run.pace.formatTimeDurationToString()
        dateLabel.text = run.date.getDateString()
        
    }
}
