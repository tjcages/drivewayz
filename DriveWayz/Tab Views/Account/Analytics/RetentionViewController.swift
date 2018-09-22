//
//  RetentionViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Charts

class RetentionViewController: UIViewController {
    
    lazy var profitsPieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        chart.entryLabelColor = Theme.DARK_GRAY
        chart.entryLabelFont = .systemFont(ofSize: 16, weight: .light)
        chart.chartDescription?.text = "Profits"
        chart.chartDescription?.position = CGPoint(x: 80, y: 40)
        chart.chartDescription?.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        chart.chartDescription?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        chart.holeRadiusPercent = 0.3
        chart.transparentCircleRadiusPercent = 0.4
        
        let legend = chart.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.font = UIFont.systemFont(ofSize: 14, weight: .light)
        legend.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return chart
    }()
    
    lazy var usersPieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        chart.entryLabelColor = Theme.DARK_GRAY
        chart.entryLabelFont = .systemFont(ofSize: 16, weight: .light)
        chart.chartDescription?.text = "Users"
        chart.chartDescription?.position = CGPoint(x: 80, y: 40)
        chart.chartDescription?.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        chart.chartDescription?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        chart.holeRadiusPercent = 0.3
        chart.transparentCircleRadiusPercent = 0.4
        
        let legend = chart.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.font = UIFont.systemFont(ofSize: 14, weight: .light)
        legend.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return chart
    }()
    
    lazy var hostsPieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        chart.entryLabelColor = Theme.DARK_GRAY
        chart.entryLabelFont = .systemFont(ofSize: 16, weight: .light)
        chart.chartDescription?.text = "Hosts"
        chart.chartDescription?.position = CGPoint(x: 80, y: 40)
        chart.chartDescription?.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        chart.chartDescription?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        chart.holeRadiusPercent = 0.3
        chart.transparentCircleRadiusPercent = 0.4
        
        let legend = chart.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .center
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.font = UIFont.systemFont(ofSize: 14, weight: .light)
        legend.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return chart
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.2)
        
        return view
    }()
    
    var line2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.2)
        
        return view
    }()
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 10))

    override func viewDidLoad() {
        super.viewDidLoad()

        let profits = ["Net profits", "User payouts", "Stripe payouts", "Other payouts"]
        let users = ["Over 10 hours", "Under 10 hours", "No hours"]
        let hosts = ["Over 10 hours", "Under 10 hours", "No hours"]
        let unitsSold = [30.0, 14.0, 16.0, 13.0, 27.0]
        
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(chartSwiped(sender:)))
        gestureLeft.direction = .left
        view.addGestureRecognizer(gestureLeft)
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(chartSwiped(sender:)))
        gestureRight.direction = .right
        view.addGestureRecognizer(gestureRight)
        
        setupViews()
        configurePageControl()
//        setData()
        setChart(chart: profitsPieChart, dataPoints: profits, values: unitsSold)
        setChart(chart: usersPieChart, dataPoints: users, values: unitsSold)
        setChart(chart: hostsPieChart, dataPoints: hosts, values: unitsSold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var profitsAnchor: NSLayoutConstraint!
    var usersAnchor: NSLayoutConstraint!
    var hostsAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(profitsPieChart)
        profitsAnchor = profitsPieChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            profitsAnchor.isActive = true
        profitsPieChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        profitsPieChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        profitsPieChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(usersPieChart)
        usersAnchor = usersPieChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 2)
            usersAnchor.isActive = true
        usersPieChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        usersPieChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        usersPieChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(hostsPieChart)
        hostsAnchor = hostsPieChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 2)
            hostsAnchor.isActive = true
        hostsPieChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        hostsPieChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        hostsPieChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
//    func setData() {
//        guard let currentUser = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child(<#T##pathString: String##String#>)
//    }
    
    func setChart(chart: PieChartView, dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2

        pieChartDataSet.colors = ChartColorTemplates.vordiplom()
            + [UIColor(red: 151/255, green: 181/255, blue: 229/255, alpha: 1)]
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + ChartColorTemplates.colorful()
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        pieChartData.setValueFont(.systemFont(ofSize: 14, weight: .light))
        pieChartData.setValueTextColor(Theme.BLACK)
        
        chart.data = pieChartData
        chart.drawEntryLabelsEnabled = false
        chart.highlightValues(nil)
    }
    
    func configurePageControl() {
        
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = Theme.PRIMARY_COLOR
        self.pageControl.pageIndicatorTintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.isUserInteractionEnabled = false
        
        self.view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: profitsPieChart.bottomAnchor, constant: -40).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.view.addSubview(line)
        line.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        line.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(line2)
        line2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        line2.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func chartSwiped(sender: UISwipeGestureRecognizer) {
        if self.profitsAnchor.constant == 0 {
            if sender.direction == .left {
                self.profitsAnchor.constant = -self.view.frame.width * 2
                self.usersAnchor.constant = 0
                self.hostsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 1
            } else {
                return
            }
        } else if self.usersAnchor.constant == 0 {
            if sender.direction == .left {
                self.profitsAnchor.constant = -self.view.frame.width * 2
                self.usersAnchor.constant = -self.view.frame.width * 2
                self.hostsAnchor.constant = 0
                self.pageControl.currentPage = 2
            } else {
                self.profitsAnchor.constant = 0
                self.usersAnchor.constant = self.view.frame.width * 2
                self.hostsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 0
            }
        } else if self.hostsAnchor.constant == 0 {
            if sender.direction == .left {
                return
            } else {
                self.profitsAnchor.constant = -self.view.frame.width * 2
                self.usersAnchor.constant = 0
                self.hostsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 1
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    

}










