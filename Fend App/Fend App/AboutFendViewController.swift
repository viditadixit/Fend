//
//  AboutFendViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 4/9/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit

class AboutFendViewController: UIViewController {
    
    @IBOutlet weak var aboutFendTitle: UITextView!
    @IBOutlet weak var aboutFend: UITextView!
    @IBOutlet weak var ourTeamTitle: UITextView!
    @IBOutlet weak var vidita: UITextView!
    @IBOutlet weak var katelyn: UITextView!
    @IBOutlet weak var kirtana: UITextView!
    @IBOutlet weak var jasmin: UITextView!
    @IBOutlet weak var sonia: UITextView!
    @IBOutlet weak var jj: UITextView!
    @IBOutlet weak var ourTeam: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        aboutFendTitle.font = UIFont(name: "Nunito-Regular", size: 19)
        aboutFend.font = UIFont(name: "Nunito-Regular", size: 17)
        ourTeamTitle.font = UIFont(name: "Nunito-Regular", size: 19)
        vidita.font = UIFont(name: "Nunito-Regular", size: 15)
        katelyn.font = UIFont(name: "Nunito-Regular", size: 15)
        kirtana.font = UIFont(name: "Nunito-Regular", size: 15)
        jasmin.font = UIFont(name: "Nunito-Regular", size: 15)
        sonia.font = UIFont(name: "Nunito-Regular", size: 15)
        jj.font = UIFont(name: "Nunito-Regular", size: 15)
        ourTeam.font = UIFont(name: "Nunito-Regular", size: 17)
    }
}
