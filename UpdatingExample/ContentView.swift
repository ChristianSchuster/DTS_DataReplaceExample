//
//  ContentView.swift
//  UpdatingExample
//
//  Created by Christian Schuster on 25.11.24.
//

import SwiftUI

struct ContentView: View {
    @State var model: WatchDataModel = WatchDataModel()
    var body: some View {
        NavigationView  {
            VStack() {
                
                Text("Version:\(model.version)")
                    .onAppear() {
                        if model.items.isEmpty {
                            model.debugReplaceArray(synchronize: true)              
                        }
                    }
                
                HStack {
                    Button() {
                        model.debugReplaceArray(synchronize: true)
                    } label: {
                        Text("Synchronize new array")
                    }.buttonStyle(.borderedProminent)
                    Button() {
                        model.debugReplaceArray(synchronize: false)
                    } label: {
                        Text("Replace array")
                    }.buttonStyle(.borderedProminent)
                        .tint(.red)
                }
                
                List() {
                    
                    Section() {
                        
                        //                        ForEach(model.items, id: \.id) { item in
                        ForEach($model.items, id: \.self) { $item in
                            
                            NavigationLink() {
                                
                                AddValueView(activityItem: item, completionHandler:{ newValue, activityItem in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.bouncy) {
                                            let reps = Int(newValue)
                                            item.currentValue += reps
                                            item.lastSubmittedValue = reps
                                            item.updateProgress()
                                            model.update(activityItem: item, reps: reps)
                                            
                                            
                                            
                                        }
                                    }
                                    
                                })
                                .navigationTitle(Text(item.name))
                                
                                
                            } label: {
                                
                                ActivityRowView2(activityItem: item)
                                
                            }
                            //.buttonStyle(.borderless)
                            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxHeight:20.0)
                            .listItemTint(.clear) // Removes the semitransparent rounded background
                        }
                    }
                }
                //.environment(\.defaultMinListRowHeight, 44)
                //.listStyle(.plain)
                
                .frame(maxHeight: .infinity)
                .navigationBarTitleDisplayMode(.large)
                
                
                
            } // Navigation Stack
            .padding(.top, -30.0)
            .padding(.top, 30.0)
            //.zIndex(-1 )
            .onChange(of: model.items) { old, newItems in
                print("Items updated: \(newItems)")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
