//
//  TimerListView.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/04/24.
//

import SwiftUI

struct TimerListView: View{
    //@State var isAllFinished: Bool = false
    init(){
        UITableView.appearance().backgroundColor = UIColor.white
    }
    @EnvironmentObject var status: ListViewStatus
    @State private var showAlert: Bool = false
    @State var isPresentedSubView = false
    @State private var title: String = ""
    @State private var oldValue: Int = 1
    @FocusState private var focused: Bool
    
    private func sectionTitle(section sec: Int)-> String {
        let currentSec = self.status.currentIndex.section
        let repeats = status.timerRepeats[sec]
         if(self.status.timerBarHidden){
            return "x \(repeats)"
        }else if(sec > currentSec){
            return "0 / \(repeats)"
        }else if(sec == currentSec){
            return "\(repeats - status.remainedRepeats) / \(repeats)"
        }else if(sec < currentSec){
            return "\(repeats) / \(repeats)"
        }else {
            return "x \(repeats)"
        }
    }

    func add_timer(){
        self.status.createTimer(at: IndexPath(row: -1, section: -1))
        self.status.isEditing = IndexPath(row: -3, section: -3)
    }
    
    func add_section(){
        self.status.createSection()
        self.status.createTimer(at: IndexPath(row: -1, section: -1))
        self.status.isEditing = IndexPath(row: -3, section: -3)
    }
    /*
    func delete_timer(at offsets: IndexSet){
        if(!self.status.timerStarted){
            self.status.deleteTimer(at: offsets.first!)
        }
    }*/
    
