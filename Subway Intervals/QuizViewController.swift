//
//  QuizViewController
//  Subway Intervals
//
//  Created by Joel Davis on 5/28/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import UIKit

enum QuizState {
    case Paused, Question, WaitForAnswer
}

class QuizViewController: UIViewController {

    static let intervalNames : [String] = [
        "Unison",
        "Half Step",
        "Whole Step",
        "Minor Third",
        "Major Third",
        "Fourth",
        "Tritone",
        "Fifth",
        "Minor Sixth",
        "Major Sixth",
        "Minor Seventh",
        "Major Seventh",
        "Octave"
    ]
    
    @IBOutlet weak var playButton: UIButton!
    var isPlaying : Bool = false
    var state : QuizState = .Paused
    
    var generator = QuizGenerator()
    
    var currentAnswer : Int = 0
    
    var firstNote = 38;
    var noteCountdown = 0;
    
    var simul = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTestQuestion(sender: AnyObject)
    {
        let app = UIApplication.sharedApplication()
        if (state == .Paused)
        {
            playButton.setTitle("Stop", forState: UIControlState.Normal )
            state = .Question
            self.quizUpdate()
            
            app.idleTimerDisabled = true
        } else {
            playButton.setTitle("Start", forState: UIControlState.Normal )
            state = .Paused
            
            app.idleTimerDisabled = false
        }
    }
    
    func askQuestion()
    {
        
        if (noteCountdown == 0)
        {
            firstNote = 30 + Int(arc4random_uniform(28))
            noteCountdown = 5
            
            simul = arc4random_uniform(2)==1

        } else {
            noteCountdown -= 1
        }
        
        var secondNote = firstNote + Int(arc4random_uniform(12))
        let player = NotePlayer.sharedInstance
        
        currentAnswer = secondNote - firstNote
        
//        println("Simul = \(simul) countdown \(noteCountdown)")
        
        player.playNote(firstNote)
        if (simul)
        {
            player.playNote(secondNote)
        }
        else
        {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                player.playNote(secondNote)
            }
        }
        
    }
    
    func sayAnswer()
    {
        let currInterval = QuizViewController.intervalNames[currentAnswer];
        let currSample = self.sampleNameFromIntervalName( currInterval )
        println( "ANSWER: \(currInterval) (\(currSample))")
        
        var oal = OALSimpleAudio.sharedInstance()
        oal.playEffect( currSample )
    }
    
    func sampleNameFromIntervalName( intervalName : String) -> String
    {
        return intervalName.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil) + ".aiff"
    }
    
    func quizUpdate()
    {
        let nextUpdateTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC)))
        
        switch (state)
        {
        case .Paused:
            // Don't update
            return
            
        case .Question:
            self.askQuestion()
            state = .WaitForAnswer
            
        case .WaitForAnswer:
            self.sayAnswer()
            state = .Question
        }

        dispatch_after(nextUpdateTime, dispatch_get_main_queue()) {
            self.quizUpdate()
        }

    }

}

