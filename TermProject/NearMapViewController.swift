//
//  NearMapViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/23.
//

import UIKit
import MapKit

class NearMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, XMLParserDelegate {
    // 현재 위치 받아오기
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var url : String = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D&zcode="
  
    var zcode : String = "41" // default = 경기
    var userCity : String = ""
    // xml파일을 다운로드 및 파싱하는 오브젝트(객체)
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // 현재 위치 근처 충전소만 담겨있는 배열
    var nearStationsArr = NSMutableArray()
    
    // title과 date같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    // 저장 문자열 변수
    var statNm = NSMutableString() // 충전소명
    var addr = NSMutableString()   // 충전소 주소
    
    // 위도 경도 좌표 변수
    var lat = NSMutableString()
    var lng = NSMutableString()
    
   
    
    
    func beginParsing() {
        posts = []
        // 가져오는 xml data에 따라서 파싱하는 타이틀이 달라진다
        //parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser = XMLParser(contentsOf: (URL(string: url+zcode))!)!
        
        parser.delegate = self
        parser.parse()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        // xml url을 웹에서 띄워서 element이름을 찾는다
        // element 안에서 정보를 가져온다
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item") // element 이름에 따라 바뀜
        {
            elements = NSMutableDictionary()
            elements = [:]
            statNm = NSMutableString()
            statNm = ""
            addr = NSMutableString()
            addr = ""
            // 위도 경도
            lat = NSMutableString()
            lat = ""
            lng = NSMutableString()
            lng = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "statNm") {
            statNm.append(string)
        } else if element.isEqual(to: "addr") {
            addr.append(string)
        }
        // 위도 경도
        else if element.isEqual(to: "lat") {
            lat.append(string)
        } else if element.isEqual(to: "lng") {
            lng.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !statNm.isEqual(nil) {
                elements.setObject(statNm, forKey: "statNm" as NSCopying)
            }
            if !addr.isEqual(nil) {
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            // 위도 경도
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: "lat" as NSCopying)
            }
            if !lng.isEqual(nil) {
                elements.setObject(lng, forKey: "lng" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //beginParsing()
        // Do any additional setup after loading the view.
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허가 받기 alert
        locationManager.requestWhenInUseAuthorization()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() // 위치 정보 받아오기 시작
            //print(locationManager.location?.coordinate)
//        } else {
//            print("위치 정보 Off 상태")
//        }
        // 내 위치 표시
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        
        makeNearStationsArray()
        loadInitialData()
        mapView.addAnnotations(stations)
    }
    // 파싱한 데이터중 위치주소의 데이터만 따로 array에 담음
    func makeNearStationsArray() {
        let arr = posts as Array
        var str : String
        for i in 0..<arr.count
        {
            str = (arr[i].value(forKey: "addr")) as! NSString as String
            //print(str)
            //print("맵 유저시티:\(userCity)")
            if(str.contains(userCity))
            {
                nearStationsArr.add(arr[i])
            }
        }
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //print("didUpdateLocations")
            if let location = locations.first {
               // print("위도: \(location.coordinate.latitude)")
                //print("경도: \(location.coordinate.longitude)")
//                let initialLocation = CLLocation(latitude: 37.34052, longitude: 126.73323)
                let initialLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                centerMapOnLocation(location: initialLocation)
                convertToAddressWith(coordinate: location)
            }
        }
        
        // 위도 경도 받아오기 에러
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }

    // 위도,경도를 주소로 변환
    func convertToAddressWith(coordinate: CLLocation) {
        let geoCoder = CLGeocoder()
        let postCoder =
        geoCoder.reverseGeocodeLocation(coordinate) { (placemarks, error) -> Void in
            if error != nil {
                NSLog("\(error)")
                return
            }
            guard let placemark = placemarks?.first,
                  let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] else {
                        return
                    }
            let address = addrList.joined(separator: " ")
            //print(address)
            let city = placemark.addressDictionary!["City"] as! String
            // 우편번호 얻는 코드
            //let postalCode = placemark.postalCode ?? "unknown"
            //print(city)
            //print(postalCode)
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordnateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordnateRegion, animated: true)
    }
    
    // 생성하는 Station 객체들의 배열 선언
    var stations: [Station] = []
    
    // 전송받은 posts 배열에서 정보를 얻어서 Station 객체를 생성하고 배열에 추가 생성
    func loadInitialData() {
        for post in nearStationsArr {
            let statNm = (post as AnyObject).value(forKey: "statNm") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "addr") as! NSString as String
            let lat = (post as AnyObject).value(forKey: "lat") as! NSString as String
            let lng = (post as AnyObject).value(forKey: "lng") as! NSString as String
            let d_lat = (lat as NSString).doubleValue
            let d_lon = (lng as NSString).doubleValue
            let station = Station(title: statNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: d_lat, longitude: d_lon))
            stations.append(station)
        }
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
            }
            return view
        }
}
