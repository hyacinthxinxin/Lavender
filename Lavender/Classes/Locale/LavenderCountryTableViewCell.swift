//
//  LavenderCountryTableViewCell.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//

import UIKit

class LavenderCountryTableViewCell: UITableViewCell {

    lazy var countryNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        $0.textColor = UIColor.black
        return $0
    }(UILabel(frame: CGRect.zero))

    lazy var countryPhoneCodeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.gray
        return $0
    }(UILabel(frame: CGRect.zero))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(countryPhoneCodeLabel)
        countryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        countryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        countryNameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: countryNameLabel.bottomAnchor, constant: 12).isActive = true
        countryPhoneCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        countryPhoneCodeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
