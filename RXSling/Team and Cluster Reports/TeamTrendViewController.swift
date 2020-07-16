//
//  TeamTrendViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
class TeamTrendViewController: UIViewController {
    var backButton : UIBarButtonItem!
    
    @IBOutlet var chartView: LineChartView!
    var reportList: [Report]?
    var teamData: TeamData!
    var clusterData: ClusterReportData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    var sentDataForLastTenDays:[[String:Int]]!
    var viewedDataForLastTenDays:[[String:Int]]!
    
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
        
        
        var includeTodayForSentData = true
        var includeTodayForViewedData = true

        sentDataForLastTenDays = Date.getDates(forLastNDays: 10, includeToday: &includeTodayForSentData)
        viewedDataForLastTenDays = Date.getDates(forLastNDays: 10, includeToday: &includeTodayForViewedData)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let list = reportList {
            let sentData = fetchSentData(list: list)
            let viewedData = fetchViewedData(list: list)
            print(viewedData, sentData)
            self.setUpChartView(chartView: chartView)
            setDataCount(sentData: sentData, viewdData: viewedData)
            chartView.animate(xAxisDuration: 2.5)
        } else {
            // No chart data available
        }
        
    }
    
    func fetchViewedData(list:[Report]) -> [[String:Int]] {
        for (index,item) in viewedDataForLastTenDays!.enumerated() {
            for report in list {
                let date = Date(timeIntervalSince1970:(Double(report.CreatedDate!) / 1000.0))
                let formatedDate = Date.getDate(date: date)
                if item.keys.first == formatedDate {
                    if report.ContentViewed != nil {
                        viewedDataForLastTenDays[index][formatedDate]  = item[formatedDate]! + ( report.ContentViewed ?? 0)
                    }
                }
            }
        }
        return viewedDataForLastTenDays
    }
    
    func fetchSentData(list:[Report]) -> [[String:Int]] {
        for (index,item) in sentDataForLastTenDays!.enumerated() {
            for report in list {
                let date = Date(timeIntervalSince1970:(Double(report.CreatedDate!) / 1000.0))
                let formatedDate = Date.getDate(date: date)
                if item.keys.first == formatedDate {
                    print(" key \(item.keys.first ?? ""), formatedDate: \(formatedDate)")
                    sentDataForLastTenDays[index][formatedDate]  = item[formatedDate]! + 1
                    //sentDataForLastTenDays[index]["createdDate"] = report.CreatedDate!

                }
            }
        }
        return sentDataForLastTenDays
    }
    
    func setUpChartView(chartView:LineChartView)  {
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 6)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false

//        xAxis.axisMinimum = Double(sentDataForLastTenDays.first!["createdAt"]!)
//        xAxis.axisMaximum = Double(sentDataForLastTenDays.last!["createdAt"]!)
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = .white//UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = Double( reportList?.count ?? 0 )
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        
    }
    
    func setDataCount(sentData:[[String:Int]],viewdData:[[String:Int]]) {
        
        let sent = sentData.map { (dict) -> ChartDataEntry in
            print(dict["createdAt"]!)
            return ChartDataEntry(x: Double(dict["createdAt"]!), y: Double(dict.values.first!)) // dict["createdAt"]!
        }
        
        let viewed = viewdData.map { (dict) -> ChartDataEntry in
            return ChartDataEntry(x: Double(dict["createdAt"]!), y: Double(dict.values.first!))
        }
        
        let set1 = LineChartDataSet(entries: sent, label: "Sent")
        set1.axisDependency = .left
        set1.setColor(UIColor.rxThickYellow)
        set1.setCircleColor(.white)
        set1.lineWidth = 2
        set1.circleRadius = 2
        set1.fillColor = UIColor.rxThickYellow
        set1.highlightColor = UIColor.rxThickYellow
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(entries: viewed, label: "Viewed")
        set2.axisDependency = .left
        set2.setColor(.rxGreen)
        set2.setCircleColor(.white)
        set2.lineWidth = 2
        set2.circleRadius = 2
        set2.fillColor = .rxGreen
        set2.highlightColor = .rxGreen
        set2.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueTextColor(.clear)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartView.data = data
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension Date {
    static func getDates(forLastNDays nDays: Int, includeToday:inout Bool) -> [[String:Int]] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [[String:Int]]()
        
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
            arrDates.append([dateString : 0, "createdAt": Int(date.timeIntervalSince1970)])
        }
        return arrDates.reversed()
    }
    
    static func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
