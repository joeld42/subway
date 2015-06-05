//
//  FirstViewController.swift
//  Subway Intervals
//
//  Created by Joel Davis on 5/28/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func onTest(sender: AnyObject)
    {
        var oal = OALSimpleAudio.sharedInstance()
        oal.playEffect( "whole_step.aiff" )
    }
    
    @IBAction func onTestNote(sender: AnyObject) {
        var button = sender as! UIButton

        NotePlayer.sharedInstance.playNote( button.tag )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

