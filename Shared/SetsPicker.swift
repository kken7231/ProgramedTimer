//
//  SetsPicker.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/20.
//

import SwiftUI

struct SetsPicker: View {
    @EnvironmentObject var status: ListViewStatus

    @State var sets: Int = 1
    var body: some View {
        HStack{
            Picker(selection: $sets, label: Text("")) {
                ForEach(1..<21){ i in
                    Text(String(i)).tag(i)
                        .monospacedDigit()

                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100)
            .labelsHidden()
            .compositingGroup()
            .clipped()
            
            Text(" 回 繰り返し")
                .font(.system(size: 20))
        }
        .onAppear(){
            sets = self.status.timerRepeats[(status.isEditing.section >= 0) ? status.isEditing.section : 0]
        }
        .onChange(of: status.isEditing){ value in
            if(value.row == -4){
                print("setspicker value vhanged")
                sets = self.status.timerRepeats[value.section]
            }
        }
        .onChange(of: sets){ value in
            self.status.timerRepeats[(status.isEditing.section >= 0) ? status.isEditing.section : 0] = value
        }
    }
}

struct SetsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SetsPicker()
            .environmentObject(ListViewStatus())
    }
}
