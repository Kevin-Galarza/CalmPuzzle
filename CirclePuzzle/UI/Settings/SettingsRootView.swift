//
//  SettingsRootView.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/22/24.
//

import UIKit
import Combine

class SettingsRootView: NiblessView {
    
    private let header: UIView = {
        let view = UIView()
        view.backgroundColor = Color.primaryPurple
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button"), for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.separatorInset = .zero
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    let viewModel: SettingsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        applyStyle()
        constructHierarchy()
        applyConstraints()
    }
    
    @objc private func handleBackButtonTap() {
        viewModel.dismiss()
    }
    
    private func applyStyle() {
        backgroundColor = .white
    }
    
    private func constructHierarchy() {
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        addSubview(header)
        addSubview(backButton)
        addSubview(tableView)  // Add the tableView to the view

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingCell")
    }

    private func applyConstraints() {
        header.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            header.widthAnchor.constraint(equalTo: widthAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),
            header.topAnchor.constraint(equalTo: topAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)  // Ensure tableView fills the space below the header
        ])
    }
}

extension SettingsRootView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1, 2:
            return 1
        case 3:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        let rowCount = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        let cellType = section.cellConfigurations[indexPath.row]
        cell.configure(for: cellType, for: indexPath.row, in: rowCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        if section == .difficulty {
            viewModel.handleDifficultySelectPresentation()
        }
    }
}
