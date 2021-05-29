//
//  NationViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/29.
//

import UIKit

class NationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate {
    var url : String = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D"


    // xml파일을 다운로드 및 파싱하는 오브젝트(객체)
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
  
    
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
    var stateStrArr : [String] = [] // 광역,특별시/도
    var cityStrArr : [String] = [] // 시, 구
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateStrArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateStrArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showPickerTF.text = stateStrArr[row]
    }

    @IBOutlet weak var showPickerTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showPickerTF.tintColor = .clear
        createPickerView(textfield: showPickerTF)
        dismissPickerView(textfield: showPickerTF)
    }
    
    func createPickerView(textfield : UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textfield.inputView = pickerView
    }
    
    func dismissPickerView(textfield : UITextField) {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    @objc func action(sender: UIBarButtonItem)
    {
        
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
