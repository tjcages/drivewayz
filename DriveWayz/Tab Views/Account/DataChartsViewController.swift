//
//  DataChartsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/8/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Charts
import Stripe
import Firebase

class DataChartsViewController: UIViewController, ChartViewDelegate {
    
    var timeArray: [Double] = []
    var costArray: [Int] = [0]
    
    let TESTACCOUNT: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRIMARY_COLOR
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(transferToAccountPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.noDataText = "No parking data."
        chart.chartDescription?.text = ""
        chart.noDataTextColor = Theme.DARK_GRAY
        chart.backgroundColor = UIColor.white
        chart.xAxis.labelTextColor = UIColor.white
        chart.leftAxis.labelTextColor = UIColor.white
        chart.rightAxis.labelTextColor = UIColor.white
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.gridColor = Theme.DARK_GRAY
        chart.leftAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.legend.form = .none
        chart.legend.textColor = UIColor.white
        
        
        return chart
    }()
    
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE
        chartView.delegate = self
        
        pullData()
        setupCharts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullData() {
        let currentUser = Auth.auth().currentUser?.uid
        
        let timeRef = Database.database().reference().child("users").child(currentUser!)
        timeRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let parking = dictionary["parkingID"] as? String {
                    let parkingRef = Database.database().reference().child("parking").child(parking)
                    parkingRef.observeSingleEvent(of: .value, with: { (dictionary) in
                        if let dictionary = dictionary.value as? [String:AnyObject] {
                            if let timestamp = dictionary["timestamp"] as? Double {
                                self.timeArray.append(timestamp)
                            }
                        }
                    })
                }
            }
        }
    
        let userRef = Database.database().reference().child("users").child(currentUser!).child("payments")
        userRef.observe(.value) { (snapshot) in
            for point in 0..<(snapshot.childrenCount) {
                let pointRef = userRef.child("\(point)")
                pointRef.observeSingleEvent(of: .value, with: { (data) in
                    if let dictionary = data.value as? [String:AnyObject] {
                        if let cost = dictionary["currentFunds"] as? Int, let time = dictionary["timestamp"] as? Double {
                            self.timeArray.append(time)
                            self.costArray.append(cost)
                            self.setChart(dataPoints: self.timeArray, values: self.costArray)
                        }
                    }
                })
            }
        }
    }
    

    func setupCharts() {
        
        self.view.addSubview(TESTACCOUNT)
        TESTACCOUNT.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        TESTACCOUNT.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        TESTACCOUNT.widthAnchor.constraint(equalToConstant: 40).isActive = true
        TESTACCOUNT.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(chartView)
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setChart(dataPoints: [Double], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [Double(values[i])])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Money made")
        lineChartDataSet.circleColors = [Theme.PRIMARY_COLOR]
        lineChartDataSet.circleHoleRadius = 0
        lineChartDataSet.circleRadius = 2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.colors = [Theme.PRIMARY_COLOR]
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        chartView.data = lineChartData
        chartView.leftAxis.axisMaximum = lineChartData.yMax
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = lineChartData.xMax
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
//        print("\(entry.value) in \(months[entry.index])")
    }
    
    @objc func transferToAccountPressed(sender: UIButton) {
        MyAPIClient.sharedClient.createAccountKey()
    }

}
