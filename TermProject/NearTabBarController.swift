//
//  NearTabBarController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/21.
//

import UIKit
import CoreLocation

class NearTabBarController: UITabBarController, CLLocationManagerDelegate, XMLParserDelegate {
    // 현재 위치 받아오기
    var locationManager = CLLocationManager()
    
    
    var url : String = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D&zcode="
  
    var rows = 0 // default = 0
    
    var zcode : String = "" // default = 경기
    // 현재 위치의 시
    var userCity : String = "" // default = 수원


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
    var stat = NSMutableString() // 충전기상태
    // 주소 별 구분 위한 주소 변수
    var addr = NSMutableString()
    
    // 충전기 타입
    var chgerType = NSMutableString()
    // 이용가능시간
    var useTime = NSMutableString()
    // 운영기관명
    var busiNm = NSMutableString()
    // 연락처
    var busiCall = NSMutableString()
    // 충전량
    var powerType = NSMutableString()
    // 주차료 무료인지
    var parkingFree = NSMutableString()
    // 충전소 안내
    var note = NSMutableString()
    // 이용자 제한
    var limitYn = NSMutableString()
    // 이용제한 사유
    var limitDetail = NSMutableString()
    
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
            statNm = NSMutableString()
            statNm = ""
            stat = NSMutableString()
            stat = ""
            // 주소
            addr = NSMutableString()
            addr = ""
            // 위도 경도
            lat = NSMutableString()
            lat = ""
            lng = NSMutableString()
            lng = ""
            // 충전기 타입
           chgerType = NSMutableString()
            chgerType = ""
            // 이용가능시간
            useTime = NSMutableString()
            useTime = ""
            // 운영기관명
            busiNm = NSMutableString()
            busiNm = ""
            // 연락처
            busiCall = NSMutableString()
            busiCall = ""
            // 충전량
            powerType = NSMutableString()
            powerType = ""
            // 주차료 무료인지
            parkingFree = NSMutableString()
            parkingFree = ""
            // 충전소 안내
            note = NSMutableString()
            note = ""
            // 이용자 제한
            limitYn = NSMutableString()
            limitYn = ""
            // 이용제한 사유
            limitDetail = NSMutableString()
            limitDetail = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "statNm") {
            statNm.append(string)
        } else if element.isEqual(to: "stat") {
            stat.append(string)
        } else if element.isEqual(to: "addr") {
            addr.append(string)
        }
        // 위도 경도
        else if element.isEqual(to: "lat") {
            lat.append(string)
        } else if element.isEqual(to: "lng") {
            lng.append(string)
        }
        else if element.isEqual(to: "chgerType") {
            chgerType.append(string)
        } else if element.isEqual(to: "useTime") {
            useTime.append(string)
        } else if element.isEqual(to: "busiNm") {
            busiNm.append(string)
        } else if element.isEqual(to: "busiCall") {
            busiCall.append(string)
        } else if element.isEqual(to: "powerType") {
            powerType.append(string)
        } else if element.isEqual(to: "parkingFree") {
            parkingFree.append(string)
        } else if element.isEqual(to: "note") {
            note.append(string)
        } else if element.isEqual(to: "limitYn") {
            limitYn.append(string)
        } else if element.isEqual(to: "limitDetail") {
            limitDetail.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !statNm.isEqual(nil) {
                elements.setObject(statNm, forKey: "statNm" as NSCopying)
            }
            if !stat.isEqual(nil) {
                elements.setObject(stat, forKey: "stat" as NSCopying)
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
            if !chgerType.isEqual(nil) {
                elements.setObject(chgerType, forKey: "chgerType" as NSCopying)
            }
            if !useTime.isEqual(nil) {
                elements.setObject(useTime, forKey: "useTime" as NSCopying)
            }
            if !busiNm.isEqual(nil) {
                elements.setObject(busiNm, forKey: "busiNm" as NSCopying)
            }
            if !busiCall.isEqual(nil) {
                elements.setObject(busiCall, forKey: "busiCall" as NSCopying)
            }
            if !powerType.isEqual(nil) {
                elements.setObject(powerType, forKey: "powerType" as NSCopying)
            }
            if !parkingFree.isEqual(nil) {
                elements.setObject(parkingFree, forKey: "parkingFree" as NSCopying)
            }
            if !note.isEqual(nil) {
                elements.setObject(note, forKey: "note" as NSCopying)
            }
            if !limitYn.isEqual(nil) {
                elements.setObject(limitYn, forKey: "limitYn" as NSCopying)
            }
            if !limitDetail.isEqual(nil) {
                elements.setObject(limitDetail, forKey: "limitDetail" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        beginParsing()
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
            print(locationManager.location?.coordinate)
       
      
        // - map view에 데이터 전달
        let mapVC = self.viewControllers?.first as? NearMapViewController
        mapVC?.posts = posts
        mapVC?.userCity = userCity
               
    }
    // 뷰가 화면에 표시된 이후에 수행
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // tab bar controller 의 하위 탭 뷰들에 이렇게 접근하면 됨
        // - table view 에 데이터 전달
        let navVC = self.viewControllers?.last as? UINavigationController
        let tabelVC = navVC?.viewControllers.first as? NearStationTableViewController
        tabelVC?.userCity = userCity
        tabelVC?.posts = posts
       
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("탭바 didUpdateLocations")
            if let location = locations.first {
                print("위도: \(location.coordinate.latitude)")
                print("경도: \(location.coordinate.longitude)")
          
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
            //print("탭바 어드레스: \(address)")
            let city = placemark.addressDictionary!["City"] as! String
            
            // 우편번호 얻는 코드
            let postalCode = placemark.postalCode ?? "unknown"
            //print("탭바 유저시티: \(self.userCity)")
            //print(postalCode)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
    
    }
}
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

 



