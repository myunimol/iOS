//
//  ViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import Charts

/**
 This class is the UIViewController for the home page of the application
 */
class ViewController: UIViewController {
    
    // the scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    // the circular progress bar
    @IBOutlet weak var progress: KDCircularProgress!
    // the label which contains the percentage value for the progress bar
    @IBOutlet weak var percentage: UILabel!
    // the line chart view
    @IBOutlet weak var lineChartView: LineChartView!
    // the bar chart view
    @IBOutlet weak var barChartView: BarChartView!
    // the average degree for all the exams
    @IBOutlet weak var average: UILabel!
    // the starting degree for your graduation
    @IBOutlet weak var startingDegree: UILabel!
    /// the image based on avarage
    @IBOutlet weak var iconAverage: UIImageView!
    /// the home greating
    @IBOutlet weak var homeGreating: UILabel!
    
    var recordBook: RecordBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // force the contraints for elements in left slider
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.bouncePreview(for: MMDrawerSide.left, distance: 0.1, completion: nil)
        
        Utils.setNavigationControllerStatusBar(self, title: "Home", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        // get record book from singleton object
        self.recordBook = RecordBookClass.sharedInstance.recordBook
        let grades = recordBook?.examsGrades
        let degrees = recordBook?.staringDegree
        
        self.average.text = "\(recordBook!.weightedAverage!)"
        let auxDegree = Int(round((recordBook?.weightedAverage)! * 11 / 3))
        self.startingDegree.text = "\(auxDegree)"
        
        self.animateButton()
        
        self.setGradesChart(grades!)
        self.setStartingDegreesChart(degrees!)
        self.setGreating((recordBook?.weightedAverage)!)
    }
    
    func setGreating(_ average: Double) {
        let dict = LoadSentences.getRandomHomeSentence(average)
        let index = dict.index(dict.startIndex, offsetBy: 0)
        let sentence = dict.keys[index]
        let imageRef = "\(dict.values[index]).png"
        let image = UIImage(named: imageRef)
        self.iconAverage.image = image
        self.homeGreating.text = sentence
    }
    
    func setGradesChart(_ grades: [Int]) {
        self.lineChartView.noDataText = "Nessun esame verbalizzato"
        
        var dataEntries: [ChartDataEntry] = []
        
        var fakes = [String]()
        for i in 0..<grades.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: Double(grades[i])))
            fakes.append("")
        }
                
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Esami")
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 2.0
        lineChartDataSet.setDrawHighlightIndicators(false)
        lineChartDataSet.setColor(Utils.myUnimolBlueUIColor)
        lineChartDataSet.colors = [Utils.myUnimolBlueUIColor]
        lineChartDataSet.setCircleColor(Utils.myUnimolBlueUIColor)
        
        let lineChartData = LineChartData()
        lineChartData.addDataSet(lineChartDataSet)
        self.lineChartView.data = lineChartData
        self.lineChartView.data?.setValueTextColor(UIColor.clear) // remove labels
        
        // remove the description
        self.lineChartView.chartDescription?.text = ""
        
        let rightAxis = self.lineChartView.getAxis(YAxis.AxisDependency.right)
        rightAxis.drawLabelsEnabled = false
        
        self.lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
    }
        
    func setStartingDegreesChart(_ startingDegrees: [Int]) {
//        self.barChartView.noDataTextDescription = "Nessun esame verbalizzato"
        self.barChartView.noDataText = "Non hai ancora esami a libretto"
        
        var dataEntries: [ChartDataEntry] = []
        
        var fakes = [String]()
        for i in 0..<startingDegrees.count {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(startingDegrees[i])))
            fakes.append("")
        }
        
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "Voto di partenza")
        barChartDataSet.axisDependency = .left
        barChartDataSet.setColor(UIColor(ciColor: Utils.myUnimolBlue), alpha: 1.0)
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        
        self.barChartView.data = barChartData
        self.barChartView.data?.setValueTextColor(UIColor.clear)
        
        self.barChartView.chartDescription?.text = ""
        
        let rightAxis = self.barChartView.getAxis(YAxis.AxisDependency.right)
        rightAxis.drawLabelsEnabled = false
        
        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateButton() {
        
        let totalCFU = RecordBookClass.sharedInstance.recordBook?.totalCFU
        let courseLenght = Student.sharedInstance.studentInfo?.courseLength
        
        let completeCFU: Int = courseLenght! * 60
        
        var percentage = totalCFU! * 100 / completeCFU
        
        if (percentage > 100) { percentage = 100 }
        
        let angle = percentage * 360 / 100
        
        progress.animate(fromAngle: 0, toAngle: Double(angle), duration: 1) { completed in
            if completed {
                self.percentage.text = "\(percentage)%"
            }
        }
    }
}


