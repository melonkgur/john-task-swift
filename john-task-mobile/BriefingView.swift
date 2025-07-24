//
//  BriefingView.swift
//  john-task-mobile
//
//  Created by Milo Woodman on 7/23/25.
//

import SwiftUI

struct BriefingView: View {
    @EnvironmentObject private var viewModel: BriefingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let err = viewModel.requestError {
            ZStack {
                // x button to exit the view
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                        }.padding()
                        
                        Spacer()
                    }.padding()
                    
                    Spacer()
                }
                
                Text(err.localizedDescription)
            }
        } else {
            GeometryReader { geometry in
                ZStack {
                    TabView(selection: $viewModel.storyIndex) {
                        ForEach(viewModel.briefs.indices) { i in
                            
                            // article content
                            ZStack {
                                
                                VStack {
                                    Spacer()
                                    
                                    // title
                                    Text(viewModel.briefs[i].title)
                                        .padding()
                                        .monospaced()
                                        .foregroundStyle(.white)
                                        .font(.system(size: 40))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .shadow(color: .black, radius: 4)
                                    
                                    Spacer()
                                    Spacer()
                                }
                                
                                VStack {
                                    Spacer()
                                    
                                    VStack {
                                        // summary/snippet
                                        Text(viewModel.briefs[i].text)
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.white)
                                            .padding([.top, .leading, .trailing])
                                        
                                        // ticker and link to article
                                        HStack {
                                            Text(viewModel.briefs[i].symbol)
                                                .monospaced()
                                                .bold()
                                                .foregroundStyle(.white)
                                            
                                            Spacer()
                                            
                                            if let articleUrl = URL(string: viewModel.briefs[i].url) {
                                                Link(destination: articleUrl) {
                                                    Text("Read More")
                                                }.buttonStyle(.borderedProminent)
                                                    .buttonBorderShape(.roundedRectangle(radius: 25))
                                            }
                                            
                                        }.padding()
                                            .background(
                                                .black.opacity(0.1),
                                                in: .rect(
                                                    cornerRadii: RectangleCornerRadii(
                                                        topLeading: 0,
                                                        bottomLeading: 25,
                                                        bottomTrailing: 25,
                                                        topTrailing: 0
                                                    )
                                                )
                                            )
                                            .shadow(radius: 0)
                                    }.background(.ultraThinMaterial, in: .rect(cornerRadius: 25))
                                        .shadow(radius: 10)
                                }
                            }.ignoresSafeArea(.all)
                                .padding()
                                .tag(i)
                                .background(alignment: .center) {
                                    // background image for each
                                    // adjusted for size, overlayed
                                    // with a gradient and darkened
                                    if let image = viewModel.images[i] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .scaledToFill()
                                            .clipped()
                                            .overlay(
                                                .linearGradient(
                                                    colors: [
                                                        .black,
                                                        .black.opacity(0.5),
                                                        .black.opacity(0.5),
                                                        .black
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                    } else {
                                        Color(UIColor.darkGray)
                                    }
                                }.clipped()
                        }
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                        .background(.black)
                    
                    // x button to exit the view
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }.padding()
                            
                            Spacer()
                        }.padding()
                        
                        Spacer()
                    }
                    
                    // article count and index indicator
                    VStack {
                        HStack {
                            ForEach(viewModel.briefs.indices) { i in
                                
                                // this might have also been able to be written using dividers?
                                Spacer()
                                    .frame(height: 3)
                                    .background(
                                        {
                                            if (i == viewModel.storyIndex) {
                                                return Color.white;
                                            } else {
                                                return Color.gray
                                            }
                                            
                                        }(),
                                        in: .rect(cornerRadius: 5)
                                    ).padding(0.5)
                            }
                        }.padding(.horizontal)
                        
                        Spacer()
                    }
                }.onTapGesture() { location in
                    // tap guesture like that of instagram stories:
                    // left third moves back, right two thirds move forward
                    // excludes regions towards the bottom and top of the
                    // screen to reduce misclicks.
                    // includes haptic feedback.
                    let xPos = location.x / geometry.size.width;
                    let yPos = location.y / geometry.size.height;
                    
                    guard yPos > 0.1 && yPos < 0.9 else { return }
                    
                    if xPos < 0.3 {
                        if viewModel.storyIndex > 0 {
                            viewModel.storyIndex -= 1;
                            
                            UINotificationFeedbackGenerator()
                                .notificationOccurred(.success);
                        } else {
                            dismiss()
                        }
                    } else {
                        if viewModel.storyIndex < viewModel.briefs.count - 1 {
                            viewModel.storyIndex += 1;
                            
                            UINotificationFeedbackGenerator()
                                .notificationOccurred(.success);
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    NavigationView {
        BriefingView()
    }.environmentObject(BriefingViewModel())
}
