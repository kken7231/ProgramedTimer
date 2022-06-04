//
//  kTimer.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/04/23.
//

import SwiftUI

class kTimer: ObservableObject, Equatable{
    private (set) var timer : Timer?
    var id: String = ""
    @Published private (set) var initial_seconds: Int = 0
    @Published private (set) var remained_round: Int = 0
    private var fireDate: Date = Date()
    private var leftSec: TimeInterval = 0.0
    
    
    
    var seconds: Int{
        get{
            return remained_round / 2
        }
        set(s){
            print("seconds set")
            remained_round = s*2
            initial_seconds = s
            print("remained_round, initial_seconds :\(remained_round), \(initial_seconds)")
        }
    }
    
    var isAllowed: Bool = false
    @Published var isFinished: Bool = false
    private var isTicking: Bool = false
    
    
    static func == (lhs: kTimer, rhs: kTimer) -> Bool {
        return lhs.id == rhs.id
    }

    @objc private func interval_func() {
        remained_round -= 1
        if(remained_round <= 0){
            self.finished()
        }
    }
        
    
    func start(){
        print("start")
        /*
        timer = Timer.scheduledTimer(timeInterval:0.5,
                                     target: self,
                                     selector:#selector(self.interval_func),
                                     userInfo:nil,
                                     repeats:true)*/
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(self.interval_func), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        isTicking = true
    }
    
    func stop(){
        print("stop")
        if(timer != nil){
            fireDate = timer!.fireDate
            timer!.invalidate()
            isTicking = false
            leftSec = fireDate.timeIntervalSinceNow
        }
    }
    
    func restart(){
        print("restart")
        if(leftSec != 0){
            /*
            timer = Timer.scheduledTimer(timeInterval:leftSec,
                                         target: self,
                                         selector:#selector(self.interval_func),
                                         userInfo:nil,
                                         repeats:false)*/
            timer = Timer(timeInterval: leftSec, target: self, selector: #selector(self.interval_func), userInfo: nil, repeats: false)
            RunLoop.current.add(timer!, forMode: .common)
        }
        isTicking = true
        leftSec = 0.0
        /*
        timer = Timer.scheduledTimer(timeInterval:0.5,
                                     target: self,
                                     selector:#selector(self.interval_func),
                                     userInfo:nil,
                                     repeats:true)*/
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(self.interval_func), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func finished(){
        print("finished")
        if(timer != nil){
            timer!.invalidate()
            isTicking = false
            isFinished = true
            leftSec = 0.0
        }
    }
    
    func reset(){
        print("reset")
        if(isTicking){
            if(timer != nil){
                timer!.invalidate()
            }
            isTicking = false
        }
        isFinished = false
        seconds = initial_seconds
        leftSec = 0.0
    }
    
    func status() -> [Bool]{
        return [isAllowed, isFinished, isTicking]
    }
}
