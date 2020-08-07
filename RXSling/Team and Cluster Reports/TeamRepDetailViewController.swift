//
//  ClusterReportViewController.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 06/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Charts


class TeamRepDetailViewController: UIViewController {
    var backButton : UIBarButtonItem!
    
    
    @IBOutlet weak var staticRepNameLabel:UILabel!
    @IBOutlet weak var staticRepEmailLabel:UILabel!
    @IBOutlet weak var staticRepMobileLabel:UILabel!
    @IBOutlet weak var staticRepHeadingLabel:UILabel!
    
    @IBOutlet weak var repNameLbl:UILabel!
    @IBOutlet weak var repMobileLbl:UILabel!
    @IBOutlet weak var repEmailLbl:UILabel!
    @IBOutlet weak var contentTitleLbl:UILabel!
    @IBOutlet weak var contentDescriptionLbl:UILabel!
    @IBOutlet weak var sentCountLbl:UILabel!
    @IBOutlet weak var viewedCountLbl:UILabel!
    @IBOutlet weak var SuccessLbl:UILabel!
    @IBOutlet weak var noChartDataLbl:UILabel!
    
    @IBOutlet weak var staticContentTitleLabel:UILabel!
    @IBOutlet weak var staticContentDescLabel:UILabel!
    @IBOutlet weak var staticSentCountLabel:UILabel!
    @IBOutlet weak var staticViewedCountLabel:UILabel!
    @IBOutlet weak var staticSuccessPercLabel:UILabel!
    @IBOutlet weak var staticContentInfoLabel:UILabel!
    @IBOutlet weak var staticPerformanceViewLabel:UILabel!
    @IBOutlet weak var staticCallToActionLabel:UILabel!
    @IBOutlet weak var staticViewedLabel:UILabel!
    @IBOutlet weak var staticNotViewedLabel:UILabel!
    @IBOutlet weak var callBtn:UIButton!
    @IBOutlet weak var whatsAppBtn:UIButton!
    @IBOutlet weak var copyReportBtn:UIButton!
    @IBOutlet weak var emailBtn:UIButton!
    
    var reportList: [Report]?
    var teamData: TeamData!
    var clusterData: ClusterReportData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    @IBOutlet var chartView: PieChartView!
    weak var callToActionDelegate:CallToActionProtocol?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear 
        //  scroller.contentSize.height = 1.0
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        if !isTeamReport {
            staticRepHeadingLabel.text = "Manager Details"
            staticRepNameLabel.text = "Manager Name  -"
            staticRepEmailLabel.text = "Manager Email  -"
            staticRepMobileLabel.text = "Manager Mobile No  -"
        }

         isTeamReport ? self.updateTeamData(data: teamData) : self.updateClusterData(data: clusterData)
        
        
        // chart view
        chartView.noDataTextColor = .clear
        if isTeamReport {
            if let sentCount = teamData.sentCount, sentCount > 0 {
                noChartDataLbl.isHidden = true
                self.setup(pieChartView: chartView)
                      chartView.delegate = self
                      chartView.legend.enabled = false
                      self.setDataToChartView()
                      chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
            } else { noChartDataLbl.isHidden = false }
        } else {
            if let sentCount = clusterData.sentCount, sentCount > 0 {
                noChartDataLbl.isHidden = true
                self.setup(pieChartView: chartView)
                      chartView.delegate = self
                      chartView.legend.enabled = false
                      self.setDataToChartView()
                      chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
            } else { noChartDataLbl.isHidden = false }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
           
       staticRepNameLabel.text = "REP Name".localizedString()
       staticRepMobileLabel.text = "REP Mobile No".localizedString()
       staticRepEmailLabel.text = "REP Email".localizedString()
       staticRepHeadingLabel.text = "Rep Details".localizedString()

       staticContentTitleLabel.text = "Content Title  -".localizedString()
       staticContentDescLabel.text = "Content Desc  -".localizedString()
       staticSentCountLabel.text = "Sent Count  -".localizedString()
       staticViewedCountLabel.text = "Viewed Count  -".localizedString()
       staticSuccessPercLabel.text = "Success %  -".localizedString()
       staticContentInfoLabel.text = "Content Information".localizedString()
       staticPerformanceViewLabel.text = "Performance View".localizedString()
       staticCallToActionLabel.text = "Call to Actions".localizedString()
        
           noChartDataLbl.text = "No chart data available".localizedString()
           staticViewedLabel.text = "Viewed".localizedString()
           staticNotViewedLabel.text = "Not Viewed".localizedString()
           
     
           callBtn.setTitle("Call".localizedString(), for: .normal)
           whatsAppBtn.setTitle("WhatsApp".localizedString(), for: .normal)
           copyReportBtn.setTitle("Copy Report".localizedString(), for: .normal)
           emailBtn.setTitle("Email".localizedString(), for: .normal)
       }
    
