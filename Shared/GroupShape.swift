//
//  GroupShape.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/20.
//

import SwiftUI

struct GroupShape : Shape {
    let startAngle = Angle(degrees: 0)
    let endAngle   = Angle(degrees: -30)
    let cornerRadius: CGFloat = 15
    let textHeight: CGFloat = 20

    func path(in rect: CGRect) -> Path {
        let circleStartPoints = [CGPoint(x: cornerRadius, y: textHeight/2), CGPoint(x: 0, y: rect.height-cornerRadius), CGPoint(x: rect.width-cornerRadius, y: rect.height), CGPoint(x: rect.width, y: textHeight/2 + cornerRadius)]
        let tangent1Ends = [CGPoint(x: 0, y: textHeight/2), CGPoint(x: 0, y: rect.height), CGPoint(x: rect.width, y: rect.height), CGPoint(x: rect.width, y: textHeight/2)]
        let tangent2Ends = [CGPoint(x: 0, y: textHeight/2 + cornerRadius), CGPoint(x: cornerRadius, y: rect.height), CGPoint(x: rect.width, y: rect.height-cornerRadius), CGPoint(x: rect.width-cornerRadius, y: textHeight/2)]

        var path = Path()
        
        path.move(to: circleStartPoints[0])
        path.addArc(tangent1End: tangent1Ends[0], tangent2End: tangent2Ends[0], radius: cornerRadius)
        
        for i in 1...3{
            path.addLine(to: circleStartPoints[i])
            path.addArc(tangent1End: tangent1Ends[i], tangent2End: tangent2Ends[i], radius: cornerRadius)
        }
        /*
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle:   endAngle,
                    clockwise: true
        )*/
        
    
        return path
    }
}

struct GroupShape_Previews: PreviewProvider {
    static var previews: some View {
        GroupShape()
            .stroke(lineWidth: 4)
    }
}
