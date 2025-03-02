// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct AboutModalView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                // Icon & Title
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(HapticButtonStyle(isCancellation: true))
                    }
                    
                    Image(systemName: "sun.horizon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("About WarmShift")
                        .font(.title2)
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color(UIColor.tertiarySystemBackground))
                
                VStack(spacing: 0) {
                    // Scrollable Text
                    ZStack {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("""
                                Designed for efficiency and usability, WarmShift is the perfect tool for quick, image natural-looking enhancements.
                                """)
                                .fontDesign(.rounded)
                                .foregroundColor(.secondary)
                                
                                Text("Effortless color temperature adjustments for your photos.")
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                    .foregroundColor(.primary)
                                
                                Text("""
                                WarmShift is a simple yet powerful iOS app that lets you fine-tune the color temperature of your photos with ease.
                                """)
                                .fontDesign(.rounded)
                                .foregroundColor(.secondary)
                                
                                Text("""
                                Using OpenCV for high-performance image processing and SwiftUI for an intuitive interface, WarmShift enables smooth real-time adjustments to make your images warmer or cooler.
                                """)
                                .fontDesign(.rounded)
                                .foregroundColor(.secondary)
                                
                                Text("""
                                © 2025 Ardyan - Pattern Matters. All rights reserved.
                                """)
                                .font(.caption)
                                .fontDesign(.rounded)
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 20)
                        }
                        
                        VStack {
                            LinearGradient(gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground), Color.clear]),
                                           startPoint: .top, endPoint: .bottom)
                            .frame(height: 50)
                            
                            Spacer()
                            
                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color(UIColor.secondarySystemBackground)]),
                                           startPoint: .top, endPoint: .bottom)
                            .frame(height: 50)
                        }
                        .allowsHitTesting(false)
                    }
                    .frame(maxHeight: 300)
                    
                    // "Got It" Button
                    Button(action: { isPresented = false }) {
                        Text("Got It")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .buttonStyle(HapticButtonStyle(isCancellation: true))
                    .padding([.horizontal, .bottom], 20)
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .frame(maxWidth: 500)
            .padding(16)
        }
    }
}