    func setup(pieChartView chartView: PieChartView) {
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.30
        chartView.transparentCircleRadiusPercent = 0 //0.61
        chartView.chartDescription?.enabled = false
        chartView.drawCenterTextEnabled = false
        chartView.holeColor = .clear
                
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }
    
    func setDataToChartView() {
        
        var entries = [PieChartDataEntry]()
        
        // check cluster and team count
        if isTeamReport {
            if let count = teamData.sentCount, count > 0 {
                let viewedCount = "\(teamData.viewedCount ?? 0)"
                let notViewed = "\(teamData.sentCount! - ( teamData.viewedCount ?? 0 ) )"
                entries.append(PieChartDataEntry(value: Double(Int(viewedCount) ?? 0), label: "Viewed".localizedString()))
                entries.append(PieChartDataEntry(value: Double(Int(notViewed) ?? 0), label: "Not Viewed".localizedString()))
                
            }
        } else {
            if let count = clusterData.sentCount, count > 0 {
                let viewedCount = "\(clusterData.viewedCount ?? 0)"
                let notViewed = "\(clusterData.sentCount! - ( clusterData.viewedCount ?? 0 ) )"
                entries.append(PieChartDataEntry(value: Double(Int(viewedCount) ?? 0), label: "Viewed".localizedString()))
                entries.append(PieChartDataEntry(value: Double(Int(notViewed) ?? 0), label: "Not Viewed".localizedString()))
                
            }
        }
        
        
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 2
        set.colors = [UIColor.rxViewedColor, UIColor.rxThickYellow]
        set.xValuePosition = .insideSlice
        set.yValuePosition = .insideSlice
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 13, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    
    
    func updateTeamData(data:TeamData)  {
        
        self.repNameLbl.text = ( data.userData?.firstName ?? "" )  + " " +  ( data.userData?.lastName ?? "" )
        self.repMobileLbl.text = data.userData?.mobileNo ?? ""
        self.repEmailLbl.text = data.userData?.emailId ?? ""
        self.contentTitleLbl.text = selectedSnt?.title ?? ""
        self.contentDescriptionLbl.text = selectedSnt?.desc ?? ""
        self.sentCountLbl.text = "\(data.sentCount ?? 0)"
        self.viewedCountLbl.text = "\(data.viewedCount ?? 0)"
        if sentCountLbl.text == "0" ||  viewedCountLbl.text == "0" {
            SuccessLbl.text = "0%"
        } else {
            let percentage =  ( Double (data.viewedCount!) / Double ( data.sentCount! ) ) * 100
            SuccessLbl.text = String(format: "%.1f%@", percentage, "%") // ceil(percentage*100)/100
        }
        
        
    }
    
    func updateClusterData(data: ClusterReportData) {
        
        self.repNameLbl.text = ( data.userData?.firstName ?? "" )  + " " +  ( data.userData?.lastName ?? "" )
        self.repMobileLbl.text = data.userData?.mobileNo ?? ""
        self.repEmailLbl.text = data.userData?.emailId ?? ""
        self.contentTitleLbl.text = selectedSnt?.title ?? ""
        self.contentDescriptionLbl.text = selectedSnt?.desc ?? ""
        self.sentCountLbl.text = "\(data.sentCount ?? 0)"
        self.viewedCountLbl.text = "\(data.viewedCount ?? 0)"
        if sentCountLbl.text == "0" ||  viewedCountLbl.text == "0" {
            SuccessLbl.text = "0%"
        } else {
            let percentage =  ( Double (data.viewedCount!) / Double ( data.sentCount! ) ) * 100
            SuccessLbl.text = String(format: "%.1f%@", percentage, "%") // ceil(percentage*100)/100
        }
        
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        callToActionDelegate?.callAction(isTrendVC: false)
    }
    @IBAction func whatsAppButtonAction(_ sender: UIButton) {
        callToActionDelegate?.whatsappAction(isTrendVC: false, daysReport: [:], orderedDays: [])
    }
    
    @IBAction func copyReportButtonAction(_ sender: UIButton) {
        callToActionDelegate?.copyReportAction(isTrendVC: false, daysReport: [:], orderedDays: [])
    }
    @IBAction  func emailButtonAction(_ sender: UIButton) {
        callToActionDelegate?.emailAction(isTrendVC: false, daysReport: [:], orderedDays: [])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension TeamRepDetailViewController:ChartViewDelegate {
    
}
