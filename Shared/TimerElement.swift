//
//  TimerElement.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/17.
//

import Foundation

class TimerElement{
    var name: String = ""
    var seconds: Int = 1
    
    init(){
        self.name = ""
        self.seconds = 1
    }
    
    init(name: String, seconds: Int){
        self.name = name
        self.seconds = seconds
    }
}
