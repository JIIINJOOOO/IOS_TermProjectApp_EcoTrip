//
//  NationMapViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/31.
//

import UIKit
import MapKit

class NationMapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // 검색한 위치 충전소만 담겨있는 배열
    var searchedStationsArr = NSMutableArray()
    
    var statecity : String = ""
    
    var bIsCityFilled = false // city 까지 채워졌을땐 지도 가까이 보여주도록
    
    // 선택한 셀의 충전소 명
    var stationName = ""
    
    // 차트 뷰에 보내줄거
    var cityArr : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        makeSearchedStationsArray()
        loadInitialData()
        mapView.addAnnotations(stations)
    }
    
    // 파싱한 데이터중 해당 위치주소의 데이터만 따로 array에 담음
    func makeSearchedStationsArray() {
        let arr = posts as Array
        //print("posts: \(posts)")
        //print("arr:\(arr)")
        var str : String
        for i in 0..<arr.count
        {
            str = (arr[i].value(forKey: "addr")) as! NSString as String
            print(str)
            print("맵 스테이트시티:\(statecity)")
            if(str.contains(statecity))
            {
                searchedStationsArr.add(arr[i])
            }
        }
    }
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordnateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordnateRegion, animated: true)
    }
    
    // 생성하는 Station 객체들의 배열 선언
    var stations: [Station] = []
    
    // 전송받은 posts 배열에서 정보를 얻어서 Station 객체를 생성하고 배열에 추가 생성
    func loadInitialData() {
        var coordinate = CLLocationCoordinate2D()
        var count = 0
       
        var span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        if(!bIsCityFilled) {
            span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        }
       
        //print("searchedStationsArr: \(searchedStationsArr)")
        for post in searchedStationsArr {
            let statNm = (post as AnyObject).value(forKey: "statNm") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "addr") as! NSString as String
            let lat = (post as AnyObject).value(forKey: "lat") as! NSString as String
            let lng = (post as AnyObject).value(forKey: "lng") as! NSString as String
            let d_lat = (lat as NSString).doubleValue
            let d_lon = (lng as NSString).doubleValue
            if(count < 1)
            {
                coordinate.latitude = d_lat
                coordinate.longitude = d_lon
                count += 1
            }
            //print("post:\(post)")
            let station = Station(title: statNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: d_lat, longitude: d_lon), markerTintColor: .cyan)
            stations.append(station)
        }
        let region = MKCoordinateRegion(center: coordinate, span: span)
        //print(coordinate)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Station
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? Station else { return nil }
            let identifier = "marker"
            var view: MKMarkerAnnotationView
    
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.markerTintColor = annotation.markerTintColor
            }
            return view
        }

    // 테이블뷰
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedStationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        
        var subTitleStatStr : String = String("NULL")
        // Configure the cell...
//        if (((posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String).contains(userCity)) {
//            subTitleStatStr = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
//            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
   
        subTitleStatStr = (searchedStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
        cell.textLabel?.text = (searchedStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
        
   
       
        //}
      
        
      
        
        
        if (subTitleStatStr == "1")
        {
            subTitleStatStr = "통신 이상"
        } else if (subTitleStatStr == "2") {
            subTitleStatStr = "충전 대기"
        } else if (subTitleStatStr == "3") {
            subTitleStatStr = "충전 중"
        } else if (subTitleStatStr == "4") {
            subTitleStatStr = "운영 중지"
        } else if (subTitleStatStr == "5") {
            subTitleStatStr = "점검 중"
        } else if (subTitleStatStr == "9") {
            subTitleStatStr = "상태 미확인"
        }
        cell.detailTextLabel?.text = subTitleStatStr
  

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToNationDetail" {
            self.navigationController?.isNavigationBarHidden = false
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                stationName = (searchedStationsArr.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "statNm") as! NSString as String
                if let tableController = segue.destination as? NationDetailTableViewController {
                    tableController.searchedStationsArr = searchedStationsArr
                    tableController.stationName = stationName
                }
            }
        }
        
        if segue.identifier == "segueToChart" {
            if let chartController = segue.destination as? NationChartViewController {
                chartController.posts = posts
                chartController.cityArr = cityArr
            }
        }
    }
    

}
