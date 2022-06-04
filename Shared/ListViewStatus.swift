//
//  ListViewStatus.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/17.
//

import Foundation


class ListViewStatus: ObservableObject{
    
    var remainedRepeats: Int = 0
    @Published var currentIndex: IndexPath = IndexPath(row: 0, section: 0)
    @Published var buttonStatus: Int = 0
    @Published var resetRequest: Int = 0
    @Published var timerArray: [String: Int] = ["ceda9e1d-50c2-407e-8724-9e0e407fa822": 1, "ffe46803-a9ad-4d71-b596-864bb67ed8ac" : 2,"412a3add-2290-4313-80c2-d521741f42ee" : 3]
    @Published var timerNames: [String: String] = ["ceda9e1d-50c2-407e-8724-9e0e407fa822": "A", "ffe46803-a9ad-4d71-b596-864bb67ed8ac" : "B","412a3add-2290-4313-80c2-d521741f42ee" : "C"]
    @Published var timerUUIDs: [[String]] = [["ceda9e1d-50c2-407e-8724-9e0e407fa822", "ffe46803-a9ad-4d71-b596-864bb67ed8ac"], ["412a3add-2290-4313-80c2-d521741f42ee"]]
    @Published var timerRepeats: [Int] = [2, 2]
    private var allUUIDs: [String]{
        get{
            return Array(timerUUIDs.joined())
        }
        set(s){}
    }
    private (set) var count: Int{
        get{
            return allUUIDs.count
        }
        set(s){}
    }
    
    
    private (set) var last: IndexPath{
        get{
            let lasts = timerUUIDs.count-1
            if(lasts == -1){
                return IndexPath(row: 0, section: 0)
            }
            let lastr = timerUUIDs[lasts].count - 1
            return IndexPath(row: lastr, section: lasts)
        }
        set(s){}
    }
    
    @Published var timerStarted: Bool = false
    @Published var isEditing: IndexPath = IndexPath(row: -1, section: -1) // -1 not editing, -2 title, -3 new timer, -4 section times, else seconds (id)
    @Published var timerBarHidden: Bool = true
    @Published var needToBeReset: [String] = []
    private (set) var oldValue: Int{
        get{
            if(isEditing.row == -4){
                return timerRepeats[isEditing.section]
            }else if(isEditing.row >= 0){
                return getSeconds(at: isEditing)
            }
            return 1
        }
        set(s){}
    }
    
    
    private func last(in section: Int)-> IndexPath{
        if(section >= 0 && section < timerUUIDs.count){
            return IndexPath(row: timerUUIDs[section].count-1, section: section)
        }else{
            return IndexPath(row: 0, section: 0)
        }
    }
    
    func exists(indexPath: IndexPath)-> Bool{
        if(indexPath.section >= 0 && indexPath.section < self.timerUUIDs.count){
            if((indexPath.row >= 0 && indexPath.row < self.timerUUIDs[indexPath.section].count)){
                return true
            }
            return false
        }
        return false
    }
    
    
    func contains(_ uuid: String) -> Bool{
        return self.allUUIDs.contains(uuid)
    }
    
    func next(){
        
        if(currentIndex.row == timerUUIDs[currentIndex.section].count - 1){
            if(remainedRepeats == 0){
                if(currentIndex.section+1 < timerUUIDs.count){
                    remainedRepeats = timerRepeats[currentIndex.section+1] - 1 
                    currentIndex = IndexPath(row: 0, section: currentIndex.section+1)
                }else{
                    currentIndex = IndexPath(row: 0, section: currentIndex.section+1)
                    allFinished()
                }
                
            }else{
                remainedRepeats -= 1
                needToBeReset = timerUUIDs[currentIndex.section]
                self.currentIndex = IndexPath(row: -1, section: self.currentIndex.section)
                DispatchQueue.main.async {
                    self.currentIndex = IndexPath(row: 0, section: self.currentIndex.section)
                }
            }
        }else{
            currentIndex = IndexPath(row: currentIndex.row+1, section: currentIndex.section)
        }
        
    }
    
    func allFinished(){
        timerStarted = false
        buttonStatus = 0
    }
    
