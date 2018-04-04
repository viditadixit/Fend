//
//  BTViewController.swift
//  Fend App
//
//  Created by Ziyue Zhang on 2/19/18.
//  Copyright © 2018 Fend. All rights reserved.
//
import UIKit
import CoreBluetooth
import UserNotifications
import CoreLocation

let microbitCBUUID = CBUUID(string: "0xA000")
var HardwareName = ""
var selectionFlag = 0

//main bluetooth controller class
class BTViewController: UIViewController, UITableViewDelegate, UNUserNotificationCenterDelegate {
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var testFend: CBPeripheral!
    let locationManager = CLLocationManager()
    
    var theftLat: Double!
    var theftLong: Double!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        let currentItem = currentCell.textLabel!.text
        HardwareName = currentItem ?? ""
        selectionFlag = 1

        for p in peripherals {
            if p.name == HardwareName {
                print("Found the fend thing")
                testFend = p
                testFend.delegate = self
                centralManager?.stopScan()
                centralManager?.connect(testFend)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("got it")
        
        let reportViewController = ReportViewController()
        reportViewController.theftLat = self.theftLat
        reportViewController.theftLong = self.theftLong
        
        if let navigator = navigationController {
            navigator.pushViewController(reportViewController, animated: true)
        }
    }
}

extension BTViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: [microbitCBUUID])
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        let alert = UIAlertController(title: "Connection Successful", message: "You are connected to fend!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        testFend.discoverServices(nil)
    }
}

extension BTViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
            }
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let newValue = characteristic.value
        if let unwrapped = newValue {
            let a = [UInt8] (unwrapped)
            print (a)
            let b = UInt8(1)
            if a[0] != b {
                print ("Button Pressed!")
                self.theftLat = getLocation().lat;
                self.theftLong = getLocation().long;
                
                //print("latitude: \(latitude)")
                //print("longitude: \(longitude)")
                
                //sendAlert()
                
                let content = UNMutableNotificationContent()
                content.title = "Theft Alert!"
                content.subtitle = "Check your backpack"
                //content.userInfo = ["latitude": latitude, "longitude": longitude];
                content.badge = 1
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                let request = UNNotificationRequest(identifier: "backpackbreach", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        print("Notified!")
    }
}

extension BTViewController: CLLocationManagerDelegate {
    func getLocation() -> (lat: Double, long: Double){
        var currentLocation = CLLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location!
        print("latitude: \(currentLocation.coordinate.latitude)")
        print("longitude: \(currentLocation.coordinate.longitude)")
        return(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
    }
    
    func sendAlert(){
        let coordinates = getLocation()
        let alert = UIAlertController(title: "Your backpack is being broken into!", message: "Location coordinates:\n Latitude: \(coordinates.lat)\n Longitude: \(coordinates.long)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "K cool", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "False Alarm!", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension BTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
}

