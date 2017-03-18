//
//  ViewController.swift
//  ViewPractice
//
//  Created by 전한경 on 2016. 11. 27..
//  Copyright © 2016년 jeon. All rights reserved.
//

// hex code로 변환
extension UIColor {
    convenience init(hex: Int) {
        let r = hex / 0x10000
        let g = (hex - r*0x10000) / 0x100
        let b = hex - r*0x10000 - g*0x100
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UIToolbarDelegate,RECOBeaconManagerDelegate {

    
    //MARK: View Properties
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: BEACON Properties
    var firstPageSuccess : Int = 0
    
    let UUIDValue = "24DDF411-8CF1-440C-87CD-E368DAF9C93E"
    
    let beaconManager : RECOBeaconManager = RECOBeaconManager()
    
    var oneRegion : RECOBeaconRegion = RECOBeaconRegion(proximityUUID: UUID(uuidString: "24DDF411-8CF1-440C-87CD-E368DAF9C93E"),major: RECOBeaconMajorValue("503")!,identifier: "RECOBeaconRegion-%d")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setToolBar()
        
        //MARK : BEACON Init
        beaconManager.delegate = self
        
        // 6.3 위치 서비스 권한 요청을 위한 코드를 입력합니다.
        beaconManager.requestAlwaysAuthorization()
        
        let url: URL = URL(string: "http://smu.evxev.com/list/p/all")!
        let requestObj: URLRequest = URLRequest(url: url)
        
        
        webView?.delegate = self
        
        webView.loadRequest(requestObj)
        
        webView.scrollView.bounces = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("WILL")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DID")
    }
    
    @IBAction func leftBarItemClicked(_ sender: UIBarButtonItem) {
         print("leftBarItemClicked")
        login()
    }

    
    @IBAction func rightBarItemClicked(_ sender: UIBarButtonItem) {
        if(RECOBeaconManager.isRangingAvailable()){
            print("rightBarItemClicked")
            startMonitoringAndRanging()
        }
        
    }
    func startMonitoringAndRanging(){
        
        //일단 하나로 갑니다.
        print("start monitoring and ranging")
        beaconManager.startMonitoring(for: oneRegion)
        
        beaconManager.startRangingBeacons(in: oneRegion)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setToolBar(){
        let queaColor = UIColor(hex : 0xF06146)
         UIToolbar.appearance().backgroundColor = queaColor
        
    }
    
    //MARK: Reco Manager Functions
    
    //권한이 변경되었을 때 알림을 주는 메소드를 작성합니다.
    
    func recoManager(_ manager: RECOBeaconManager!, didChange status: CLAuthorizationStatus) { NSLog("didChangeAuthorizationStatus: status – \(status.rawValue)"); }
    
    func recoManager(_ manager: RECOBeaconManager!, monitoringDidFailFor region: RECOBeaconRegion!, withError error: NSError!) {
        print("monitor fail",error)
        print("region in monitor clause",region)
    }
    func recoManager(_ manager: RECOBeaconManager!, rangingBeaconsDidFailFor region: RECOBeaconRegion!, withError error: NSError!) {
        print("range fail",error)
        print("region in range clause",region)
    }
    
    @objc(recoManager:didStartMonitoringForRegion:)
    func recoManager(_ manager: RECOBeaconManager!, didStartMonitoringFor didstartMonitoringForRegion: RECOBeaconRegion!) { NSLog("start monitoring"); }
    
    
    //swift 3으로 넘어오기전 코드
    //func recoManager(_ manager: RECOBeaconManager!, didRangeBeacons:[AnyObject], in inRegion: RECOBeaconRegion!)
    //
    
    @objc(recoManager:didRangeBeacons:inRegion:)
    func recoManager(_ manager: RECOBeaconRegion?, didRangeBeacons:[AnyObject], in region: RECOBeaconRegion!)
        {
        
        NSLog("ranging : \(didRangeBeacons.count)beacons in here")
        
        
        if(didRangeBeacons.count>0){
        
        let beacon1 = didRangeBeacons[0] as! RECOBeacon
        
        if(didRangeBeacons.count>0 && beacon1.major.description == "503" && beacon1.minor.description == "20668"){
            
            print("503-20668 entered")
            
            
            loadWebViewAlert("http://www.google.com")
            
            
            beaconManager.stopRangingBeacons(in: oneRegion)
            beaconManager.stopMonitoring(for: oneRegion)

            firstPageSuccess = 1
            
            
        }
        
        else{
            print("관리자가 지정한 비콘이 존재하지 않습니다.")
            showToast("관리자가 지정한 비콘이 존재하지 않습니다.")
            
            beaconManager.stopRangingBeacons(in: oneRegion)
            beaconManager.stopMonitoring(for: oneRegion)
            
            firstPageSuccess = 1
        }
        
        
        }else{
        print("근처에 정상적인 비콘이 존재하지 않습니다")
        showToast("근처에 정상적인 비콘이 존재하지 않습니다")
            beaconManager.stopRangingBeacons(in: oneRegion)
            beaconManager.stopMonitoring(for: oneRegion)
        }
        
        }
        
    
    
    
    
    
    //MARK: BEACON Alert
    
    func loadWebViewAlert(_ urlForWebView:String){
        
        let ac = UIAlertController(title:"이동하기",message:"제공 받으신 URL로 이동하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            //Do some stuff
            print("cancel button clicked")
            
        }
        
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "이동", style: .default) { action -> Void in
            //Do some other stuff
            
            
            let url: URL = URL(string: urlForWebView)!
            let requestObj: URLRequest = URLRequest(url: url)
            
            
            self.webView.loadRequest(requestObj)
            
        }
        ac.addAction(cancelAction)
        ac.addAction(nextAction)
        
        
        
        self.present(ac, animated: true, completion: nil)
        
    }
    

    
    
    func showToast(_ msg:String) {
        let toast = UIAlertController()
        toast.message = msg;
        
        self.present(toast, animated: true, completion: nil)
        let duration = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: duration) {
            toast.dismiss(animated: true, completion: nil)
        }
    }


    //MARK: WebView Attribute
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        print("LOAD START\n")
        
        //loading start
        JeonProgressView.shared.showProgressView(view)
       

    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("LOAD FIN\n")
        //loading finish
        JeonProgressView.shared.hideProgressView()
        
        if(firstPageSuccess == 0){
            startMonitoringAndRanging()
        }
    }
    
    
    //MARK: Server 
    
    func login(){
        let parameters = ["userId":"20161129","name":"tonight","platform":"0"]
        
        
        let manager = AFHTTPSessionManager()
        
        
        manager.get("http://52.79.152.130/TicSongServer/login.do",
                    parameters: parameters,
                    progress: nil,
                    success: { (task: URLSessionDataTask, responseObject: Any?) in
                        //print("\(responseObject)")
                        print(responseObject!)
                        
                        //# JSONObject로 받아와서 파싱하기!!
                        var jsonDict: [AnyHashable: Any] = (responseObject as?[AnyHashable: Any])!
                        //let res: String = "\(jsonDict["name"])"
                        //let res = jsonDict["name"]!
                        
                        print("\(jsonDict["timestamp"]!)")
                        //print(res.description)
                        //print(task.response)
                        
            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                print("\(error)")}
        )
        
    }

    


}

