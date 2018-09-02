//
//  NewUsersViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Charts

class NewUsersViewController: UIViewController {

    lazy var dayBarChart: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(yAxisDuration: 1.2, easingOption: .easeInCirc)
        chart.chartDescription?.text = ""
        
        let l = chart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        return chart
    }()
    
    lazy var weekBarChart: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(yAxisDuration: 1.2, easingOption: .easeInCirc)
        chart.chartDescription?.text = ""
        
        let l = chart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        return chart
    }()
    
    lazy var monthBarChart: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(yAxisDuration: 1.2, easingOption: .easeInCirc)
        chart.chartDescription?.text = ""
        
        let l = chart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        return chart
    }()
    
    lazy var yearBarChart: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.animate(yAxisDuration: 1.2, easingOption: .easeInCirc)
        chart.chartDescription?.text = ""
        
        let l = chart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        return chart
    }()
    
    var clearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.2)
        
        return view
    }()
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profits = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let users = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"]
        let hosts = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(chartSwiped(sender:)))
        gestureLeft.direction = .left
        clearView.addGestureRecognizer(gestureLeft)
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(chartSwiped(sender:)))
        gestureRight.direction = .right
        clearView.addGestureRecognizer(gestureRight)
        view.clipsToBounds = false
        
        setupViews()
        configurePageControl()
        setChart(chart: dayBarChart, dataPoints: profits, values: unitsSold)
        setChart(chart: weekBarChart, dataPoints: users, values: unitsSold)
        setChart(chart: monthBarChart, dataPoints: hosts, values: unitsSold)
        setChart(chart: yearBarChart, dataPoints: hosts, values: unitsSold)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var daysAnchor: NSLayoutConstraint!
    var weeksAnchor: NSLayoutConstraint!
    var monthsAnchor: NSLayoutConstraint!
    var yearsAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(dayBarChart)
        daysAnchor = dayBarChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            daysAnchor.isActive = true
        dayBarChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        dayBarChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dayBarChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(weekBarChart)
        weeksAnchor = weekBarChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 2)
            weeksAnchor.isActive = true
        weekBarChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        weekBarChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        weekBarChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(monthBarChart)
        monthsAnchor = monthBarChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 2)
            monthsAnchor.isActive = true
        monthBarChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        monthBarChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        monthBarChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(yearBarChart)
        yearsAnchor = yearBarChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 2)
            yearsAnchor.isActive = true
        yearBarChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        yearBarChart.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        yearBarChart.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
    func setChart(chart: BarChartView, dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let label = UILabel()
        if chart == dayBarChart {
            label.text = "Last 3 days"
        } else if chart == weekBarChart {
            label.text = "Last 2 weeks"
        } else if chart == monthBarChart {
            label.text = "Last 3 months"
        } else {
            label.text = "Last year"
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label.text)
        chartDataSet.colors = [Theme.PRIMARY_COLOR]
        let chartData = BarChartData(dataSet: chartDataSet)
        chart.data = chartData
        
        chart.chartDescription?.text = ""
        chart.noDataTextColor = Theme.DARK_GRAY
        chart.xAxis.labelTextColor = Theme.DARK_GRAY
        chart.leftAxis.labelTextColor = UIColor.white
        chart.rightAxis.labelTextColor = UIColor.white
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.gridColor = Theme.DARK_GRAY
        chart.leftAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.gridColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
    }
    
    func configurePageControl() {
        
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = Theme.PRIMARY_COLOR
        self.pageControl.pageIndicatorTintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.isUserInteractionEnabled = false
        
        self.view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: dayBarChart.bottomAnchor, constant: 10).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.view.addSubview(line)
        line.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        line.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(clearView)
        clearView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        clearView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        clearView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        clearView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func chartSwiped(sender: UISwipeGestureRecognizer) {
        if self.daysAnchor.constant == 0 {
            if sender.direction == .left {
                self.daysAnchor.constant = -self.view.frame.width * 2
                self.weeksAnchor.constant = 0
                self.monthsAnchor.constant = self.view.frame.width * 2
                self.yearsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 1
            } else {
                return
            }
        } else if self.weeksAnchor.constant == 0 {
            if sender.direction == .left {
                self.daysAnchor.constant = -self.view.frame.width * 2
                self.weeksAnchor.constant = -self.view.frame.width * 2
                self.monthsAnchor.constant = 0
                self.yearsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 2
            } else {
                self.daysAnchor.constant = 0
                self.weeksAnchor.constant = self.view.frame.width * 2
                self.monthsAnchor.constant = self.view.frame.width * 2
                self.yearsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 0
            }
        } else if self.monthsAnchor.constant == 0 {
            if sender.direction == .left {
                self.daysAnchor.constant = -self.view.frame.width * 2
                self.weeksAnchor.constant = -self.view.frame.width * 2
                self.monthsAnchor.constant = -self.view.frame.width * 2
                self.yearsAnchor.constant = 0
                self.pageControl.currentPage = 3
            } else {
                self.daysAnchor.constant = -self.view.frame.width * 2
                self.weeksAnchor.constant = 0
                self.monthsAnchor.constant = self.view.frame.width * 2
                self.yearsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 1
            }
        } else if self.yearsAnchor.constant == 0 {
            if sender.direction == .left {
                return
            } else {
                self.daysAnchor.constant = -self.view.frame.width * 2
                self.weeksAnchor.constant = -self.view.frame.width * 2
                self.monthsAnchor.constant = 0
                self.yearsAnchor.constant = self.view.frame.width * 2
                self.pageControl.currentPage = 2
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    


}








