//
//  TimerView.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/04/23.
//

import SwiftUI

struct TimerView: View, Identifiable{
    @EnvironmentObject var status: ListViewStatus
    @StateObject var timer: kTimer = kTimer()
    @State private var isTitleEditing: Bool = false
    @State private var isSecondsEditing: Bool = false
    @State private var title: String = ""
    @FocusState private var focus:Bool

    var id: String
    
    @State private var repeatedFor: Int = 0

    private var indexPath: IndexPath {
        get{
            return self.status.getIndexPath(id)
        }set(s){
            
        }
    }
    
    @State private var timerName: String = "Untitled"
    //@Binding var isAllFinished: Bool
    
    func secondsStr(secs: Int) -> String{
        //let h = secs / 3600
        let m = secs % 3600 / 60
        let s = secs % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    func roundsStr(rnds: Int) -> String{
        let secs = (rnds + 1)/2
        //let h = secs / 3600
        let m = secs % 3600 / 60
        let s = secs % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    func start(){
        if(self.timer.status() == [false, false, false]){
            self.timer.isAllowed = true
            self.timer.start()
            self.status.timerStarted = true
            self.status.timerBarHidden = false
            print("start() ended")
        }
    }
    
    func stop(){
        if(self.timer.status() == [true, false, true]){

            self.timer.stop()
        }
    }
    
    func restart(){
        if(self.timer.status() == [true, false, false]){
            self.timer.restart()
        }
    }
    
    //タイマーが止まったときに呼ばれる
    func finished(){
        if(self.timer.status() == [true, true, false]){
            self.repeatedFor += 1
            self.timer.isAllowed = false
            self.status.next()
        }
    }
    
    func reset(){
        self.timer.reset()
        self.timer.isAllowed = false
        if(self.status.timerBarHidden){
            self.repeatedFor = 0
        }
        /*
        if([[true, false, false], [true, false, true]].contains(self.timer.status())){
            self.timer.reset()
            self.status.resetRequest = false
        }*/
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            HStack(){
                if(!self.timerName.isEmpty){
                    if(!self.isTitleEditing){
                        Text(self.timerName.uppercased())
                            .frame(minWidth: 100, minHeight: 20, alignment: .leading)
                            .background(.clear)
                            .foregroundColor(.black)
                            .font(.system(size: self.status.timerBarHidden ? 16 : 14))
                            .onTapGesture {
                                if(self.status.isEditing.row != -2 && !self.status.timerStarted){
                                    self.title = self.timerName
                                    self.isTitleEditing.toggle()
                                    self.status.isEditing = IndexPath(row: -2, section: -2)
                                    self.focus = true
                                }
                            }
                            .padding(4)
                    }else{
                        TextField("", text: self.$title)
                            .focused(self.$focus)
                            .textInputAutocapitalization(.characters)
                            .toolbar{
                                ToolbarItemGroup(placement: .keyboard){
                                    Spacer()
                                    Button("キャンセル"){
                                        self.focus = false
                                    }
                                }
                            }
                            .frame(minWidth: 100, minHeight: 20, alignment: .leading)
                            .font(.system(size: self.status.timerBarHidden ? 16 : 14))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                self.title = self.title.trimmingCharacters(in: .whitespaces)
                                self.status.changeNames(title, of: self.id)
                                self.isTitleEditing.toggle()
                                self.status.isEditing = IndexPath(row: -1, section: -1)
                            }
                        
                    }
                    Spacer(minLength: self.isTitleEditing ? 100 : 16)
                }else{
                    Spacer()
                }
                
                Text(self.secondsStr(secs:self.timer.initial_seconds))
                    .monospacedDigit()
                    .foregroundColor(.black)
                    .font(.system(size: self.status.timerBarHidden ? 20 : 14))
                    .onTapGesture {
                        if(self.status.isEditing.row < 0 && self.status.isEditing.row != -3 && !self.status.timerStarted){
                            focus = false
                            self.isSecondsEditing.toggle()
                            self.status.isEditing = self.indexPath
                        }
                    }
                    .padding(4)

                if(self.timerName.isEmpty){
                    Spacer()
                }
            }
            .padding([.leading, .trailing], self.status.timerBarHidden ? 10 : 0)

            
            
            if(!self.status.timerBarHidden){
                VStack(spacing: 0){
                    Divider()
                    
                    HStack{
                        Spacer()
                        Text(self.roundsStr(rnds: self.timer.remained_round))
                            .font(.system(size: 45))
                            .monospacedDigit()
                        Spacer()
                    }
                    .padding([.top, .leading, .trailing], 10)
                }
            }
        }
        .padding(10)
        .background(alignment: .center){
            if !self.status.timerBarHidden{
                RatialColorView(top: .green, bottom: .red, ratio: CGFloat(self.repeatedFor)/CGFloat(self.status.timerRepeats[indexPath.section]))
                    .overlay(
                        Text(String(self.indexPath.row+1))
                            .font(.system(size: 75, weight:.black))
                            .italic()
                            .offset(x: 0, y: 20)
                            .padding([.top, .trailing], 8.0)
                            .foregroundColor(.white.opacity(self.status.timerBarHidden ? 0 : 0.5))
                        ,
                        alignment: .bottomTrailing
                    )
            }else{
                Color.red
                    .opacity(([IndexPath(row: -1, section: -1), IndexPath(row: -2, section: -2), self.indexPath].contains(self.status.isEditing) || (self.status.isEditing == IndexPath(row: -3, section: -3) && self.indexPath == self.status.last)) ? 1.0 : 0.5)
                    .overlay(
                        Text(String(self.indexPath.row+1))
                            .font(.system(size: 75, weight:.black))
                            .italic()
                            .offset(x: 0, y: 20)
                            .padding([.top, .trailing], 8.0)
                            .foregroundColor(.white.opacity(self.status.timerBarHidden ? 0 : 0.5))
                        ,
                        alignment: .bottomTrailing
                    )

            }
            
        }
        .cornerRadius(15)
        
        .onAppear{
            print("onAppear")
            self.timer.id = self.id
            self.timer.seconds = self.status.getSeconds(of: id)
            self.timerName = self.status.getName(of: id)
        }
        .onChange(of: self.status.timerArray){ value in
            print("timerArrayChanged")
            if(self.status.contains(id)){
                self.timer.seconds = self.status.getSeconds(of: id)
            }
        }
        .onChange(of: self.status.timerNames){ value in
            print("timerNames Changed")
            if(self.status.contains(id)){
                self.timerName = self.status.getName(of: id)
            }
        }
        .onChange(of: self.status.currentIndex){ value in
            print("currentID changed: \(value) (\(id), \(self.timer.initial_seconds)")
            if(value.row != -1){
                if(value == self.indexPath){
                    self.start()
                }else if(self.timer.isAllowed){
                    self.timer.isAllowed = false
                }
            }
        }
        .onChange(of: self.status.buttonStatus){ value in
            print("buttonStatus notice: ", value)
            if(value == 0){
                self.stop()
            }else if(value == 1){
                if(self.status.timerStarted){
                    self.restart()
                }else{
                    if(self.status.currentIndex == IndexPath(row: 0, section: 0) && self.indexPath == IndexPath(row: 0, section: 0)){
                        self.start()
                    }
                }
            }
        }
        .onChange(of: self.status.resetRequest){ value in
            print("resetRequest changed")
            self.reset()
        }
        .onChange(of: self.timer.isFinished){ value in
            print("self.timer.isFinished changed")
            if(value){
                self.finished()
            }
        }
        .onChange(of: self.focus){ value in
            if(value == false){
                self.isTitleEditing = false
            }
        }
        .onChange(of: self.status.needToBeReset){ value in
            if(value.contains(id)){
                self.reset()
                self.status.needToBeReset.removeAll(where: {$0 == id})
            }
        }

        
        
    }
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(id: "ceda9e1d-50c2-407e-8724-9e0e407fa822")
            .environmentObject(ListViewStatus())
    }
}
