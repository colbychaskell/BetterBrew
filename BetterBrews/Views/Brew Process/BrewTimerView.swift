//
//  BrewTimerView.swift
//  BetterBrews
//
//  Created by Colby Haskell on 8/11/21.
//

import SwiftUI

struct BrewTimerView: View {
    @EnvironmentObject var settings: GlobalSettings
    @Binding var showSelf: Bool
    @ObservedObject var newBrew: NewBrew
    @ObservedObject var timer = BrewTimer()
    
    var brewTime: Double {
        print(Double(timer.minutesElapsed))
        print(Double(timer.secondsElapsed))
        return Double(timer.minutesElapsed) + Double(timer.secondsElapsed)/60
    }
    
    var body: some View {
        UITableView.appearance().backgroundColor = UIColor(named: "tan")
        
        return
            ZStack {
                Color("tan")
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    timerSection
                    logEntrySection
                }
                .padding(.vertical)
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle("Brew Timer")
            .navigationBarTitleDisplayMode(.inline)
    }
    var timerSection: some View {
        VStack {
            Spacer()
            timerView
                .onAppear(perform: autostart)
            Spacer()
            if(timer.mode != .running) {
                startButton
            }
            else {
                pauseButton
            }
            finishButton
            Spacer()
        }
        .background(Color("tan"))
    }
    
    var logEntrySection: some View {
        var logEntrySectionHeader: some View {
            HStack {
                Text("Log Entry:")
                    .bold()
                    .font(.title)
                Spacer()
                EditButton()
                    .foregroundColor(AppStyle.bodyTextColor)
            }
        }
        
        return
            VStack(alignment: .leading, spacing: viewConstants.logFieldSpacing) {
                logEntrySectionHeader
                Divider()
                logEntryRow(label: "Brewed with", value: newBrew.brew.brewEquipment)
                logEntryRow(label: "Beans Used", value: newBrew.brew.bean!.name!)
                logEntryRow(label: "Grind Size", value: newBrew.brew.grindSizeString!)
                logEntryRow(label: "Coffee Amount", value: (newBrew.brew.coffeeAmountString + newBrew.brew.coffeeUnit.rawValue))
                logEntryRow(label: "Water Amount", value: "TODO")
                logEntryRow(label: "Water Temperature", value: (newBrew.brew.temperatureString + newBrew.brew.temperatureUnit.rawValue))
                Spacer()
            }
            .foregroundColor(Color("black"))
            .padding()
            .background(Color("lightTan"))
            .edgesIgnoringSafeArea(.bottom)
    }
    
    func logEntryRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
            Spacer()
            Text(value)
        }
        .font(.headline)
    }
    var pauseButton: some View {
        Button(action: pauseTimer) {
            HStack {
                Spacer()
                Text("Pause Timer")
                    .foregroundColor(Color("gold"))
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("brown"))
            )
            .padding()
        }
    }
    var startButton: some View {
        Button(action: startTimer) {
            HStack {
                Spacer()
                Text("Start Timer")
                    .foregroundColor(Color("gold"))
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("brown"))
            )
            .padding()
        }
    }
    
    //MARK: Finish Button
    var finishButton: some View {
        Button(action: finish) {
            HStack {
                Spacer()
                Text("Finish Brew")
                    .foregroundColor(Color("gold"))
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("brown"))
            )
            .padding()
        }
    }
    
    func startTimer() {
        timer.start()
    }
    
    func pauseTimer() {
        timer.pause()
    }
    
    func autostart() {
        if settings.autoStartTimer {
            timer.startDelayed()
        }
    }
    
    func finish() {
        showSelf = false
        newBrew.brew.brewTime = Double(brewTime)
        timer.stop()
        newBrew.save()
    }
    
    var timerView: some View {
        HStack {
            Spacer()
            Text(String(format: "%02d:%02d:%1d", timer.minutesElapsed, timer.secondsElapsed, timer.millisecondsElapsed))
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color("black"))
            Spacer()
        }
    }
    
    struct viewConstants {
        static let logFieldSpacing: CGFloat = 20
    }
}

struct BrewTimerView_Previews: PreviewProvider {
    static let newBrew = NewBrew(method: BrewEquipment(id: 0, name: "Aeropress", type: "Immersion", notes: "Good", estTime: 6), beanName: "44 North", grind: "Coarse", brewTime: 5.5, waterTemp: 5, waterAmount: 5.5, coffeeAmount: 5.5)
    
    static var previews: some View {
        NavigationView {
            BrewTimerView(showSelf: .constant(true), newBrew: newBrew)
                .environmentObject(GlobalSettings())
        }
    }
}
