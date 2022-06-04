//
//  RatialColorView.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/27.
//

import SwiftUI

struct RatialColorView: View {
    var top: Color
    var bottom: Color
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            if(ratio == 0){
                bottom
            }else if(ratio == 1){
                top
            }else{
                HStack(spacing: 0){
                    Path{ path in
                        let crossCenter = CGPoint(x: geometry.size.width*ratio, y: geometry.size.height/2)
                        let topCrossP = CGPoint(x: crossCenter.x + crossCenter.y, y: 0)
                        let bottomCrossP = CGPoint(x: crossCenter.x - crossCenter.y, y: geometry.size.height)
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: topCrossP)
                        path.addLine(to: bottomCrossP)
                        path.addLine(to: CGPoint(x: bottomCrossP.x > 0 ? 0 : bottomCrossP.x, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: 0, y: 0))
                    }
                    .fill(top)
                }
                .background(bottom)
            }
        }
    }
}


struct RatialColorView_Previews: PreviewProvider {
    static var previews: some View {
        RatialColorView(top: .green, bottom: .red, ratio: 1)
            .frame(width: 500, height: 100)
    }
}
