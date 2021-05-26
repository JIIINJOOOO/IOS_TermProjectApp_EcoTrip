//
//  NearStationTableViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/21.
//

import UIKit
import CoreLocation

class NearStationTableViewController: UITableViewController, XMLParserDelegate, CLLocationManagerDelegate {
    // 현재 위치 받아오기
    var locationManager = CLLocationManager()
    @IBOutlet var tbData: UITableView!
  
    var url : String = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D&zcode="
  
    var rows = 0 // default = 0
    
    var zcode : String = "41" // default = 경기
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
    var statNm = NSMutableString()
    var stat = NSMutableString()
    // 주소 별 구분 위한 주소 변수
    var addr = NSMutableString()
    
    // 위도 경도 좌표 변수
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    
    //충전소이름 변수와 utf8 변수 추가
    var stationname = ""
    var stationname_utf8 = ""
    
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
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
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
        else if element.isEqual(to: "XPos") {
            XPos.append(string)
        } else if element.isEqual(to: "YPos") {
            YPos.append(string)
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
            if !XPos.isEqual(nil) {
                elements.setObject(XPos, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil) {
                elements.setObject(YPos, forKey: "YPos" as NSCopying)
            }
            posts.add(elements)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        //self.navigationController?.isNavigationBarHidden = true // 나중에 상세 테이블뷰로 넘어가는 세그에서 히든 풀어주기
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
 
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
        
        print(userCity)
        makeNearStationsArray()
    }
    // 파싱한 데이터중 위치주소의 데이터만 따로 array에 담음
    func makeNearStationsArray() {
        let arr = posts as Array
        var str : String
        for i in 0..<arr.count
        {
            str = (arr[i].value(forKey: "addr")) as! NSString as String
            //print(str)
            
            if(str.contains(userCity))
            {
                nearStationsArr.add(arr[i])
                rows += 1
            }
        }
        tbData!.reloadData()
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("didUpdateLocations")
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
            //print(address)
            let city = placemark.addressDictionary!["City"] as! String
           
            // 우편번호 얻는 코드
            let postalCode = placemark.postalCode ?? "unknown"
            //print(city)
            //print(postalCode)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return rows
        //return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var subTitleStatStr : String = String("NULL")
        // Configure the cell...
//        if (((posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String).contains(userCity)) {
//            subTitleStatStr = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
//            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
   
        subTitleStatStr = (nearStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
        cell.textLabel?.text = (nearStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
        
   
       
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
//        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
