//
//  TimePicker.swift
//  ProgramedTimer
//
//  Created by kentarou on 2022/05/11.
//

import SwiftUI

struct TimePicker: View {
    @EnvironmentObject var status: ListViewStatus
    var indexPath: IndexPath
    var seconds: Int{
        get{
            return min * 60 + sec
        }
        set(s){
            min = s / 60
            sec = s % 60
        }
    }
    @State private var min: Int = 0
    @State private var sec: Int = 1
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(spacing: 0){
                
                Picker(selection: $min, label: Text("")) {
                    ForEach(0..<60){ i in
                        Text(String(format: "%02d", i)).tag(i)
                            .monospacedDigit()

                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(width: (geometry.size.width-10)/2,height: 150, alignment: .center)
                .compositingGroup()
                .clipped()
                
                Text(":")
                    .font(.system(size:26.5))
                    .offset(x: 0, y: -2)
                    .frame(width: 10)
                    //.background(Color(.displayP3, red: 244/256, green: 244/256, blue: 245/256, opacity: 1))

                
                Picker(selection: $sec, label: Text("")) {
                    ForEach(0..<60){ i in
                        Text(String(format: "%02d", i)).tag(i)
                            .monospacedDigit()

                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(width: (geometry.size.width-10)/2, height: 150, alignment: .center)
                .compositingGroup()
                .clipped()
            }
            .onAppear{
                
                let secs = status.getSeconds(at: indexPath)
                min = secs / 60
                sec = secs % 60
            }
            .onChange(of: seconds){ value in
                if(value == 0){
                    sec = 1
                    status.changeSeconds(1, at: indexPath)
                }else{
                    status.changeSeconds(value, at: indexPath)
                }
                
            }
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(indexPath: [0, 0])
            .environmentObject(ListViewStatus())
    }
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}
