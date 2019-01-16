//
//  HostingGraphsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Charts

class HostingGraphsViewController: UIViewController, ChartViewDelegate {
    
    var timeArray: [Double] = [2,3,5,6,8,10,11,12,13]
    var costArray: [Double] = [1,3,4,6,7,8,9,11,13]
    var chartTimer: Timer?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.noDataText = "Here you will be able to see your earnings!"
        chart.chartDescription?.text = ""
        chart.noDataTextColor = Theme.BLACK
        chart.backgroundColor = UIColor.clear
        chart.xAxis.labelTextColor = UIColor.clear
        chart.leftAxis.labelTextColor = UIColor.clear
        chart.rightAxis.labelTextColor = UIColor.clear
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.gridColor = Theme.DARK_GRAY
        chart.leftAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.axisLineColor = UIColor.clear
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.legend.form = .none
        chart.legend.textColor = UIColor.clear
        chart.doubleTapToZoomEnabled = false
        chart.clipsToBounds = true
        
        return chart
    }()
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "ACCOUNT BALANCE"
        
        return label
    }()
    
    var currentAccountBalance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPExtraLarge
        label.text = "$43.75"
        
        return label
    }()
    
    var lastWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.5)
        label.font = Fonts.SSPRegularH5
        
        var main_string = "+12.3% from last week"
        var string_to_color = "+12.3%"
        var range = (main_string as NSString).range(of: string_to_color)
        var attributedString = NSMutableAttributedString(string:main_string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GREEN_PIGMENT , range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5 , range: range)
        label.attributedText = attributedString
        
        return label
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.layer.cornerRadius = 3
        button.setTitle("Transfer", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(transferButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var chartDate: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.text = "9/12/2016"
        label.textAlignment = .center
        label.alpha = 0
        label.backgroundColor = Theme.BLACK
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        return label
    }()
    
    var chartLine: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0.5, height: 120)
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self

        setupViews()
    }
    

    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        profitsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(currentAccountBalance)
        currentAccountBalance.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        currentAccountBalance.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        currentAccountBalance.topAnchor.constraint(equalTo: profitsLabel.bottomAnchor, constant: 6).isActive = true
        currentAccountBalance.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lastWeekLabel)
        lastWeekLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        lastWeekLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        lastWeekLabel.topAnchor.constraint(equalTo: currentAccountBalance.bottomAnchor, constant: 4).isActive = true
        lastWeekLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(chartView)
        chartView.topAnchor.constraint(equalTo: lastWeekLabel.bottomAnchor, constant: 4).isActive = true
        chartView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        chartView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 20).isActive = true
        
        self.view.addSubview(transferButton)
        transferButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        transferButton.centerYAnchor.constraint(equalTo: currentAccountBalance.centerYAnchor, constant: 4).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        self.view.addSubview(chartDate)
        chartView.addSubview(chartLine)
        
        self.setChart(dataPoints: self.timeArray, values: self.costArray, count: (self.timeArray.count))
    }
    
    @objc func transferButtonPressed() {
        print("transfer")
    }
    
    func setChart(dataPoints: [Double], values: [Double], count: Int) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<(count) {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [Double(values[i])])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Money made")
        lineChartDataSet.circleHoleRadius = 0
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.colors = [Theme.PACIFIC_BLUE]
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.lineCapType = .round
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        let gradientColors = [Theme.PURPLE.cgColor, Theme.PURPLE.withAlphaComponent(0).cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0]
        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
            lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
            lineChartDataSet.drawFilledEnabled = true
        }
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        chartView.data = lineChartData
        chartView.leftAxis.axisMaximum = lineChartData.yMax
        chartView.leftAxis.axisMinimum = lineChartData.yMin
        chartView.rightAxis.axisMaximum = lineChartData.xMax
        chartView.rightAxis.axisMinimum = lineChartData.xMin
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: animationIn, animations: {
                self.transferButton.alpha = 1
            })
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartTimer?.invalidate()
        if highlight.xPx > self.view.frame.width/2 - 40 {
            UIView.animate(withDuration: animationIn) {
                self.chartLine.alpha = 1
                self.chartDate.alpha = 1
                self.chartDate.center.x = highlight.xPx - 48
                self.chartDate.center.y = highlight.yPx + 117
                self.chartLine.frame = CGRect(x: highlight.xPx, y: highlight.yPx - 22, width: 0.5, height: 112 - highlight.yPx + 10)
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.chartLine.alpha = 1
                self.chartDate.alpha = 1
                self.chartDate.center.x = highlight.xPx + 50
                self.chartDate.center.y = highlight.yPx + 102
                self.chartLine.frame = CGRect(x: highlight.xPx, y: highlight.yPx - 34, width: 0.5, height: 112 - highlight.yPx + 12 + 10)
            }
        }
        chartTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(hideChartSelector), userInfo: nil, repeats: false)
//        chartDate.text = "date: \(highlight.x)"
    }
    
    @objc func hideChartSelector() {
        UIView.animate(withDuration: animationOut) {
            self.chartLine.alpha = 0
            self.chartDate.alpha = 0
        }
    }
    
}
