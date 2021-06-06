//
//  NearSightsViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/06/06.
//

import UIKit
import MapKit

class NearSightsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tabelView: UITableView!
    // 근처 충전기 정보
    var statNm = ""
    var statAddr = ""
    var statMapX = ""
    var statMapY = ""
    
    var url = ""
    
    
    // xml파일을 다운로드 및 파싱하는 오브젝트(객체)
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    // title과 date같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    // 저장 문자열 변수
    var title1 = NSMutableString() // 관광지명
    // 주소 별 구분 위한 주소 변수
    var addr1 = NSMutableString()
    
    // 관광지 사진
    var firstImage1 = NSMutableString()
    var firstImage2 = NSMutableString()
    
    // 위도 경도 좌표 변수
    var mapX = NSMutableString() // 경도
    var mapY = NSMutableString() // 위도
    

    
    func beginParsing() {
        posts = []
        // 가져오는 xml data에 따라서 파싱하는 타이틀이 달라진다
        //parser = XMLParser(contentsOf: (URL(string: url!))!)!
        url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D&MobileOS=IOS&MobileApp=AppTest&arrange=A&contentTypeId=12&mapX=\(statMapX)&mapY=\(statMapY)&radius=4000&listYN=Y"
        print("url: \(url)")
        parser = XMLParser(contentsOf: (URL(string: url))!)!
        
        parser.delegate = self
        parser.parse()
        //tbData!.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        // xml url을 웹에서 띄워서 element이름을 찾는다
        // element 안에서 정보를 가져온다
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item") // element 이름에 따라 바뀜
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            // 주소
            addr1 = NSMutableString()
            addr1 = ""
            // 위도 경도
            mapX = NSMutableString()
            mapX = ""
            mapY = NSMutableString()
            mapY = ""
            // 이미지
            firstImage1 = NSMutableString()
            firstImage1 = ""
            firstImage2 = NSMutableString()
            firstImage2 = ""
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "addr1") {
            addr1.append(string)
        }
        // 위도 경도
        else if element.isEqual(to: "mapx") {
            mapX.append(string)
        } else if element.isEqual(to: "mapy") {
            mapY.append(string)
        }
        else if element.isEqual(to: "firstimage") {
            firstImage1.append(string)
        } else if element.isEqual(to: "firstimage2") {
            firstImage2.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !addr1.isEqual(nil) {
                elements.setObject(addr1, forKey: "addr1" as NSCopying)
            }
            
            // 위도 경도
            if !mapX.isEqual(nil) {
                elements.setObject(mapX, forKey: "mapx" as NSCopying)
            }
            if !mapY.isEqual(nil) {
                elements.setObject(mapY, forKey: "mapy" as NSCopying)
            }
            // 이미지
            if !firstImage1.isEqual(nil) {
                elements.setObject(firstImage1, forKey: "firstimage" as NSCopying)
            }
            if !firstImage2.isEqual(nil) {
                elements.setObject(firstImage2, forKey: "firstimage2" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
       
        // Configure the cell...
//        if (((posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String).contains(userCity)) {
//            subTitleStatStr = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
//            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
   
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr1") as! NSString as String
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as! NSString as String
        return cell
    }
    

    // 맵뷰
    // 생성하는 Station 객체들의 배열 선언
    var stations: [Station] = []
    // 현재 선택한 충전소
    var selectedStations : [Station] = []
    
    // 전송받은 posts 배열에서 정보를 얻어서 Station 객체를 생성하고 배열에 추가 생성
    func loadInitialData() {
        var coordinate = CLLocationCoordinate2D()
        var count = 0
       
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
       
       
        //print("searchedStationsArr: \(searchedStationsArr)")
        for post in posts {
            let title1 = (post as AnyObject).value(forKey: "title") as! NSString as String
            let addr1 = (post as AnyObject).value(forKey: "addr1") as! NSString as String
            let lat = (post as AnyObject).value(forKey: "mapy") as! NSString as String
            let lng = (post as AnyObject).value(forKey: "mapx") as! NSString as String
            let d_lat = (lat as NSString).doubleValue
            let d_lon = (lng as NSString).doubleValue
//            if(count < 1)
//            {
//                coordinate.latitude = d_lat
//                coordinate.longitude = d_lon
//                count += 1
//            }
            //print("post:\(post)")
            let station = Station(title: title1, locationName: addr1, coordinate: CLLocationCoordinate2D(latitude: d_lat, longitude: d_lon), markerTintColor: .systemOrange)
            stations.append(station)
        }
        let d_statMapY = (statMapY as NSString).doubleValue
        let d_statMapX = (statMapX as NSString).doubleValue

        let selectedStation = Station(title: statNm, locationName: statAddr, coordinate: CLLocationCoordinate2D(latitude: d_statMapY, longitude: d_statMapX),markerTintColor: .red)
        selectedStations.append(selectedStation)
        
        coordinate.latitude = d_statMapY
        coordinate.longitude = d_statMapX
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        beginParsing()
        tabelView.reloadData()
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(stations)
        mapView.addAnnotations(selectedStations)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToImage" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tabelView.indexPath(for: cell)
                let firstImage1 = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "firstimage") as! NSString as String
                let firstImage2 = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "firstimage2") as! NSString as String
                if let imageController = segue.destination as? NearSightImageController {
                    imageController.firstImage1 = firstImage1
                    imageController.firstImage2 = firstImage2

                }
            }
                
            
        }
    }
    

}
