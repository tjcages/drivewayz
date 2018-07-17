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
    var costArray: [Double] = [0]
    var count: Int = 0

    var chartContainer: UIView = {
       let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = Theme.WHITE
        chart.layer.shadowColor = UIColor.darkGray.cgColor
        chart.layer.shadowOffset = CGSize(width: 1, height: 1)
        chart.layer.shadowOpacity = 0.8
        chart.layer.cornerRadius = 10
        chart.layer.shadowRadius = 1
        
        return chart
    }()
    
    var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.noDataText = "Start earning money by becoming a host!"
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
        chart.layer.cornerRadius = 10
        chart.isUserInteractionEnabled = false
        
        return chart
    }()
    
    var profitsLabel: UILabel = {
        let profits = UILabel()
        profits.text = "Profits:"
        profits.textColor = Theme.PRIMARY_DARK_COLOR
        profits.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        profits.translatesAutoresizingMaskIntoConstraints = false
        
        return profits
    }()
    
    var profits: UILabel = {
        let profits = UILabel()
        profits.text = "$0.00"
        profits.textColor = Theme.PRIMARY_COLOR
        profits.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        profits.translatesAutoresizingMaskIntoConstraints = false
        
        return profits
    }()
    
    var transfer: UIButton = {
        let transfer = UIButton()
        transfer.backgroundColor = UIColor.clear
        transfer.translatesAutoresizingMaskIntoConstraints = false
        transfer.setTitle("Transfer to bank", for: .normal)
        transfer.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        transfer.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        transfer.addTarget(self, action: #selector(checkAccount(sender:)), for: .touchUpInside)
        
        return transfer
    }()
    
    var refresh: UIButton = {
        let refresh = UIButton()
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        refresh.setImage(tintedImage, for: .normal)
        refresh.tintColor = Theme.PRIMARY_COLOR
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.addTarget(self, action: #selector(updateCharts), for: .touchUpInside)
        
        return refresh
    }()
    
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE
        chartView.delegate = self
        
        pullData()
        setupCharts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timeArray = []
        self.costArray = [0]
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
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for point in 0..<(snapshot.childrenCount+1) {
                let pointRef = userRef.child("\(point)")
                pointRef.observeSingleEvent(of: .value, with: { (data) in
                    if let dictionary = data.value as? [String:AnyObject] {
                        if let cost = dictionary["currentFunds"] as? Double, let time = dictionary["timestamp"] as? Double {
                            let twoDecimalPlaces = String(format: "%.2f", cost)
                            self.profits.text = "$\(twoDecimalPlaces)"
                            self.timeArray.append(time)
                            self.costArray.append(cost)
                            self.setChart(dataPoints: self.timeArray, values: self.costArray, count: (self.timeArray.count))
                        }
                    }
                })
            }
        })
    }
    

    func setupCharts() {
        
        self.view.addSubview(chartContainer)
        chartContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        chartContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        chartContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        chartContainer.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        self.view.addSubview(chartView)
        chartView.topAnchor.constraint(equalTo: chartContainer.topAnchor, constant: 40).isActive = true
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.leftAnchor.constraint(equalTo: chartContainer.leftAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 190).isActive = true
        
        self.view.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: chartView.leftAnchor, constant: 20).isActive = true
        profitsLabel.topAnchor.constraint(equalTo: chartView.topAnchor, constant: -20).isActive = true
        profitsLabel.sizeToFit()
        
        self.view.addSubview(profits)
        profits.leftAnchor.constraint(equalTo: profitsLabel.rightAnchor, constant: 5).isActive = true
        profits.topAnchor.constraint(equalTo: chartView.topAnchor, constant: -20).isActive = true
        profits.sizeToFit()
        
        self.view.addSubview(transfer)
        transfer.rightAnchor.constraint(equalTo: chartContainer.rightAnchor, constant: -20).isActive = true
        transfer.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -25).isActive = true
        transfer.sizeToFit()
        
        self.view.addSubview(refresh)
        refresh.centerYAnchor.constraint(equalTo: profits.centerYAnchor).isActive = true
        refresh.rightAnchor.constraint(equalTo: chartView.rightAnchor, constant: -15).isActive = true
        refresh.widthAnchor.constraint(equalToConstant: 20).isActive = true
        refresh.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setChart(dataPoints: [Double], values: [Double], count: Int) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<(count) {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [Double(values[i])])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Money made")
        lineChartDataSet.circleColors = [Theme.PRIMARY_COLOR]
        lineChartDataSet.circleHoleRadius = 0
        lineChartDataSet.circleRadius = 2
        lineChartDataSet.colors = [Theme.PRIMARY_COLOR]
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        chartView.data = lineChartData
        chartView.leftAxis.axisMaximum = lineChartData.yMax
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = lineChartData.xMax
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    @objc func updateCharts() {
        self.timeArray = []
        self.costArray = [0]
        pullData()
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        
//        print("\(entry.value) in \(months[entry.index])")
    }
    
    @objc func checkAccount(sender: UIButton) {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let account = dictionary["accountID"] as? String {
                        self.removeFunds(account: account)
                    } else {
                        let bankAccount = BankAccountViewController()
                        self.navigationController?.pushViewController(bankAccount, animated: true)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func removeFunds(account: String) {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snap) in
                if let dictionary = snap.value as? [String:AnyObject] {
                    if let oldFunds = dictionary["userFunds"] as? Double {
                        MyAPIClient.sharedClient.transferToBank(account: account, funds: oldFunds)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            self.updateCharts()
                        })
                    }
                }
            }, withCancel: nil)
        }
    }

}













