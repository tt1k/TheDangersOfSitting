//
//  ContentView.swift
//  TheDangersOfSitting
//
//  Created by IcedOtaku on 2022/3/17.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("info.fakecoder.StartWorkingTimeStamp")
    var __startWorkingTimeStamp: Double = 0
    @AppStorage("info.fakecoder.FinishWorkingTimeStamp")
    var __finishWorkingTimeStamp: Double = 0
    @AppStorage("info.fakecoder.StandUpInterval")
    var __standUpInterval: Int = 30
    @AppStorage("info.fakecoder.HasLunchBreak")
    var __hasLunchBreak: Bool = false

    @State private var startWorking: Date = Date()
    @State private var finishWorking: Date = Date()
    @State private var standUpInterval: Int = 30
    @State private var hasLunchBreak: Bool = false
    @State private var showAlert: Bool = false
    
    @StateObject private var menubar: Menubar = Menubar.shared
    
    private let scale: CGFloat = 0.6
    private let width: CGFloat = 1000
    private let height: CGFloat = 618
    
    var body: some View {
        VStack {
            appIntro
                .padding()
        }
        .frame(width: self.width * self.scale, height: self.height * self.scale, alignment: Alignment.center)
        .onAppear {
            if 0 == __startWorkingTimeStamp || 0 == __finishWorkingTimeStamp {
                __startWorkingTimeStamp = DateUtil.shared.getTodayDate(hour: 10, minute: 30).timeIntervalSince1970
                __finishWorkingTimeStamp = DateUtil.shared.getTodayDate(hour: 21, minute: 30).timeIntervalSince1970
                __standUpInterval = 30
                __hasLunchBreak = false
            }
            
            startWorking = Date.init(timeIntervalSince1970:__startWorkingTimeStamp)
            finishWorking = Date.init(timeIntervalSince1970:__finishWorkingTimeStamp)
        }
        .onChange(of: startWorking) { newValue in
            __startWorkingTimeStamp = newValue.timeIntervalSince1970
        }
        .onChange(of: finishWorking) { newValue in
            __finishWorkingTimeStamp = newValue.timeIntervalSince1970
        }
        .onChange(of: standUpInterval) { newValue in
            __standUpInterval = newValue
        }
        .onChange(of: hasLunchBreak) { newValue in
            __hasLunchBreak = newValue
        }
    }
    
    var appIntro: some View {
        VStack {
            Image("avatar")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fit)
            Text("The Dangers of Sitting")
                .font(.system(.title))
            Text("Sitting or lying down for too long increases your risk of chronic health problems, such as heart disease, diabetes and some cancers.")
                .font(.system(.body))
            
            Spacer()
            
            HStack {
                Text("Start at")
                    .font(.system(.body))
                DatePicker("", selection: $startWorking, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Spacer()
                Text("Finished at")
                    .font(.system(.body))
                DatePicker("", selection: $finishWorking, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            HStack {
                Text("Stand up interval (minute)")
                    .font(.system(.body))
                TextField("Interval", text: Binding<String>(
                    get: {
                        String(standUpInterval)
                    }, set: { str in
                        standUpInterval = Int(str) ?? 0
                    }
                ))
                .frame(width: 40)
            }
            
            Toggle("Considering Lunch Break", isOn: $hasLunchBreak)
            
            Spacer()
            
            Button {
                guard __finishWorkingTimeStamp > __startWorkingTimeStamp else {
                    showAlert = true
                    return
                }
                
                if menubar.running {
                    menubar.stop()
                } else {
                    menubar.run()
                }
            } label: {
                if menubar.running {
                    Text("Remove it from the Dock!")
                } else {
                    Text("Add it to the Dock!")
                }
            }
            .alert(isPresented: $showAlert) {
                return Alert(
                    title: Text("TheDangersOfSitting"),
                    message: Text("Invalid Start Working Time or Finish Working Time")
                )
            }
        }
        .frame(maxWidth: self.width * self.scale * 0.8)
    }
}

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