    var body: some View {
        ScrollViewReader{ reader in
            VStack{
                ZStack(alignment: .bottomTrailing){
                    VStack{
                        if(!self.status.timerBarHidden){
                            VStack{
                                Text(self.status.exists(indexPath: self.status.currentIndex) ? ("#\(self.status.currentIndex.row + 1) \(self.status.getName(at: self.status.currentIndex))") : "Finished")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding()
                                Divider()
                            }
                            .transition(AnyTransition.asymmetric(insertion: AnyTransition.move(edge: .top), removal: .move(edge: .top)))
                        }
                
                        /*
                        List{
                            ForEach(0..<self.status.timerUUIDs.count, id:\.self){ sec in
                                Section{
                                    ForEach(self.status.timerUUIDs[sec], id: \.self, content: { uuid in
                                        TimerView(id: uuid)
                                            .shadow(radius: 5)
                                            .padding(5)
                                            .listRowSeparator(.hidden)
                                    })
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .listSectionSeparator(.visible)
                        .listSectionSeparatorTint(.black)*/
                        
                        ScrollView{
                            VStack(spacing: 0){
                                ForEach(0..<self.status.timerUUIDs.count, id:\.self){ sec in
                                    VStack{
                                        ForEach(self.status.timerUUIDs[sec], id: \.self, content: { uuid in
                                            TimerView(id: uuid)
                                                .id(uuid)
                                                .shadow(radius: 5)
                                                .padding(5)
                                                .listRowSeparator(.hidden)
                                        })
                                    }
                                    .padding([.top], 30)
                                    .padding([.bottom], 8)
                                    .padding([.leading, .trailing], 16)
                                    .overlay{
                                        GroupView(section: sec, text: sectionTitle(section: sec))
                                            .onTapGesture {
                                                self.status.isEditing = IndexPath(row: -4, section: sec)
                                            }
                                    }
                                    .id(sec)
                                    .padding([.top, .bottom], 8)
                                    .padding([.leading, .trailing], 16)
                                }
                            }
                        }
                    }
                    
                    if(self.status.isEditing.row == -1){
                        VStack(spacing: 0){
                            Button(action:{
                                self.add_timer()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.black.opacity(!self.status.timerStarted ? 1.0 : 0.3))
                                    .font(.system(size: 30))
                                    .padding()
                                    .background(.white.opacity(!self.status.timerStarted ? 1.0 : 0.3))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.black.opacity(!self.status.timerStarted ? 1.0 : 0.3), lineWidth: 3)
                                        , alignment: .center)

                            })
                            .disabled(!self.status.timerBarHidden)
                            .padding()
                            
                            Button(action:{
                                self.add_section()
                            }, label: {
                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.black.opacity(!self.status.timerStarted ? 1.0 : 0.3))
                                    .font(.system(size: 30))
                                    .padding()
                                    .background(.white.opacity(!self.status.timerStarted ? 1.0 : 0.3))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.black.opacity(!self.status.timerStarted ? 1.0 : 0.3), lineWidth: 3)
                                        , alignment: .center)

                            })
                            .disabled(!self.status.timerBarHidden)
                            .padding()
                        }
                    }
                }
                
                
                            
                if(self.status.isEditing.row == -1){
                    Divider()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                
                                let now = self.status.buttonStatus
                                
                                if(now == 0){ //pausing -> playing
                                    self.status.buttonStatus = 1
                                }else{ // playing -> pausing
                                    self.status.buttonStatus = 0
                                }
                                print("BUTTON self.status:",self.status.buttonStatus)
                            }, label: {
                                if(self.status.buttonStatus == 1){
                                    Image(systemName: "pause.fill")
                                        .opacity(!self.status.timerBarHidden && !self.status.timerStarted ? 0.5 : 1)
                                }else {
                                    Image(systemName: "play.fill")
                                        .opacity(!self.status.timerBarHidden && !self.status.timerStarted ? 0.5 : 1)
                                }
                            })
                            .disabled(!self.status.timerBarHidden && !self.status.timerStarted)
                            .font(.system(size: 30))
                            
                            Spacer()
                        
                            Button(action: {
                                self.showAlert = true
                                
                            }, label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .opacity(!self.status.timerStarted ? 0.5 : 1)
                            })
                            .alert(isPresented: self.$showAlert) {
                                Alert(title: Text("本当にリセットしていいですか？"),
                                      message: nil,
                                      primaryButton: .cancel(Text("キャンセル")),
                                      secondaryButton: .destructive(
                                        Text("リセット"),
                                        action: {
                                            print("reset button pushed")
                                            self.status.timerStarted = false
                                            self.status.timerBarHidden = true
                                            self.status.buttonStatus = 0
                                            self.status.resetRequest += 1
                                            self.status.currentIndex = IndexPath(row: 0, section: 0)
                                        }
                                      ))
                            }
                            .font(.system(size: 30))
                            .disabled(!self.status.timerStarted)

                            
                            Spacer()
                         
                        }
                        .padding()
                    }
                    .foregroundColor(.black)
                    .onChange(of: self.status.currentIndex){ value in
                        if(value.row != -1){
                            if(!self.status.exists(indexPath: value)){
                                self.status.allFinished()
                            }
                        }
                    }
                    .onChange(of: self.status.timerStarted){ value in
                        if(value){
                            self.status.timerBarHidden = false
                        }else{
                            let t = Timer(timeInterval: 3, repeats: false, block: {_ in
                                self.status.timerBarHidden = true
                                self.status.timerStarted = false
                                self.status.buttonStatus = 0
                                self.status.resetRequest += 1
                                self.status.remainedRepeats = self.status.timerRepeats[0] - 1
                                self.status.currentIndex = IndexPath(row: 0, section: 0)
                                
                            })
                            RunLoop.current.add(t, forMode: .common)
                        }
                    }
                    
                }
                else if(self.status.isEditing.row >= 0){

                    VStack(spacing:0){
                        Divider()
                        TimePicker(indexPath: self.status.isEditing)
                            .frame(height: 150)
                            .padding([.leading, .trailing], 40)
                            .padding([.top], 8)
                            .padding([.bottom], 16)
                        HStack{
                            Spacer()
                            Button(action: {
                                self.status.isEditing = IndexPath(row: -1, section: -1)
                            }, label: {
                                Image(systemName: "circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))

                            })
                            .padding()
                            Spacer()
                            Button(action: {
                                self.status.changeSeconds(oldValue, at: self.status.isEditing)
                                self.status.isEditing = IndexPath(row: -1, section: -1)
                            }, label: {
                                Image(systemName: "multiply")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                            })
                            .padding()
                            Spacer()
                        }
                    }
                    .onAppear(){
                        self.oldValue = self.status.oldValue
                    }
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))

                }
                else if(self.status.isEditing.row == -3){
                    VStack(spacing:0){
                        Divider()
                        TextField("", text: self.$title)
                            .frame(minWidth: 100, minHeight: 20, alignment: .center)
                            .multilineTextAlignment(.center)
                            .focused(self.$focused)
                            .font(.system(size: self.status.timerBarHidden ? 16 : 14))
                            .padding(8)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black)
                            )
                            .onSubmit {
                                self.title = self.title.trimmingCharacters(in: .whitespaces)
                                self.status.changeNames(self.title, at: IndexPath(row: -1, section: -1))
                            }
                            .padding([.top, .bottom], 16)
                            .padding([.leading, .trailing], 50)
                            
                        
                        Divider()
                            .padding([.leading, .trailing], 100)


                        if(!self.focused){
                            TimePicker(indexPath: IndexPath(row: -1, section: -1))
                                .frame(height: 150)
                                .padding([.leading, .trailing], 40)
                                .padding([.top], 16)
                                .padding([.bottom], 16)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.status.isEditing = IndexPath(row: -1, section: -1)
                                }, label: {
                                    Image(systemName: "circle")
                                        .foregroundColor(.green)
                                        .font(.system(size: 30))

                                })
                                .padding()
                                Spacer()
                                Button(action: {
                                    self.status.isEditing = IndexPath(row: -1, section: -1)
                                }, label: {
                                    Image(systemName: "multiply")
                                        .foregroundColor(.red.opacity(0.5))
                                        .font(.system(size: 30))
                                })
                                .disabled(true)
                                .padding()
                                Spacer()
                            }
                        }
                        

                    }
                    
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))

                }
                else if(self.status.isEditing.row == -4){
                    VStack(spacing:0){
                        Divider()
                        
                        SetsPicker()
                            .frame(height: 150)
                            .padding([.leading, .trailing], 40)
                            .padding([.top], 16)
                            .padding([.bottom], 16)
                        
                        HStack{
                            Spacer()
                            Button(action: {
                                self.status.isEditing = IndexPath(row: -1, section: -1)
                            }, label: {
                                Image(systemName: "circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))

                            })
                            .padding()
                            Spacer()
                            Button(action: {
                                self.status.changeRepeats(oldValue, section: self.status.isEditing.section)
                                self.status.isEditing = IndexPath(row: -1, section: -1)
                            }, label: {
                                Image(systemName: "multiply")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                            })
                            .padding()
                            Spacer()
                        }
                        

                    }
                    .onAppear(){
                        self.oldValue = self.status.oldValue
                    }
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))

                }
            }
            .onChange(of: self.status.isEditing){ value in
                print("isediting: \(value)")
                self.focused = false
                if(value.row == -4){
                    print("value :", value)
                    DispatchQueue.main.async {
                        reader.scrollTo(value.section)
                    }
                }else if(value.row == -3){
                    let uuid = self.status.getUUID(at: self.status.last)
                    reader.scrollTo(uuid)
                    
                    
                }else if(value.row >= 0){
                    DispatchQueue.main.async {
                        reader.scrollTo(self.status.getUUID(at: value))
                    }
                }
            }
            .onAppear{
                self.status.remainedRepeats = self.status.timerRepeats[0] - 1
            }
        }
        
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerListView()
            .environmentObject(ListViewStatus())
    }
}
