//
//  SettingsCell.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/6/24.
//

import UIKit

enum SettingsCellType {
    case toggle(String, UIImage)
    case disclosure(String, UIImage)
    case action(String, UIImage)
    
    var title: String {
        switch self {
        case .toggle(let title, _), .disclosure(let title, _), .action(let title, _):
            return title
        }
    }
    
    var icon: UIImage {
        switch self {
        case .toggle(_, let icon), .disclosure(_, let icon), .action(_, let icon):
            return icon
        }
    }
}

class SettingsCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.textBlack
        label.sizeToFit()
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        view.layer.masksToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyStyle()
        constructHierarchy()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyle() {
        selectionStyle = .none
    }

    private func constructHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12)
        ])
    }

    func configureCorners(for row: Int, in rowCount: Int) {
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = []
        
        if rowCount == 1 {
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if row == 0 {
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if row == rowCount - 1 {
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func configure(for type: SettingsCellType, for row: Int, in rowCount: Int) {
        configureCorners(for: row, in: rowCount)
        
        titleLabel.text = type.title
        iconImageView.image = type.icon
        
        // Remove previous accessory views
        containerView.subviews.forEach { if $0 !== iconImageView && $0 !== titleLabel { $0.removeFromSuperview() } }

        switch type {
        case .toggle:
            let switchControl = UISwitch()
            
            containerView.addSubview(switchControl)
            
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                switchControl.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16),
                switchControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
        case .disclosure:
            let accessoryLabel = UILabel()
            accessoryLabel.text = "Medium (5x5)"
            accessoryLabel.font = UIFont.systemFont(ofSize: 14)
            accessoryLabel.textColor = Color.primaryPurple
            
            containerView.addSubview(accessoryLabel)
            
            accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                accessoryLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16),
                accessoryLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
        case .action:
            break
        }
    }
}
