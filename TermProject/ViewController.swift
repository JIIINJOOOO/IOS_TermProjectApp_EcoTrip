//
//  ViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/16.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    // 현재 위치 받아오기
    var locationManager = CLLocationManager()
    
    
    var zcode : String = ""
    // 현재 위치의 시
    var userCity : String = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            self.userCity = placemark.addressDictionary!["City"] as! String
            print("뷰컨 usercity:\(self.userCity)")
            // 시/도 얻는 코드
            let state = placemark.addressDictionary!["State"] as! String
            
            switch state {
            case "서울특별시" :
                self.zcode = "11"
                break
            case "경기도" :
                self.zcode = "41"
                break
            case "부산광역시" :
                self.zcode = "26"
                break
            case "대구광역시" :
                self.zcode = "27"
                break
            case "인천광역시" :
                self.zcode = "28"
                break
            case "광주광역시" :
                self.zcode = "29"
                break
            case "대전광역시" :
                self.zcode = "30"
                break
            case "울산광역시" :
                self.zcode = "31"
                break
            case "강원도" :
                self.zcode = "42"
                break
            case "충청북도" :
                self.zcode = "43"
                break
            case "충청남도" :
                self.zcode = "44"
                break
            case "전라북도" :
                self.zcode = "45"
                break
            case "전라남도" :
                self.zcode = "46"
                break
            case "경상북도" :
                self.zcode = "47"
                break
            case "경상남도" :
                self.zcode = "48"
                break
            case "제주특별자치도" :
                self.zcode = "50"
                break
            default:
                break
            }
            print("뷰컨 zcode:\(self.zcode)")
            // 우편번호 얻는 코드
            //let State = placemark.postalCode ?? "unknown"
            //print("탭바 유저시티: \(self.userCity)")
            //print(postalCode)
        }
    }
    
    // 충전소 찾기 뷰에서 X 버튼 누르면 동작하는 unwind 메소드
    @IBAction func doneToMainViewController(segue:UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNearView" {
            // 메인에선 네비게이션 바 없애고 메뉴 들어갔을 때만 네비게이션 바 생기도록
            self.navigationController?.isNavigationBarHidden = false
            if let tabController = segue.destination as? NearTabBarController {
                tabController.userCity = userCity
                tabController.zcode = zcode
            }
            //if let tabController = segue.destination as? UITabBarController {
//                if let nearTableViewController = tabController.navigationController?.topViewController as?
                
                    //tabController.url = url +
                
            //}
        
       
        }
        if segue.identifier == "segueToNationView" {
            // 메인에선 네비게이션 바 없애고 메뉴 들어갔을 때만 네비게이션 바 생기도록
            self.navigationController?.isNavigationBarHidden = false
            if let tabController = segue.destination as? UITabBarController {
//                if let nearTableViewController = tabController.navigationController?.topViewController as?
                
                    //tabController.url = url +
                
            }
        }
    }
    
}

