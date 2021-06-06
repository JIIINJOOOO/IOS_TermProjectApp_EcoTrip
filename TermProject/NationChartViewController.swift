//
//  NationChartViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/06/07.
//

import UIKit
import Charts

class NationChartViewController: UIViewController {

    @IBOutlet var barChartView: BarChartView!
    
    var posts = NSMutableArray()
    var cityArr : [String] = [] // 차트 데이터 (도시)
    var stationsArr: [Int] = [] // 도시별 충전소 개수 배열
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        makeChartData()
        setChart(dataPoints: cityArr, values: stationsArr)
       
    }
    func setChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "충전소 갯수")
        
        //차트 컬러
        chartDataSet.colors = [.systemPink]
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func makeChartData() {
        let arr = posts as Array
        var str : String
        var stationCount = 0
        for i in 0..<cityArr.count {
            for j in 0..<arr.count
            {
                str = (arr[j].value(forKey: "addr")) as! NSString as String
                //print(str)
            
                if(str.contains(cityArr[i]))
                {
                   stationCount += 1
                }
            }
            stationsArr.append(stationCount)
        }
    }
    
    func removeDuplicate (_ array: [String]) -> [String] {
        var removedArray = [String]()
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
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
