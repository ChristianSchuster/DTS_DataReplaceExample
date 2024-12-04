//
//  ActivityAddView.swift
//  Set Buddy
//
//  Created by Christian Schuster on 20.09.23.
//

import SwiftUI

/// This is the view where the user goes to when
/// tapping on an activity.
struct AddValueView: View {
    
    @Bindable var activityItem: MyObservableItem
    
    @State var backgroundColor: Color = .pink
    
    // Keep track of the digital crown scrolling
    @State var crownScroll = 0.0
    @State var minValue = true
    @State var maxValue = false
    
    @State private var usageTipVisibility: Visibility = .visible
    @State private var zoom: CGFloat = 1.0
    var max = 100.0
    
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("understandsCrown") var understandsCrown: Bool = false
    
    // Completion handler
    @State var completionHandler: ((Double, MyObservableItem)->())?
    
    
    var body: some View {
        
        
            
            
            VStack() {
                
                Spacer() // Push button down
                
                
                    
                    
                    
                    Text("\(String(format: "%0.0f", crownScroll))")
                        .scaleEffect(CGSize(width: zoom, height: zoom))
                        .font(.system(size: 60.0, weight: .black, design: .monospaced))
                        .focusable()
                        .scrollBounceBehavior(.basedOnSize)
                                            
        //                .sensoryFeedback(trigger: crownScroll, { oldValue, newValue in
        //                    if ( newValue == max && oldValue != max ) {
        //                        return .increase
        //                    } else if (newValue == 0.0 && oldValue != 0.0) {
        //                        return .decrease
        //                    } else {
        //                        return .selection
        //                    }
        //                })

        //                .sensoryFeedback(.impact, trigger: crownScroll) { oldValue, newValue in
        //                    newValue == max && oldValue != max ? true : false
        //                }
        //                .sensoryFeedback(.impact(weight: .heavy, intensity: 100.0), trigger: crownScroll) { oldValue, newValue in
        //                    newValue == 0.0 && oldValue != 0.0 ? true : false
        //                }
                    
                    #if os(watchOS)
                        
                        .digitalCrownAccessory {
                                        
                                        HStack() {
                                            Text("Rotate to Adjust reps")
                                                .font(.system(.footnote))
                                                .lineLimit(5)
                                                .multilineTextAlignment(.trailing)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: 60.0)
                                            Image(systemName: "digitalcrown.arrow.clockwise").imageScale(.large)
                                        }
                                        .padding()
                                        .background(.regularMaterial ,in: RoundedRectangle(cornerRadius: 25.0, style: .continuous), fillStyle: FillStyle())
                                        
                                        
                                        
                                    }
                                    
                                    .onAppear() {
                                        
                                    }
                                    .digitalCrownAccessory(understandsCrown ? .hidden : .visible)
        #endif
                
                
                
                
                
                
                
//                Spacer() // Push button down
                
                Button(action: {
                    
                    // Call the completion handler with the crown value
                    if let completionHandler = completionHandler {
                        completionHandler(crownScroll, activityItem)
                    }
                    
                    // Dismiss the AddRepsView
                    dismiss()
                    
                }, label: {
                    Text("Add")
//                    Text("Wert Hinzufügen")
                        .lineLimit(2)
                        .foregroundStyle(.white)
                        
                        .font(.system(size: 22, weight: .black, design: .default))
                        .kerning(0.5)
//                        .minimumScaleFactor(0.7)
                        .bold()
//                        .padding(.horizontal, 30.0)
                        .padding(.horizontal, 10.0)
                        .padding(.vertical, 20.0)
                        .frame(maxWidth:.infinity)
                        .background() {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                .foregroundStyle(.blue)
                                .blendMode(.normal)
                }
                        
                    
                })
                .buttonStyle(.borderless)
                .padding(.bottom, 14.0)
                .padding(.horizontal, 20)
                
                
            
                

            
            
        }
            
        // Set the crownscroll initially to the last submitted reps of this activity item.
        .onChange(of: activityItem, initial: true, { oldValue, newValue in
            self.crownScroll = CGFloat(integerLiteral: activityItem.lastSubmittedValue)
            self.backgroundColor = Color(from: activityItem.colorString)
        })
        // Make it full screen.
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Fill the backgound with a gradient
 
        
        
            
    }
    
    
    /// Stores the crown value in the standard user defautlts.
    private func didUseCrown(_ understandsCrown: Bool) {
        
        UserDefaults.standard.setValue(understandsCrown, forKey: "understandsCrown")
        UserDefaults.standard.synchronize()
        
    }
    
}

#Preview {
    AddValueView(activityItem:  MyObservableItem.exampleItems(.small).first!)
}
