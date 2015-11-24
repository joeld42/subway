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
//        var oal = OALSimpleAudio.sharedInstance()
//        oal.playEffect( "whole_step.aiff" )
        
        // SIGNAL GENERATOR!
        //    __block float frequency = 2000.0;
        //    __block float phase = 0.0;
        //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
        //     {
        //
        //         float samplingRate = wself.audioManager.samplingRate;
        //         for (int i=0; i < numFrames; ++i)
        //         {
        //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
        //             {
        //                 float theta = phase * M_PI * 2;
        //                 data[i*numChannels + iChannel] = sin(theta);
        //             }
        //             phase += 1.0 / (samplingRate / frequency);
        //             if (phase > 1.0) phase = -1;
        //         }
        //     }];
    }
    
    @IBAction func onTestNote(sender: AnyObject) {
        let button = sender as! UIButton

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

