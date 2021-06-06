//
//  NationViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/29.
//

import UIKit
import Speech
import Lottie

class NationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate {
    var url : String = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=W%2F3ncWwPolB0XlcbjKBVfwzNz1R6r2V%2BtVuqYdTdP8kx24s8sqRZCaleQt0p429ccaIqmg%2Bpc9ciXux%2BbHkjpQ%3D%3D&zcode="
   

    // xml파일을 다운로드 및 파싱하는 오브젝트(객체)
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    // 맵뷰로 넘기기 전 파싱할 zcode
    var zcode = ""
    
    var bIsCityFilled = false // city 채워졌는지 넘겨주기
    
    // 지역코드
    let zcodeArr = ["11","41","26","27","28",
                 "29","30","31","42","43",
                 "44","45","46","47","48",
                 "50"]
    
    let stateStrArr = ["서울특별시","경기도","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시","울산광역시","강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주특별자치도"]
    
   
   
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
    

    
  
    
    func beginParsing(zcode : String) {
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
    
    var selectState = "서울특별시"
    var selectCity = "" // 피커뷰 선택시 값을 갖고 있다가 확인버튼 클릭시 텍스트필드에 세팅한다

    var addrDict : [String:[String]] = [:]
    var cityArr : [String] = []
    var addrArr : [Substring] = []
    // 파싱한 데이터중 위치주소의 데이터만 따로 Dictionary에 담음
  
    func makeAddrDictionary() {
        for i in 0..<zcodeArr.count
        {
            beginParsing(zcode: zcodeArr[i])
            let arr = posts as Array
            var str : String
            print("arr count: \(arr.count)")
            for j in 0..<arr.count
            {
                str = (arr[j].value(forKey: "addr")) as! NSString as String
                //print(str)
            
                addrArr = str.split(separator: " ")
                //print(addrArr)
                //print("addrArr counts: \(addrArr.count)")
                if(!addrArr.contains("null"))
                {
                    if(!addrArr[1].contains("287기둥옆"))
                    {
                        cityArr.append(String(addrArr[1]))
                    }
                }
            }
            cityArr = removeDuplicate(cityArr)
            addrDict.updateValue(cityArr, forKey: stateStrArr[i])
            cityArr.removeAll()
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerView_State)
        {
            return addrDict.keys.count
        }
        else
        {
            //print(selectState)
            return addrDict[selectState]!.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerView_State)
        {
            return stateStrArr[row]
        }
        //return Array(addrDict)[row].key
        else
        {
            let cityArr = addrDict[selectState]
            
            return cityArr![row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerView_State)
        {
            print("row:\(row)")
            zcode = zcodeArr[row]
            selectState = stateStrArr[row]
            //selectCity =  Array(addrDict)[row].key
            //showPickerTF.text = Array(addrDict)[row].key
            print("selectState: \(selectState)")
        }
        else
        {
            let cityArr = addrDict[selectState]
            selectCity = cityArr![row]
            print("select city: \(selectCity)")
        }
    }

    // state text field
    @IBOutlet weak var showPickerTF: UITextField!
    // city text field
    @IBOutlet weak var showCityTF: UITextField!
   
    // 피커뷰
    let pickerView_State = UIPickerView()
    let pickerView_City = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
       
        makeAddrDictionary()
        showPickerTF.tintColor = .clear
        showCityTF.tintColor = .clear
        createStatePickerView()
        dismissStatePickerView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let animationView = AnimationView(name: "43293-cityscape") // AnimationView(name: "lottie json 파일 이름")으로 애니메이션 뷰 생성
        animationView.frame = CGRect(x: 0, y: 200, width: 435, height: 100) // 애니메이션뷰의 크기 설정
        //animationView.frame = self.view.bounds // 애니메이션뷰의 위치설정
        animationView.contentMode = .scaleAspectFill // 애니메이션뷰의 콘텐트모드 설정
            
        view.addSubview(animationView) // 애니메이션뷰를 메인뷰에 추가
        animationView.play() // 애니메이션뷰 실행
        animationView.loopMode = .loop // 무한 재생
    }
    
    func createStatePickerView() {
        // state
        pickerView_State.delegate = self
        pickerView_State.dataSource = self
        pickerView_State.backgroundColor = .white
        showPickerTF.inputView = pickerView_State
        // city
        pickerView_City.delegate = self
        pickerView_City.dataSource = self
        pickerView_City.backgroundColor = .white
        showCityTF.inputView = pickerView_City
    }
    
    func dismissStatePickerView() {
        // state
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBlue
        toolBar.isTranslucent = true
        let btnDone = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(onStatePickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onStatePickCancel))
        toolBar.setItems([btnCancel , space , btnDone], animated: true)   // 버튼추가
        toolBar.isUserInteractionEnabled = true
        showPickerTF.inputAccessoryView = toolBar
        // city
        let toolBar_city = UIToolbar()
        toolBar_city.sizeToFit()
        toolBar_city.backgroundColor = .systemBlue
        toolBar_city.isTranslucent = true
        let btnDone_city = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(onCityPickDone))
        let space_city = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel_city = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onCityPickCancel))
        toolBar_city.setItems([btnCancel_city , space_city , btnDone_city], animated: true)   // 버튼추가
        toolBar_city.isUserInteractionEnabled = true
        showCityTF.inputAccessoryView = toolBar_city
    }
    @objc func onStatePickDone() {
        showPickerTF.text = selectState
        showPickerTF.textAlignment = NSTextAlignment(.center)
        showPickerTF.resignFirstResponder()
        //selectState = ""
        //print("addrdict value: \(addrDict[selectState])")
    }
    @objc func onCityPickDone() {
        showCityTF.text = selectCity
        showCityTF.textAlignment = NSTextAlignment(.center)
        showCityTF.resignFirstResponder()
        bIsCityFilled = true
        //selectCity = ""
    }
    
    @objc func onStatePickCancel() {
        showPickerTF.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
        //selectState = ""
    }
    @objc func onCityPickCancel() {
        showCityTF.resignFirstResponder() // 피커뷰를 내림 (텍스트필드가 responder 상태를 읽음)
        //selectCity = ""
    }
    
    // 음성인식 코드
    // 도 음성인식 버튼
    @IBOutlet weak var stateTranscribeButton: UIButton!
    // 시 음성인식 버튼
    @IBOutlet weak var cityTranscribeButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    var bIsStateTranscribing = false
    var bIsCityTranscribing = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    //AVAudioEngine 인스턴스 사용하여 오디오를 오디오 버퍼로 스트리밍
    private let audioEngine = AVAudioEngine()
   
    @IBAction func toggleStateTranscribing(_ sender: Any) {
        if(!bIsStateTranscribing) {
            cityTranscribeButton.isEnabled = false
            try! startSession()
            bIsStateTranscribing = true
        }
        else {
            if audioEngine.isRunning {
                audioEngine.stop()
                speechRecognitionRequest?.endAudio()
                cityTranscribeButton.isEnabled = true
                bIsStateTranscribing = false
            }
            if let index = stateStrArr.firstIndex(of:self.myTextView.text) {
                showPickerTF.text = self.myTextView.text
                showPickerTF.textAlignment = NSTextAlignment(.center)
                self.pickerView_State.selectRow(index,inComponent:0,animated:true)
                self.zcode = zcodeArr[index]
                self.selectState = self.myTextView.text
            }
        }
    }
    @IBAction func toggleCityTranscribing(_ sender: Any) {
        if(!bIsCityTranscribing) {
            stateTranscribeButton.isEnabled = false
            try! startSession()
            bIsCityTranscribing = true
            bIsCityFilled = true
        }
        else {
            if audioEngine.isRunning {
                audioEngine.stop()
                speechRecognitionRequest?.endAudio()
                stateTranscribeButton.isEnabled = true
                bIsCityTranscribing = false
            }
            let cityArr = addrDict[selectState]
            if let index = cityArr!.firstIndex(of:self.myTextView.text) {
                showCityTF.text = self.myTextView.text
                showCityTF.textAlignment = NSTextAlignment(.center)
                self.pickerView_City.selectRow(index,inComponent:0,animated:true)
                self.selectCity = self.myTextView.text
            }
        }
    }
    
    func startSession() throws {
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else {
            fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed")
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var finished = false
            if let result = result {
                self.myTextView.text =
                    result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                //self.transcribeButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    func authorizeSR() {
        // 완료 핸들러로 지정된 클로저를 사용하여 SFSpeechRecognizer 클래스의 requestAuthorization 메소드를 호출헙니다.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // 이 핸들러에는 4개의 값( 권한부여,거부,제한 또는 결정되지 않음) 중 하나 일 수 있는 상태값이 전달됨
            // 그런다음 스위치문을 사용하여 상태를 평가하고 기록 버튼을 활성화하거나 해당 버튼에 실패 원인을 표시함
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.stateTranscribeButton.isEnabled = true
                    self.cityTranscribeButton.isEnabled = true
                    
                case .denied:
                    self.stateTranscribeButton.isEnabled = false
                    self.cityTranscribeButton.isEnabled = false
                    self.stateTranscribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                
                case .restricted:
                    self.stateTranscribeButton.isEnabled = false
                    self.cityTranscribeButton.isEnabled = false
                    self.stateTranscribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.stateTranscribeButton.isEnabled = false
                    self.cityTranscribeButton.isEnabled = false
                    self.stateTranscribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToNationMap" {
            if let mapController = segue.destination as? NationMapViewController  {
                beginParsing(zcode: zcode)
                print("zcode:\(zcode)")
                mapController.posts = posts
                mapController.statecity = selectState + " " + selectCity
                mapController.bIsCityFilled = bIsCityFilled
                mapController.cityArr = cityArr
            }
        }
    }


}