    private func isAvailable(_ indexPath: IndexPath)-> Bool{
        if(0 <= indexPath.section && indexPath.section <= timerUUIDs.count){
            if(0 <= indexPath.row && indexPath.row <= timerUUIDs[indexPath.section].count){
                return true
            }
            return false
        }
        return false
    }
    
    
    func getIndexPath(_ uuid: String) -> IndexPath{
        if(self.contains(uuid)){
            for sec in 0..<timerUUIDs.count{
                for row in 0..<timerUUIDs[sec].count{
                    if(timerUUIDs[sec][row] == uuid){
                        return IndexPath(row: row, section: sec)
                    }
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func getUUID(at indexPath: IndexPath) -> String{
        return timerUUIDs[indexPath.section][indexPath.row]
    }
    
    func getSeconds( at indexPath: IndexPath) -> Int{
        if(self.exists(indexPath: indexPath)){
            let targetUUID = self.getUUID(at: indexPath).lowercased()
            return self.timerArray[targetUUID] ?? 1
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            let targetUUID = self.getUUID(at: last).lowercased()
            return self.timerArray[targetUUID] ?? 1
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            let targetUUID = self.getUUID(at: last(in: indexPath.section)).lowercased()
            return self.timerArray[targetUUID] ?? 1
        }
        else{
            return 1
        }
    }
    
    func getName( at indexPath: IndexPath) -> String{
        if(self.exists(indexPath: indexPath)){
            let targetUUID = self.getUUID(at: indexPath).lowercased()
            return self.timerNames[targetUUID] ?? ""
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            let targetUUID = self.getUUID(at: last).lowercased()
            return self.timerNames[targetUUID] ?? ""
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            let targetUUID = self.getUUID(at: last(in: indexPath.section)).lowercased()
            return self.timerNames[targetUUID] ?? ""
        }
        else{
            return ""
        }
    }
    
    func getSeconds(of uuid: String) -> Int{
        if(self.contains(uuid)){
            return self.timerArray[uuid.lowercased()] ?? 1
        }else{
            return 1
        }
    }
    
    func getName(of uuid: String) -> String{
        if(self.contains(uuid)){
            return self.timerNames[uuid.lowercased()] ?? ""
        }else{
            return ""
        }
    }
    
    
    func changeSeconds(_ seconds: Int, at indexPath: IndexPath){
        if(exists(indexPath: indexPath)){
            let targetUUID = self.getUUID(at: indexPath).lowercased()
            self.timerArray[targetUUID] = seconds
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            let targetUUID = self.getUUID(at: last).lowercased()
            self.timerArray[targetUUID] = seconds
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            let targetUUID = self.getUUID(at: last(in: indexPath.section)).lowercased()
            self.timerArray[targetUUID] = seconds
        }
    }
    
    func changeNames(_ name: String, at indexPath: IndexPath){
        if(self.exists(indexPath: indexPath)){
            let targetUUID = self.getUUID(at: indexPath).lowercased()
            self.timerNames[targetUUID] = name
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            let targetUUID = self.getUUID(at: last).lowercased()
            self.timerNames[targetUUID] = name
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            let targetUUID = self.getUUID(at: last(in: indexPath.section)).lowercased()
            self.timerNames[targetUUID] = name
        }
    }
    
    func changeRepeats(_ repeats: Int, section: Int){
        if(self.timerUUIDs.count > section){
            self.timerRepeats[section] = repeats
        }
    }
    
    func changeSeconds(_ seconds: Int, of uuid: String){
        if(self.contains(uuid)){
            self.timerArray[uuid.lowercased()] = seconds
        }
    }
    
    func changeNames(_ name: String, of uuid: String){
        if(self.contains(uuid)){
            self.timerNames[uuid.lowercased()] = name
        }
    }
    
    func createTimer(at indexPath: IndexPath){
        let newUUID = UUID().uuidString.lowercased()
        if(self.isAvailable(indexPath)){
            if(indexPath.section > 0 && indexPath.section < self.timerUUIDs.count){
                (self.timerUUIDs[indexPath.section]).insert(newUUID, at: indexPath.row)
            }else{
                self.timerUUIDs.append([newUUID])
            }
            self.timerArray[newUUID] = 1
            self.timerNames[newUUID] = ""
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            self.timerUUIDs[self.timerUUIDs.count-1].append(newUUID)
            self.timerArray[newUUID] = 1
            self.timerNames[newUUID] = ""
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            (self.timerUUIDs[indexPath.section]).insert(newUUID, at: self.last(in: indexPath.section).row + 1)
            self.timerArray[newUUID] = 1
            self.timerNames[newUUID] = ""
        }
    }
    
    func createSection(){
        self.timerUUIDs.append([])
        self.timerRepeats.append(1)
    }
    
    func deleteTimer(at indexPath: IndexPath){
        if(self.exists(indexPath: indexPath)){
            let targetUUID = self.getUUID(at: indexPath)
            self.timerUUIDs[indexPath.section].remove(at: indexPath.row)
            self.timerArray.removeValue(forKey: targetUUID.lowercased())
            self.timerNames.removeValue(forKey: targetUUID.lowercased())
        }
        else if(indexPath == IndexPath(row: -1, section: -1) && self.allUUIDs.count != 0){
            let targetUUID = self.timerUUIDs[-1][-1]
            self.timerUUIDs[-1].removeLast()
            self.timerArray.removeValue(forKey: targetUUID.lowercased())
            self.timerNames.removeValue(forKey: targetUUID.lowercased())
        }
        else if(indexPath.row == -1 && indexPath.section > 0 && indexPath.section < self.timerUUIDs.count && self.allUUIDs.count != 0 ){
            let targetUUID = self.timerUUIDs[indexPath.section][-1]
            self.timerUUIDs[indexPath.section].removeLast()
            self.timerArray.removeValue(forKey: targetUUID.lowercased())
            self.timerNames.removeValue(forKey: targetUUID.lowercased())
        }
    }
}
