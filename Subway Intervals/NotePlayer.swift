//
//  NotePlayer.swift
//  Subway Intervals
//
//  Created by Joel Davis on 5/29/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import Foundation
import AudioToolbox

class NoteInfo : NSObject
{
    var noteName : String = "C4"
    var freq: Double = 65.4063913251497
    var midiNote : Int = 36

    var sampleName: String?
    var isRealSample : Bool = false
    var sampleRealFreq: Double = 0.0
    var samplePitchShift: Double = 1.0
    

//    init( usingSample name : String, freq : Float, midiNote : Int, sampleName : String, sampleFreq : Float ) {
//        self.noteName = name
//        self.freq = freq
//        self.midiNote = midiNote
//        
//        self.sampleName = sampleName
//        self.sampleRealFreq = sampleFreq
//        self.samplePitchShift = freq/sampleFreq
//    }
    
    func useSample( sampleName : String, sampleFreq : Double )
    {
        self.sampleName = sampleName
        self.sampleRealFreq = sampleFreq
        self.samplePitchShift = freq / sampleFreq
        
        isRealSample = (sampleFreq == freq)
    }
    
    
}

class NotePlayer : NSObject
{
    static let sharedInstance = NotePlayer()
    var notes = [NoteInfo]( count:128, repeatedValue : NoteInfo() )
    
    func loadSamples () {
        var oal = OALSimpleAudio.sharedInstance()
        
        // These are the samples we have
        let samples : Set<String> = [
            "A0v10.wav",
            "C1v10.wav",
            "D#1v10.wav",
            "F#1v10.wav",
            "A1v10.wav",
            "A2v10.wav",
            "C2v10.wav",
            "D#2v10.wav",
            "F#2v10.wav",
            "A3v10.wav",
            "C3v10.wav",
            "D#3v10.wav",
            "F#3v10.wav",
            "A4v10.wav",
            "C4v10.wav",
            "D#4v10.wav",
            "F#4v10.wav",
            "A5v10.wav",
            "C5v10.wav",
            "D#5v10.wav",
            "F#5v10.wav",
            "A6v10.wav",
            "C6v10.wav",
            "D#6v10.wav",
            "F#6v10.wav",
            "A7v10.wav",
            "C7v10.wav",
            "D#7v10.wav",
            "F#7v10.wav",
            "C8v10.wav"
        ]

        let noteNames : [String] = [
            "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
        ]
        
        // http://subsynth.sourceforge.net/midinote2freq.html
        var a = 440.0 // a is 440 hz
        for midival in 0...127 {

            let noteName = noteNames[ midival % 12 ]
            let noteOctave = (midival / 12) + 1
            let filename = "\(noteName)\(noteOctave)v10.wav"
            
            var freq = (a / 32.0) * pow( 2, (Double(midival) - 9.0) / 12.0)
            println( "\(noteName)\(noteOctave) MIDI \(midival) freq \(freq)" )

            let info = NoteInfo()
            info.noteName = noteName
            info.freq = freq
            info.midiNote = midival

            if (samples.contains(filename))
            {
                info.useSample( filename, sampleFreq: freq )
                var oal = OALSimpleAudio.sharedInstance()
                oal.preloadEffect(info.sampleName );
            }
            
            notes[midival] = info
        }
        
        // Now go through and assign notes that lack samples to nearby ones
        for midival in 0...127
        {
            let info = notes[midival]
            if (info.sampleName == nil)
            {
                var bestDist = 128
                var bestNote : NoteInfo? = nil

                for nearVal in 0...127
                {
                    let nearNote = notes[nearVal]
                    if (nearNote.isRealSample)
                    {
                        let dist = abs(nearVal - midival)
                        if (dist < bestDist)
                        {
                            bestDist = dist
                            bestNote = nearNote
                        }
                    }
                }
                
//                println("Best Match \(bestNote?.midiNote) \(bestNote?.noteName)")
                let bestSample : String = (bestNote?.sampleName)!
                let bestSampleFreq : Double = (bestNote?.sampleRealFreq)!
                info.useSample( bestSample, sampleFreq:bestSampleFreq )
                
            }
        }
    }
    
    func playNote( midival : Int )
    {
        var oal = OALSimpleAudio.sharedInstance()
        let info = notes[midival]
        oal.playEffect( info.sampleName, volume: 1.0, pitch: Float(info.samplePitchShift), pan: 0.0, loop: false )
    }
    
}