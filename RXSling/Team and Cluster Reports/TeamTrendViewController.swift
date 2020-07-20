//
//  TeamTrendViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Charts

struct OneDayReport {
    var sentCount:Double = 0
    var viewedCount:Double = 0
}

class TeamTrendViewController: UIViewController {
    var backButton : UIBarButtonItem!
    
    @IBOutlet var chartView: LineChartView!
    var reportList: [Report]?
    var teamData: TeamData!
    var clusterData: ClusterReportData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    var tenDaysReport:[String: OneDayReport]!
    var orderedDaysArray = [String]()
    var isGraphDrawn = false
    
    
    weak var callToActionDelegate:CallToActionProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear //UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        tenDaysReport = [String: OneDayReport]()
        
        var includeTodayForReport = true
        tenDaysReport = getDates(forLastNDays: 10, includeToday: &includeTodayForReport)
        
        chartView.noDataTextColor = .rxThickYellow
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            if !isGraphDrawn {
                isGraphDrawn = true
                if let list = reportList {
                    tenDaysReport = getReportsCountWithDates(list: list)
                }
                self.setUpChartView(chartView: chartView)
                setDataCount(daysReport: tenDaysReport)
                chartView.animate(xAxisDuration: 2.5)
        }
        
    }
    
    func getReportsCountWithDates(list: [Report]) -> [String: OneDayReport] {
        
        let mutatingObj = tenDaysReport
        for (key,_) in mutatingObj! {
            for report in list {
                let date = Date(timeIntervalSince1970:(Double(report.CreatedDate!) / 1000.0))
                let formatedDate = Date.getDate(date: date)
                if key == formatedDate {
                    if report.ContentViewed != nil {
                        tenDaysReport[key]?.viewedCount +=  Double ( report.ContentViewed ?? 0 )
                    }
                    tenDaysReport[key]?.sentCount += 1
                }
            }
        }
        return tenDaysReport
    }

    
    
    func setUpChartView(chartView:LineChartView)  {
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.delegate = self
        
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 6)
        xAxis.labelPosition = .top
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.valueFormatter = IndexAxisValueFormatter(values: orderedDaysArray)

        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = .white
        leftAxis.labelFont = .systemFont(ofSize: 8)
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = ( tenDaysReport.values.map{$0.sentCount}.max() == 0 ) ? Double(1) : tenDaysReport.values.map{$0.sentCount}.max()!
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.decimals = 0
        
        
        chartView.rightAxis.enabled = false
        
    }
    
    func setDataCount(daysReport: [String: OneDayReport]) {
        
        let sent = getSentData(daysReport: daysReport)
        let viewed = getViewedData(daysReport: daysReport)
        
        
        let set1 = LineChartDataSet(entries: sent, label: "Sent")
        set1.axisDependency = .left
        set1.mode = .cubicBezier
        set1.setColor(UIColor.rxThickYellow)
        set1.setCircleColor(.white)
        set1.lineWidth = 1
        set1.circleRadius = 1
        set1.fillColor = UIColor.rxThickYellow
        set1.highlightColor = UIColor.rxThickYellow
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 8)

        
        let set2 = LineChartDataSet(entries: viewed, label: "Viewed")
        set2.axisDependency = .left
        set2.mode = .cubicBezier
        set2.setColor(.rxGreen)
        set2.setCircleColor(.white)
        set2.lineWidth = 1
        set2.circleRadius = 1
        set2.fillColor = .rxGreen
        set2.highlightColor = .rxGreen
        set2.drawCircleHoleEnabled = false
        set2.valueFont = .systemFont(ofSize: 8)
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueTextColor(.clear)
        data.setValueFont(.systemFont(ofSize: 9))
        chartView.data = data
    }
    
    func getSentData(daysReport: [String:OneDayReport]) -> [ChartDataEntry] {
        var array = [ChartDataEntry]()
        for ( index, value ) in orderedDaysArray.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: daysReport[value]?.sentCount ?? Double(0))
            array.append(entry)
        }
        return array
    }
    func getViewedData(daysReport: [String:OneDayReport]) -> [ChartDataEntry] {
        var array = [ChartDataEntry]()
        for ( index, value ) in orderedDaysArray.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: daysReport[value]?.viewedCount ?? Double(0))
            array.append(entry)
        }
        return array
    }
    
//    func getXaxisLabels() -> [String:Any] {
//        var dict = [String:Any]()
//        for ( index, value ) in orderedDaysArray.enumerated() {
//            dict["\(index)"] = value
//        }
//        return dict
//
//    }
    
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        callToActionDelegate?.callAction()
    }
    @IBAction func whatsappButtonAction(_ sender: UIButton) {
        callToActionDelegate?.whatsappAction()
    }
    @IBAction func copyReportButtonAction(_ sender: UIButton) {
        callToActionDelegate?.copyReportAction()
    }
    @IBAction func emailButtonAction(_ sender: UIButton) {
        callToActionDelegate?.emailAction()
    }
    
    func getDates(forLastNDays nDays: Int, includeToday:inout Bool) -> [String:OneDayReport] {
        let cal = NSCalendar.current
        // start with today
        var dict = [String: OneDayReport]()
        var date = cal.startOfDay(for: Date())
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            if includeToday {
                includeToday = !includeToday
                date = cal.date(byAdding: Calendar.Component.day, value: 0, to: date)!
            }else {
                date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateString = dateFormatter.string(from: date)
            orderedDaysArray.append(dateString)
            dict[dateString] = OneDayReport()
        }
        
        orderedDaysArray = orderedDaysArray.reversed()
        return dict
    }
    
}
extension TeamTrendViewController:ChartViewDelegate {
    
    
}


extension Date {

    
    static func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
