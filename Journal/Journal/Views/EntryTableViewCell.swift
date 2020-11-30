//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jeff Kang on 11/29/20.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    let df = DateFormatter()

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodyTextLabel: UILabel!
    
    private func updateViews() {
        guard let entry = entry else { return }
        entryTitleLabel.text = entry.title
        df.dateFormat = "MM/dd/yy h:mm a"
        guard let date = entry.timestamp else { return }
        entryTimestampLabel.text = df.string(from: date)
        entryBodyTextLabel.text = entry.bodyText
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
