//
//  GroupView.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/20.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var status: ListViewStatus
    var section: Int
    let cornerRadius: CGFloat = 15
    @State private var textWidth: CGFloat = 0
    @State private var textHeight: CGFloat = 25
    var text: String
    private var color: Color{
        get{
            if(!self.status.timerBarHidden){
                if(self.status.currentIndex.section > section){
                    return .green
                }else{
                    return .red
                }
            }else if(self.status.isEditing == IndexPath(row: -4, section: section)){
                return .blue
            }else if(self.status.isEditing.row != -1){
                return .black.opacity(0.3)
            }else if(status.timerRepeats[section] != 1){
                return .black
            }else{
                return .clear
            }
            
        }
        set(s){
            
        }
    }
    
    private var textColor: Color{
        get{
            if(self.status.isEditing == IndexPath(row: -4, section: section)){
                return .blue
            }else if(self.status.isEditing.row != -1){
                return .black.opacity(0.3)
            }else if(status.timerRepeats[section] != 1){
                return .black
            }else{
                return .clear
            }
            
        }
        set(s){
            
        }
    }
        
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .topTrailing){
                Path{ path in
                    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: geometry.size)
                    let circleStartPoints = [CGPoint(x: cornerRadius, y: textHeight/2), CGPoint(x: 0, y: rect.height-cornerRadius), CGPoint(x: rect.width-cornerRadius, y: rect.height), CGPoint(x: rect.width, y: textHeight/2 + cornerRadius)]
                    let tangent1Ends = [CGPoint(x: 0, y: textHeight/2), CGPoint(x: 0, y: rect.height), CGPoint(x: rect.width, y: rect.height), CGPoint(x: rect.width, y: textHeight/2)]
                    let tangent2Ends = [CGPoint(x: 0, y: textHeight/2 + cornerRadius), CGPoint(x: cornerRadius, y: rect.height), CGPoint(x: rect.width, y: rect.height-cornerRadius), CGPoint(x: rect.width-cornerRadius, y: textHeight/2)]
                    
                    path.move(to: circleStartPoints[0])
                    path.addArc(tangent1End: tangent1Ends[0], tangent2End: tangent2Ends[0], radius: cornerRadius)
                    
                    for i in 1...3{
                        path.addLine(to: circleStartPoints[i])
                        path.addArc(tangent1End: tangent1Ends[i], tangent2End: tangent2Ends[i], radius: cornerRadius)
                    }
                    path.addLine(to: CGPoint(x: rect.width-cornerRadius, y: textHeight/2))
                  
                    path.move(to: CGPoint(x: rect.width-cornerRadius-textWidth-10, y: textHeight/2))
                    path.addLine(to: circleStartPoints[0])


                }
                .stroke(color, style: .init(lineWidth: 4, lineCap: .round))
                
                Text(text.isEmpty ? "" : "  \(text)  ")
                    .font(.system(size: 50))
                    .foregroundColor(textColor)
                    .minimumScaleFactor(0.1)
                    .frame(height: textHeight, alignment: .trailing)
                    .fixedSize()
                    .background(
                        GeometryReader { geo -> Color in
                            DispatchQueue.main.async {
                                textWidth = geo.size.width
                            }
                        return .clear
                    })
                    .padding([.leading, .trailing], cornerRadius + 5)
            }
            
        }
    }
    
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(section: 0, text: "text")
            .environmentObject(ListViewStatus())
    }
}
