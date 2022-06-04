//
//  AddTimerView.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/11.
//

import SwiftUI

struct AddTimerView: View {
    @State private var title: String = ""
    var body: some View {
        
        VStack{
            HStack{
                Text("キャンセル")
                Spacer()
                Text("新規イベント")
                Spacer()
                Text("追加")
            }
            .padding()
            
            List{
                Section{
                    TextField("タイトル", text: $title)
                }
                
                
            }
            .background(Color.clear)
        }
    }
}

struct AddTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerView()
    }
}
