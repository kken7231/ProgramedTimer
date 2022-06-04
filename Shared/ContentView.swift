//
//  ContentView.swift
//  Shared
//
//  Created by kentarou on 2022/04/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var status: ListViewStatus
    
    
    var body: some View {
        TimerListView()
            .onAppear(){
                self.status.timerUUIDs = [["ceda9e1d-50c2-407e-8724-9e0e407fa822",  "ffe46803-a9ad-4d71-b596-864bb67ed8ac"],  ["412a3add-2290-4313-80c2-d521741f42ee"]]
                self.status.timerArray = ["ceda9e1d-50c2-407e-8724-9e0e407fa822": 1, "ffe46803-a9ad-4d71-b596-864bb67ed8ac" : 2,"412a3add-2290-4313-80c2-d521741f42ee" : 3]
                self.status.timerNames = ["ceda9e1d-50c2-407e-8724-9e0e407fa822": "A", "ffe46803-a9ad-4d71-b596-864bb67ed8ac" : "B","412a3add-2290-4313-80c2-d521741f42ee" : "C"]
                self.status.timerRepeats = [2, 2]
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ListViewStatus())
    }
}
