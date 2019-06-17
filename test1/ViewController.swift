//
//  ViewController.swift
//  test1
//
//  Created by kpugame on 2019. 6. 3..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var graphVIew: GraphView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    
    // 음성인식 객체
    // 실시간으로 말하기 기능을 구현하려면 앱에서 SFSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest
    // 및 SFSpeechRecognitionTask 클래스의 인스턴스가 필요합니다.
    // 영어한글 모두 인식하고 싶다면
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    // 영어만 인식하고 싶다면
    //private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    // AVAudioEngine 인스턴스를 사용하여 오디오를 오디오 버퍼로 스트리밍
    private let audioEngine = AVAudioEngine()
    
    // 음성인식을 수행하는 메소드 호출은 예외를 throw 할 가능성 있음
    func startSession() throws {
        // startSession 메서드 내에서 수행되는 첫 번째 작업은 이전 인식 작업이 실행 중인지 확인하고, 그렇지 않으면 작업을 취소하는 것.
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        // 또한 이 메서드는 오디오 녹음 세션을 구성
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // 이전에 선언 된 speechRecognitionRequest 변수에 SFSpeechAudioBufferRecognitionRequest 개체를 할당해야합니다.
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 그런 다음 SFSpeechAudioBufferRecognitionRequest 개체가 성공적으로 만들어졌는지 확인하기 위한 테스트가 수행됩니다.
        // 생성이 실패한 경우 예외가 throw됩니다.
        guard let recognitionRequest = speechRecognitionRequest else {
            fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed")
        }
        
        // 오디오 엔진의 inputNode에 대한 참조를 가져 와서 상수에 할당해야 합니다.
        // 입력 노드를 사용할 수 없는 경우 치명적인 오류가 발생합니다.
        let inputNode = audioEngine.inputNode // else{ fatalErroe("Audio engine has no input node") }
        // recognitionRequest 인스턴스는 부분 결과를 반환하도록 구성되므로 음성 오디오가 버퍼에 도착할 때 계속해서 녹음을 수행할 수 있습니다.
        // 이 속성이 설정되지 않은 경우 앱은 녹음 과정을 시작하기 전에 오디오 세션이 끝날 때까지 대기합니다.
        recognitionRequest.shouldReportPartialResults = true
        
        // 인식 작업이 초기화됩니다.
        // 인식 요청 객체로 초기화된 인식 태스크를 생성합니다.
        // 클로저는 완성 된 텍스트의 각 블록이 완료될 때 반복적으로 호출되는 완료 핸들러로 지정됩니다.
        // 처리기가 호출될 때마다 오류 개체와 함께 최신 버전의 텍스트가 포함된 결과 개체가 전달됩니다.
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            var finished = false
            // 결과 객체의 isFinal 속성이 false (라이브 오디오가 여전히 버퍼로 스트리밍됨을 나타냄) 오류가 발생하지 않는 한 텍스트는 텍스트 보기에 표시됩니다.
            if let result = result {
                self.myTextView.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            // 그렇지 않으면 오디오 엔진이 중지되고 탭이 오디오 노드에서 제거되고 인식 요철 및 인식 작업 객체가 nil로 설정됩니다.
            // 기록 단추는 다음 세션 준비를 위해 사용할 수도 있습니다.
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.transcribeButton.isEnabled = true
            }
        }
        
        // 인식 작업을 구성하고 나면 이 단계에서 남은 것은 오디오 엔진의 입력 노드에 탭을 설치한 다음 실행중인 엔진을 시작하는 것.
        // inputNode 객체의 installTap 메서드는 클로저를 완료 핸들러로 사용합니다.
        // 이 핸들러의 코드는 호출될 때 마다 최신 오디오 버퍼를 speechRecognitionRequest 객체에 추가하기만 하면 자동으로 녹음되고
        // 텍스트 인식 뷰에 표시되는 음성 인식 작업의 완료 핸들러로 전달됩니다.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        
        // 위쪽에서 아래쪽으로 stardustView 파티클 생성
        let startX: CGFloat = transcribeButton.center.x
        let startY: CGFloat = transcribeButton.center.y
        let endY: CGFloat = transcribeButton.center.y + 300
        
        let stars = StardustView(frame: CGRect(x: startX, y: startY, width: 10, height: 10))
        self.view.addSubview(stars)
        self.view.sendSubviewToBack(stars)
        
        UIView.animate(withDuration: 3.0,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        stars.center = CGPoint(x: startX, y: endY)
        },
                       completion: { (value: Bool) in
                        stars.removeFromSuperview()
        })
        
        try! startSession()
    }
    @IBAction func stopTranscribing(_ sender: Any) {
        // 오디오 엔진을 중지하고 다음 세션에 사용할 준비가 된 버튼의 상태를 구성
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
            
            // 위쪽에서 아래쪽으로 stardustView 파티클 생성
            let startX: CGFloat = stopButton.center.x
            let startY: CGFloat = stopButton.center.y
            let endY: CGFloat = stopButton.center.y + 300
            
            let stars = StardustView(frame: CGRect(x: startX, y: startY, width: 10, height: 10))
            self.view.addSubview(stars)
            self.view.sendSubviewToBack(stars)
            
            UIView.animate(withDuration: 3.0,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            stars.center = CGPoint(x: startX, y: endY)
            },
                           completion: { (value: Bool) in
                            stars.removeFromSuperview()
            })
        }
        
        // 음성인식한 내용을 pickerView에 반영
        switch (self.myTextView.text) {
        case "강남구" :
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
            break
        case "강동구" :
            self.pickerView.selectRow(1, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 1, inComponent: 0)
            break
        case "강북구" :
            self.pickerView.selectRow(2, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 2, inComponent: 0)
            break
        case "강서구" :
            self.pickerView.selectRow(3, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 3, inComponent: 0)
            break
        case "관악구" :
            self.pickerView.selectRow(4, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 4, inComponent: 0)
            break
        case "광진구" :
            self.pickerView.selectRow(5, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 5, inComponent: 0)
            break
        case "구로구" :
            self.pickerView.selectRow(6, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 6, inComponent: 0)
            break
        case "금천구" :
            self.pickerView.selectRow(7, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 7, inComponent: 0)
            break
        case "노원구" :
            self.pickerView.selectRow(8, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 8, inComponent: 0)
            break
        case "도봉구" :
            self.pickerView.selectRow(9, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 9, inComponent: 0)
            break
        case "동대문구" :
            self.pickerView.selectRow(10, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 10, inComponent: 0)
            break
        case "동작구" :
            self.pickerView.selectRow(11, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 11, inComponent: 0)
            break
        case "마포구" :
            self.pickerView.selectRow(12, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 12, inComponent: 0)
            break
        case "서대문구" :
            self.pickerView.selectRow(13, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 13, inComponent: 0)
            break
        case "서초구" :
            self.pickerView.selectRow(14, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 14, inComponent: 0)
            break
        case "성동구" :
            self.pickerView.selectRow(15, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 15, inComponent: 0)
            break
        case "성북구" :
            self.pickerView.selectRow(16, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 16, inComponent: 0)
            break
        case "송파구" :
            self.pickerView.selectRow(17, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 17, inComponent: 0)
            break
        case "양천구" :
            self.pickerView.selectRow(18, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 18, inComponent: 0)
            break
        case "영등포구" :
            self.pickerView.selectRow(19, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 19, inComponent: 0)
            break
        case "용산구" :
            self.pickerView.selectRow(20, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 20, inComponent: 0)
            break
        case "은평구" :
            self.pickerView.selectRow(21, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 21, inComponent: 0)
            break
        case "종로구" :
            self.pickerView.selectRow(22, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 22, inComponent: 0)
            break
        case "중구" :
            self.pickerView.selectRow(23, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 23, inComponent: 0)
            break
        case "중랑구" :
            self.pickerView.selectRow(24, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 24, inComponent: 0)
            break
        default: break
        }
    }
    
    func authorizeSR() {
        // 완료 핸들러로 지정된 클로저를 활용하여 SFSpeechRecognizer 클래스의 requestAuthorization 메소드를 호출합니다.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // 이 핸들러에는 4개의 값 (권한 부여, 거부, 제한 또는 결정되지 않음) 중 하나일 수 있는 상태 값이 전달됩니다.
            // 그런 다음 switch 문을 사용하여 상태를 평가하고 기록 버튼을 활성화하거나 해당 버튼에 실패 원인을 표시합니다.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true
                    
                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
            
        }
    }
    
    // Donw 버튼을 누르면 동작하는 unwind 메소드
    // 아무 동작도 하지않지만 이 메소드가 있어야 PharmacyTableViewController에서 unwind 연결이 가능함
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue){
        
    }
    
    var pickerDataSource = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구",
                            "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구",
                            "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
    
    // Q0 = 시
    // Q1 = 구
    // QT = 월~일요일, 공휴일 1~8
    // QN = 기관명
    // PageNo = 페이지번호
    // nomOfRows = 목록건수
    var url : String = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=oke9ab6Ut5h1Rd4v1PH2wxz%2BPER64u1msAK%2F5tjhvpPOg6j1zRXxFQsP8lkgX%2B1p8yHZ%2Bn5vqG36Au66Lqft0w%3D%3D&Q0="
    var sgguCd : String = "강남구"
    
    // pickerView의 컴포넌트 개수 = 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerView의 각 컴포넌트에 대한 row의 개수 = pickerDataSource 배열 원소 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    // pickerView의 주어진 컴포넌트/row에 대한 데이터 = pickerDataSource 배열의 원소
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    // pickerView의 row 선택 시 sgguCd를 변경
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            sgguCd = "강남구"
        } else if row == 1 {
            sgguCd = "강동구"
        } else if row == 2 {
            sgguCd = "강북구"
        } else if row == 3 {
            sgguCd = "강서구"
        } else if row == 4 {
            sgguCd = "관악구"
        } else if row == 5 {
            sgguCd = "광진구"
        } else if row == 6 {
            sgguCd = "구로구"
        } else if row == 7 {
            sgguCd = "금천구"
        } else if row == 8 {
            sgguCd = "노원구"
        } else if row == 9 {
            sgguCd = "도봉구"
        } else if row == 10 {
            sgguCd = "동대문구"
        } else if row == 11 {
            sgguCd = "동작구"
        } else if row == 12 {
            sgguCd = "마포구"
        } else if row == 13 {
            sgguCd = "서대문구"
        } else if row == 14 {
            sgguCd = "서초구"
        } else if row == 15 {
            sgguCd = "성동구"
        } else if row == 16 {
            sgguCd = "성북구"
        } else if row == 17 {
            sgguCd = "송파구"
        } else if row == 18 {
            sgguCd = "양천구"
        } else if row == 19 {
            sgguCd = "영등포구"
        } else if row == 20 {
            sgguCd = "용산구"
        } else if row == 21 {
            sgguCd = "은평구"
        } else if row == 22 {
            sgguCd = "종로구"
        } else if row == 23 {
            sgguCd = "중구"
        } else if row == 24 {
            sgguCd = "중랑구"
        }
    }
    
    // prepare 메소드는 segue 실행될 때 호출되는 메소드
    // id를 segueToTableView로 설정
    // PharmacyTableViewController에 url정보를 전달하기 위해 먼저 UINavigationController를
    // destination으로 설정한 후 PharmacyTableViewController를 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let pharmacyTableViewController = navController.topViewController as? PharmacyTableViewController {
                    var url2 : String = "서울특별시&Q1=" + sgguCd
                    let escapedUrl = url2.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    pharmacyTableViewController.url = url + escapedUrl! + "&pageNo=1&numOfRows=1000"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSR()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }


}

