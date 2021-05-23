//
//  NearTabBarController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/21.
//

import UIKit
import CoreLocation

class NearTabBarController: UITabBarController,CLLocationManagerDelegate {
    
    // 현재 위치 받아오기
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            print(locationManager.location?.coordinate)
//        } else {
//            print("위치 정보 Off 상태")
//        }
        
        
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
            print(address)
            let thoroughfare = placemark.addressDictionary!["Thoroughfare"] as! String
            // 우편번호 얻는 코드
            let postalCode = placemark.postalCode ?? "unknown"
            print(thoroughfare)
            print(postalCode)
        }
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


