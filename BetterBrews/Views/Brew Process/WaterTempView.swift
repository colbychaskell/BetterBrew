//
//  WaterTempView.swift
//  BetterBrews
//
//  Created by Colby Haskell on 8/11/21.
//

import SwiftUI

struct WaterTempView: View {
    @Binding var showSelf: Bool
    @ObservedObject var newBrew: NewBrew
    
    var body: some View {
        UITableView.appearance().backgroundColor = UIColor(named: "tan")
        
        let waterForm = waterTempForm
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Prepare Water")
        
        return waterForm
    }
    
    var waterTempForm: some View {
        Form {
            Section(header: Text("Water Temperature").foregroundColor(Color("black"))) {
                TextField("Temperature", text: $newBrew.brew.temperatureString)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.white)
                    .accentColor(AppStyle.accentColor)
                Picker("Units", selection: $newBrew.brew.temperatureUnit) {
                    Text("Celcius").tag(TemperatureUnit.celcius)
                    Text("Farenheit").tag(TemperatureUnit.farenheit)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .listRowBackground(viewConstants.listRowBackground)
            Section(header: Text("Water Measured").foregroundColor(Color("black"))) {
                TextField("Amount", text: $newBrew.brew.waterAmountString)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.white)
                    .accentColor(AppStyle.accentColor)
                Picker("Units", selection: $newBrew.brew.waterVolumeUnit) {
                    Text("mL").tag(WaterVolumeUnit.mL)
                    Text("Grams").tag(WaterVolumeUnit.g)
                    Text("Cups").tag(WaterVolumeUnit.cups)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .listRowBackground(viewConstants.listRowBackground)
            Section(header: Text("Timer").foregroundColor(Color("black"))) {
                NavigationLink("Time and Rating", destination: RatingView(showSelf: $showSelf, newBrew: newBrew))
                    .disabled(newBrew.brew.temperatureString == "" || newBrew.brew.waterAmountString == "")
                    .foregroundColor(viewConstants.linkColor)
            }
            .listRowBackground(viewConstants.listRowBackground)
        }
        .foregroundColor(Color("black"))
        .padding(.top)
        .background(Color("tan"))
    }
    
    //MARK: - Functions
    func fillRecommended() {
        newBrew.brew.temperatureString = "100"
        newBrew.brew.waterAmountString = "500"
    }
    
    struct viewConstants {
        static let listRowBackground = Color("brown")
        static let linkColor = Color("gold")
    }
}

struct WaterTempView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WaterTempView(showSelf: .constant(true), newBrew: NewBrew(BrewEquipment(id: 0, name: "Aeropress", type: "Immersion", notes: "good", estTime: 6, filters: ["Immersion"])))
        }
    }
}
