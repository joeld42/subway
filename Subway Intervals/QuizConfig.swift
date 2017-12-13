//
//  QuizConfig.swift
//  Subway Intervals
//
//  Created by Joel Davis on 5/31/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import Foundation

class QuizConfig
{
    // for presets
    var presetLevel = 0  // 0 = no preset
    var presetTitle : String = "Custom"
    var presetDesc : String = ""
    
    var askInterval = [ Bool ]( repeating: true, count: 12 )
    
    
}
