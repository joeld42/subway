//
//  QuizViewController
//  Subway Intervals
//
//  Created by Joel Davis on 5/28/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import UIKit

enum QuizState {
    case paused, question, waitForAnswer
}

enum QuestionType : UInt32 {
    case intervalStep, intervalSimul, noteName
    
    static func randomQuestionType() -> QuestionType {
        // find the maximum enum value
//        var maxValue: UInt32 = 0
//        maxValue += 1;
//        while let _ = self.init(rawValue: maxValue) {}
        
        // pick and return a new value
        //FIXME
        let rand = arc4random_uniform(3)
        return self.init(rawValue: rand)!
    }
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
    
    static let intervalAbbr : [String] = [
        "P1",
        "m2",
        "M2",
        "m3",
        "M3",
        "P4",
        "Tt",
        "P5",
        "m6",
        "M6",
        "m7",
        "M7",
        "P8"
    ]

    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var isPlaying : Bool = false
    var state : QuizState = .paused
    
    var generator = QuizGenerator()
    
    // Answer for interval questions
    var currentAnswer : Int = 0
    
    // Anser for note name questions
    var currentAnswerNoteNameRoot : Int = 0
    var currentAnswerNoteName : Int = 0
    
    var firstNote = 38;
    var noteCountdown = 0;
    
    var qtype : QuestionType = .intervalStep
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTestQuestion(_ sender: AnyObject)
    {
        print("On Test Question...");
        
        let app = UIApplication.shared
        if (state == .paused)
        {
            print("was paused, new state is question");
            playButton.setTitle("Stop", for: UIControlState() )
            state = .question
            self.quizUpdate()
            
            app.isIdleTimerDisabled = true
        }
        else
        {
            print("was playeing, new state is paused");
            playButton.setTitle("Start", for: UIControlState() )
            state = .paused
            
            app.isIdleTimerDisabled = false
        }
    }
    
    func askQuestion()
    {
        
        if (noteCountdown == 0)
        {
            firstNote = 30 + Int(arc4random_uniform(28))
            noteCountdown = 5
            
            qtype = QuestionType.randomQuestionType();
            
            // DBG
            //qtype = QuestionType.noteName;

        } else {
            noteCountdown -= 1
        }
        
        let secondNote = firstNote + Int(arc4random_uniform(13))
        _ = NotePlayer.sharedInstance
        
        currentAnswer = secondNote - firstNote
        
        print("qtype = \(qtype) countdown \(noteCountdown)")
        
        if (qtype == .noteName)
        {
            currentAnswerNoteNameRoot = firstNote
            currentAnswerNoteName = secondNote
            
            let currInterval = QuizViewController.intervalNames[currentAnswer];
            let currAbbr = QuizViewController.intervalAbbr[currentAnswer];
            
            promptLabel.text = "\(currInterval) above NOTE";
            answerLabel.text = "?"

            let currSample = self.sampleNameFromIntervalName( currInterval )
            let sampleDuration = self.durationForIntervalSample( currSample ) - 0.25 // subtract a little time to get a smoother overlap
            playSampleAfterDelay( currSample, delayTimeSec: 0.0 );
            playSampleAfterDelay( "above.aiff", delayTimeSec: sampleDuration  );
            playNoteNameAfterDelay( firstNote, noteValue: firstNote, delayTimeSec: sampleDuration + 0.66 ) // length of "after" sample
        }
        else
        {
            promptLabel.text = "Identify the Interval...";
            answerLabel.text = "?";

            // Interval, step or simul
            var delayTimeSec = 0.5
            if (qtype == .intervalSimul)
            {
                delayTimeSec = 0.01
            }

            playNoteAfterDelay( firstNote, delayTimeSec: 0.0 )
            playNoteAfterDelay( secondNote, delayTimeSec: delayTimeSec )
        }
        
    }
    
    func playNoteNameAfterDelay( _ rootValue : Int, noteValue : Int, delayTimeSec : Double )
    {
        let player = NotePlayer.sharedInstance
        let delayTime = DispatchTime.now() + Double(Int64(delayTimeSec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            player.playNoteName( rootValue, midival: noteValue );
        }
    }

    
    func playSampleAfterDelay( _ sampleName : String, delayTimeSec : Double )
    {
        let oal = OALSimpleAudio.sharedInstance()
        let delayTime = DispatchTime.now() + Double(Int64(delayTimeSec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        print("playSampleAfterDelay: \(sampleName) delay \(delayTime)" )
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            oal?.playEffect( sampleName )
        }
    
    }
    
    func playNoteAfterDelay( _ noteValue : Int, delayTimeSec : Double )
    {
        let player = NotePlayer.sharedInstance
        let delayTime = DispatchTime.now() + Double(Int64(delayTimeSec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            player.playNote(noteValue)
        }
    }
    
    func sayAnswer()
    {
        if (qtype == .noteName)
        {
            // Note name question
            let player = NotePlayer.sharedInstance
            print("Say note names: \(currentAnswerNoteNameRoot) \(currentAnswerNoteName)")
            player.playNoteName( currentAnswerNoteNameRoot, midival: currentAnswerNoteName )
        }
        else
        {
            // Interval question
            let currInterval = QuizViewController.intervalNames[currentAnswer];
            let currAbbr = QuizViewController.intervalAbbr[currentAnswer];
            
            answerLabel.text = currAbbr;
            promptLabel.text = currInterval;
            
            let currSample = self.sampleNameFromIntervalName( currInterval )
            print( "ANSWER: \(currInterval) (\(currSample))")

            let oal = OALSimpleAudio.sharedInstance()
            oal?.playEffect( currSample )
        }
    }
    
    func sampleNameFromIntervalName( _ intervalName : String) -> String
    {
        return intervalName.lowercased().replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil) + ".aiff"
    }
    
    func durationForIntervalSample( _ intervalSampleName : String ) -> Double
    {
        // from getduration.py script
        let intervalDurations = [
            "unison.aiff" :  0.746077,
            "half_step.aiff" :  0.838367,
            "whole_step.aiff" :  0.841361,
            "minor_third.aiff" :  1.051610,
            "major_third.aiff" :  1.091655,
            "fourth.aiff" :  0.628980,
            "tritone.aiff" :  0.939546,
            "fifth.aiff" :  0.685397,
            "minor_sixth.aiff" :  1.110794,
            "major_sixth.aiff" :  1.165533,
            "minor_seventh.aiff" :  1.087120,
            "major_seventh.aiff" :  1.104444,
            "octave.aiff" :  0.773424 ];
        
        return intervalDurations[ intervalSampleName ]!
    }
    
    func quizUpdate()
    {
        print( "In quizUpdate...");
        
        var updateTimeSec = 2.5;
        if ((qtype == .noteName) && (state == .question))
        {
            // More time for the "note name" prompt...
            updateTimeSec = 4.5;
        }
        let nextUpdateTime = DispatchTime.now() + Double(Int64(updateTimeSec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        switch (state)
        {
        case .paused:
            // Don't update
            print("is paused, no update...");
            return
            
        case .question:
            print("is question, will wait for answer...")
            self.askQuestion()
            state = .waitForAnswer
            
        case .waitForAnswer:
            print("is waitForAnswer, will sayAnswer")
            self.sayAnswer()
            state = .question
        }

        DispatchQueue.main.asyncAfter(deadline: nextUpdateTime) {
            self.quizUpdate()
        }

    }

}

