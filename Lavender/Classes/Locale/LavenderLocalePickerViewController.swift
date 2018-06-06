//
//  LavenderLocalePickerViewController.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//

import UIKit

public class LavenderLocalePickerViewController: UIViewController {

    fileprivate var orderedInfo = [String: [LavenderLocaleInfo]]()
    fileprivate var sortedInfoKeys = [String]()
    fileprivate var allInfo: [LavenderLocaleInfo] = []
    fileprivate var filteredInfo: [LavenderLocaleInfo] = []
    fileprivate var selectedInfo: LavenderLocaleInfo?

    lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.lightGray
        $0.separatorStyle = .singleLine
        $0.rowHeight = UITableViewAutomaticDimension
        $0.estimatedRowHeight = 44
        $0.dataSource = self
        $0.delegate = self
        $0.tableFooterView = UIView()
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))

    let searchController = UISearchController(searchResultsController: nil)

    override public func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareSearchController()
        updateInfo()
    }

    fileprivate func prepareTableView() {
        tableView.register(LavenderCountryTableViewCell.self, forCellReuseIdentifier: LavenderCountryTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
    }


    fileprivate func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "搜索"
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func updateInfo() {
        LavenderLocaleStore.fetch { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(infos, groupedInfos):
                self.allInfo = infos
                self.orderedInfo = groupedInfos
                self.sortedInfoKeys = Array(self.orderedInfo.keys).sorted(by: < )
                DispatchQueue.main.async {
//                    self.indicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            case let .error(error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in

                    }))
//                        self.indicatorView.stopAnimating()
//                        self.alertController?.dismiss(animated: true)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func info(at indexPath: IndexPath) -> LavenderLocaleInfo? {
        if isFiltering() {
            return filteredInfo[indexPath.row]
        }
        let key: String = sortedInfoKeys[indexPath.section]
        if let info = orderedInfo[key]?[indexPath.row] {
            return info
        }
        return nil
    }

}

extension LavenderLocalePickerViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return 1
        }
        return sortedInfoKeys.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredInfo.count
        }
        if let infoForSection =  orderedInfo[sortedInfoKeys[section]] {
            return infoForSection.count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let info = info(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: LavenderCountryTableViewCell.reuseIdentifier, for: indexPath) as! LavenderCountryTableViewCell
        if LVU.isSystemChineseHans() {
            cell.countryNameLabel.text = info.chinaName
        } else {
            cell.countryNameLabel.text = info.isni
        }
        cell.countryPhoneCodeLabel.text = info.internaCode
        return cell
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedInfoKeys
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sortedInfoKeys.index(of: title) ?? 0
    }

}

extension LavenderLocalePickerViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedInfoKeys[section]
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = info(at: indexPath) else { return }
        LVU.logging(info)
    }

}

extension LavenderLocalePickerViewController: UISearchResultsUpdating {

    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filteredInfo = allInfo.filter { $0.isni.contains(searchText) }
        tableView.reloadData()
    }

}
