//
//  Expo1900 - MainViewController.swift
//  Created by Doogie, Red.
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var visitorsLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var listViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayExpoInfo()
        changeButtonLayoutSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    //MARK: -IBAction
    @IBAction private func moveToListViewButton(_ sender: UIButton) {
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: ListViewController.identifier) as? ListViewController else { return }
        
        navigationController?.pushViewController(listVC, animated: true)
    }
    //MARK: -functions
    private func changeButtonLayoutSetting() {
        listViewButton.titleLabel?.adjustsFontForContentSizeCategory = true
        listViewButton.titleLabel?.numberOfLines = 0
        listViewButton.titleLabel?.maximumContentSizeCategory = .accessibilityExtraLarge
        listViewButton.titleLabel?.textAlignment = .center
    }
    
    private func displayExpoInfo() {
        do {
            let expoInfo = try Exposition.getInfo()
            titleLabel.text = divide(title: expoInfo.title)
            posterImageView.image = UIImage(named: "poster.png")
            visitorsLabel.text = "방문객 : \(ExpoNumberFormatter.changeVisitorsFormat(from: expoInfo.visitors) ?? "정보 없음")"
            locationLabel.text = "개최지 : \(expoInfo.location)"
            durationLabel.text = "개최 기간 : \(expoInfo.duration)"
            descriptionLabel.text = expoInfo.description
            
            let bodyFont = UIFont.preferredFont(forTextStyle: .body)
            visitorsLabel.changeFontSize(bodyFont, targetString: ": \(ExpoNumberFormatter.changeVisitorsFormat(from: expoInfo.visitors) ?? "정보 없음")")
            locationLabel.changeFontSize(bodyFont, targetString: ": \(expoInfo.location)")
            durationLabel.changeFontSize(bodyFont, targetString: ": \(expoInfo.duration)") 
        } catch let error {
            showAlert(for: "경고", message: "데이터 로드 오류 \n" + error.localizedDescription)
        }
    }
    
    private func divide(title: String) -> String {
        if title.contains("(") {
            let dividedTitle = title.components(separatedBy: "(")
            return "\(dividedTitle[0])\n(\(dividedTitle[1])"
        } else {
            return title
        }
    }
}
