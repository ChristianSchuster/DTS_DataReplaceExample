//
//  ActivityItemView.swift
//  Set Buddy
//
//  Created by Christian Schuster on 19.09.23.
//

import SwiftUI

/// This is the row view that represents an activity.
/// It displays the total reps target if there are no reps submitted, otherwise
/// it displays the current reps.
/// Also the progress is visualised like a progress bar.
struct ActivityRowView2: View {
    
    let activityItem: MyObservableItem
        
    @State var progress = 0.1
    @State var color: Color = .blue
    @State private var repsSize: CGSize = .zero
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack() {

                
                // The main background shape
                Rectangle()
                    .frame(height: 44.0)
                    .foregroundStyle(color.opacity(0.4))
                    .background {
                        // Visualize progress with main color
                        ZStack {
                            
                            // * * * * * Item title light
                            HStack {
                                Text(activityItem.name)
                                    //.activityItemTitle()
                                Spacer()
                            }
                            //.dynamicMask(trailingPadding: repsSize.width)

                            
                            // * * * * * Progress fill
                            HStack() {
                                Rectangle()
                                    .foregroundStyle(color)
                                    .frame(height: 44.0)
                                    .frame(width: min( geometry.size.width * max(activityItem.progress, 0.05), geometry.size.width ))
                                    
                                
                                Spacer()
                            
                              
                            }
                            .clipped()
                            
                        }
                    }


                
                
                
                
                HStack() {
                    
//                    // Item title
//                    Text(activityItem.name)
//                        .activityItemTitle()
                    
                    Spacer()
                    
                    
                    if (activityItem.currentValue > 0) {
                        
                        // Item count
                        Text("\(activityItem.currentValue)")
                            .padding(.trailing, 12)
                            .fontWeight(.heavy)
                            .font(.title)
                            .opacity(0.80)
                            
                            
                        
                    } else {
                        
                        // Item count
                        Text("\(activityItem.targetValue)")
                            .padding(.trailing, 12)
                            .fontWeight(.heavy)
                            .font(.title)
                            .opacity(0.33)
                            .blendMode(.luminosity)
                            //.observeSize($repsSize)
                        
                    }
                    
                }
                
                
                // Second transparent fill, full width shape
                RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                    .frame(height: 44.0)
                    .foregroundStyle(.blue.opacity(0.0))
                    .overlay {
                        
                        // Activity text as overlay
                        HStack {
                            Text(activityItem.name)
                                //.activityItemTitle()
                                .foregroundStyle(.black)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .clipped()
                                
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //.dynamicMask(trailingPadding: repsSize.width)
                        
                    }
                    .mask {
                        
                        // Mask is a copy of the progress shape
                        HStack {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .foregroundStyle(color)
                                .frame(height: 44.0)
                                .frame(width: min( geometry.size.width * max(activityItem.progress, 0.1), geometry.size.width ))
                            Spacer()
                        }
                    }
                
                
                    
            }
            .onChange(of: activityItem, initial: true) { oldValue, newValue in
                //color = Color(from: newValue.colorString)
                //self.progress = Double(newValue..currentReps / newValue.totalRepsTarget)
            }
            .onChange(of: activityItem.colorString, initial: true) {
                color = .red//Color(from: activityItem.colorString)
            }
            //.debugOverlay("\(repsSize.width)", placement: .topLeading)
            
        }
        
        
        
        
    }
    
    
   
    
}



struct ActivityPreview2: View {
    var body: some View {
        List() {
            ActivityRowView2(activityItem:  MyObservableItem(id: UUID(uuidString: UUID().uuidString)!, name: "Mario", colorString: Color.yellow.rgbaString(), currentValue: 30, targetValue: 150, lastSubmittedValue: 0))
                
            ActivityRowView2(activityItem: MyObservableItem(id: UUID(uuidString: UUID().uuidString)!, name: "Luigi", colorString: Color.pink.rgbaString(), currentValue: 0, targetValue: 150, lastSubmittedValue: 0))
                
            ActivityRowView2(activityItem: MyObservableItem(id: UUID(uuidString: UUID().uuidString)!, name: "Toad", colorString: Color.blue.rgbaString(), currentValue: 120, targetValue: 150, lastSubmittedValue: 0))

        }
        .listItemTint(.clear)

            
    }
}


#Preview {
    MainActor.assumeIsolated {
        ActivityPreview2()
            
    }
}
