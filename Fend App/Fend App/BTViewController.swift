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

//main bluetooth controller class
class BTViewController: UIViewController {
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var testFend: CBPeripheral!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
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
        if peripheral.name == "testFend" {
            print("Found the fend thing")
            testFend = peripheral
            testFend.delegate = self
            centralManager?.stopScan()
            centralManager?.connect(testFend)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
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
                getLocation()
                sendAlert()
                let content = UNMutableNotificationContent()
                content.title = "SOMEONE IS OPENING YOUR BACKPACK"
                content.subtitle = "Your backpack is in troubleeeeeee"
                content.body = "seriously go check your backpack now"
                content.badge = 1
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
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
        var locationManager = CLLocationManager()
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
