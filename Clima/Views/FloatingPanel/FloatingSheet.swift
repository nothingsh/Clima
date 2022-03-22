//
//  FloatingSheet.swift
//  Clima
//
//  Created by Steven Zhang on 3/14/21.
//

import SwiftUI

fileprivate struct FloatingSheetView<hContent: View, mContent: View>: View {
    @State private var layoutMode: LayoutMode = .portrait
    @State private var translation: CGPoint = CGPoint(x: 0, y: 0)
    @State private var bottomSheetPosition: OffsetRatio = .hidden
    private let hasBottomPosition: Bool
    private let showCancelButton: Bool
    private let headerContent: hContent?
    private let mainContent: mContent
    private let closeAction: () -> ()
    
    private let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    @State var backgroundBlur = false
    private let allCases = OffsetRatio.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    fileprivate var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .dark).edgesIgnoringSafeArea(.all)
                .opacity(self.backgroundBlur ? 1 : 0)
                .animation(.spring())
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top capsule
                Capsule()
                    .fill(Color.tertiaryLabel)
                    .frame(width: 40, height: 6)
                    .padding(.top)
                    .contentShape(Capsule())
                    .onTapGesture {
                        if layoutMode == .portrait {
                            self.switchPositionIndicator()
                        }
                        
                        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                    }
                
                // Header
                if self.headerContent != nil || self.showCancelButton {
                    HStack(alignment: .top, spacing: 0) {
                        if self.headerContent != nil {
                            self.headerContent!
                        }
                        
                        Spacer()
                        
                        if self.showCancelButton {
                            Button(action: {
                                if let hidden = OffsetRatio(rawValue: 0) {
                                    self.bottomSheetPosition = hidden
                                }
                                
                                self.closeAction()
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.tertiaryLabel)
                            }
                            .font(.title)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.backgroundBlur = true
                                if (layoutMode == .portrait) {
                                    self.translation.y = value.translation.height
                                } else {
                                    self.translation = CGPoint(x: value.translation.width, y: value.translation.height)
                                }
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                            .onEnded { value in
                                if (layoutMode == .portrait) {
                                    self.switchPosition(with: value.translation.height / geometry.size.height)
                                } else {
                                    self.switchPosition(with: value.translation.width / geometry.size.width)
                                }

                                self.translation = CGPoint(x: 0, y: 0)
                                self.backgroundBlur = false
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, self.isBottomPosition() ? geometry.safeAreaInsets.bottom + 25 : 0)
                }
                
                self.mainContent
                    .transition(.move(edge: .bottom))
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, (layoutMode == .portrait) ? geometry.safeAreaInsets.bottom : 0)
            }
            .edgesIgnoringSafeArea((layoutMode == .portrait) ? .bottom : .init())
            .background(
                EffectView(effect: UIBlurEffect(style: .systemMaterial))
                    .cornerRadius(25, corners: [.topRight, .topLeft])
                    .edgesIgnoringSafeArea((layoutMode == .portrait) ? .bottom : .init())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.backgroundBlur = true
                                if (layoutMode == .portrait)  {
                                    self.translation.y = value.translation.height
                                } else {
                                    self.translation = CGPoint(x: value.translation.width, y: value.translation.height)
                                }
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                            .onEnded { value in
                                if (layoutMode == .portrait) {
                                    self.switchPosition(with: value.translation.height / geometry.size.height)
                                } else {
                                    self.switchPosition(with: value.translation.width / geometry.size.width)
                                }

                                self.translation = CGPoint(x: 0, y: 0)
                                self.backgroundBlur = false
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                    )
            )
            .frame(
                width: (layoutMode == .portrait) ?
                    geometry.size.width :
                    geometry.size.width*0.45,
                height: (layoutMode == .portrait) ?
                    max((geometry.size.height * self.bottomSheetPosition.rawValue) - self.translation.y, 0) :
                    geometry.size.height,
                alignment: .top)
            .offset(x: (layoutMode == .portrait) ? 0 :
                        geometry.size.width*self.bottomSheetPosition.properSize(mode: layoutMode)+self.translation.x,
                    y: (layoutMode == .portrait) ?
                        (self.bottomSheetPosition.rawValue == 0 ?
                            geometry.size.height + geometry.safeAreaInsets.bottom : self.isBottomPosition() ?
                            geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation.y + geometry.safeAreaInsets.bottom : geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation.y) : geometry.size.height*0.05 + self.translation.y
            )
            .transition(.move(edge: .bottom))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
        }
        }
        .onAppear(perform: {
            initialLayout()
        })
        .onReceive(orientationChanged, perform: { _ in
            deviceRotation()
        })
    }
    
    private func deviceRotation() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isPortrait {
                layoutMode = .portrait
            } else if UIDevice.current.orientation.isLandscape {
                layoutMode = .landscape
            }
        } else {
            layoutMode = .landscape
        }
    }
    
    private func initialLayout() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isPortrait {
                layoutMode = .portrait
            } else if UIDevice.current.orientation.isLandscape {
                layoutMode = .landscape
            }
            bottomSheetPosition = .middle
        } else {
            layoutMode = .landscape
            bottomSheetPosition = .middle
        }
    }
    
    
    private func switchPositionIndicator() -> Void {
        if self.bottomSheetPosition.rawValue != 0 {
            
            if let currentIndex = self.allCases.firstIndex(where: { $0 == self.bottomSheetPosition }), self.allCases.count > 1 {
                if currentIndex == self.allCases.endIndex - 1 {
                    if self.allCases[currentIndex - 1].rawValue != 0 {
                        self.bottomSheetPosition = self.allCases[currentIndex - 1]
                    }
                } else {
                    self.bottomSheetPosition = self.allCases[currentIndex + 1]
                }
            }
        }
    }
    
    private func switchPosition(with length: CGFloat) -> Void {
        if self.bottomSheetPosition.rawValue != 0 {
            
            if let currentIndex = self.allCases.firstIndex(where: { $0 == self.bottomSheetPosition }), self.allCases.count > 1 {
                // Portrait Mode
                if self.layoutMode == .portrait {
                    if length <= -0.1 && length > -0.3 {
                        if currentIndex < self.allCases.endIndex - 1 {
                            self.bottomSheetPosition = self.allCases[currentIndex + 1]
                        }
                    } else if length <= -0.3 {
                        self.bottomSheetPosition = self.allCases[self.allCases.endIndex - 1]
                    } else if length >= 0.1 && length < 0.3 {
                        if currentIndex > self.allCases.startIndex, self.allCases[currentIndex - 1].rawValue != 0 {
                            self.bottomSheetPosition = self.allCases[currentIndex - 1]
                        }
                    } else if length >= 0.3 {
                        if self.allCases[self.allCases.startIndex].rawValue != 0 {
                            self.bottomSheetPosition = self.allCases[self.allCases.startIndex]
                        } else {
                            self.bottomSheetPosition = self.allCases[self.allCases.startIndex + 1]
                        }
                    }
                    
                } else { // Landscape Mode
                    if length <= -0.3 {
                        self.bottomSheetPosition = self.allCases[self.allCases.endIndex - 2]
                    } else if length >= 0.3 {
                        self.bottomSheetPosition = self.allCases[self.allCases.endIndex - 1]
                    }
                }
            }
        }
    }
    
    private func isBottomPosition() -> Bool {
        if self.hasBottomPosition,
           let bottomPositionRawValue = self.allCases.first(where: { $0.rawValue != 0})?.rawValue {
            return self.bottomSheetPosition.rawValue == bottomPositionRawValue
        } else {
            return false
        }
    }
    
    
    fileprivate init(hasBottomPosition: Bool = true,
                     showCancelButton: Bool = false,
                     @ViewBuilder headerContent: () -> hContent?,
                     @ViewBuilder mainContent: () -> mContent,
                     closeAction: @escaping () -> () = {}
    ) {
        self.hasBottomPosition = hasBottomPosition
        self.showCancelButton = showCancelButton
        self.headerContent = headerContent()
        self.mainContent = mainContent()
        self.closeAction = closeAction
    }
}

fileprivate extension FloatingSheetView where hContent == ModifiedContent<ModifiedContent<Text, _EnvironmentKeyWritingModifier<Optional<Int>>>, _PaddingLayout> {
    init(hasBottomPosition: Bool = true,
        showCancelButton: Bool = false,
        title: String? = nil,
        @ViewBuilder content: () -> mContent,
        closeAction: @escaping () -> () = {}
    ) {
        if title == nil {
            self.init(hasBottomPosition: hasBottomPosition, showCancelButton: showCancelButton, headerContent: { return nil }, mainContent: content, closeAction: closeAction)
        } else {
            self.init(hasBottomPosition: hasBottomPosition, showCancelButton: showCancelButton, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1).padding(.bottom) as? hContent }, mainContent: content, closeAction: closeAction)
        }
    }
}

public extension View {
    internal func floatingSheet<hContent: View, mContent: View>(
        hasBottomPosition: Bool = true,
        showCancelButton: Bool = false,
        @ViewBuilder headerContent: () -> hContent?,
        @ViewBuilder mainContent: () -> mContent,
        closeAction: @escaping () -> () = {}
    ) -> some View {
        ZStack {
            self
            FloatingSheetView(hasBottomPosition: hasBottomPosition, showCancelButton: showCancelButton, headerContent: headerContent, mainContent: mainContent, closeAction: closeAction)
        }
    }
    
    internal func floatingSheet<mContent: View>(
        hasBottomPosition: Bool = true,
        showCancelButton: Bool = false,
        title: String? = nil,
        @ViewBuilder content: () -> mContent,
        closeAction: @escaping () -> () = {}
    ) -> some View {
        ZStack {
            self
            FloatingSheetView(hasBottomPosition: hasBottomPosition, showCancelButton: showCancelButton, title: title, content: content, closeAction: closeAction)
        }
    }
}

struct FloatingSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
    
    struct PreviewView: View {

        @State var bottomSheetPosition: OffsetRatio = .middle
        
        var body: some View {
            Color.green
                .edgesIgnoringSafeArea(.all)
                .floatingSheet(
                    showCancelButton: false,
                    title: "Hello",
                    content: {
                    ScrollView {
                        ForEach(0..<150) { index in
                            Text(String(index))
                        }
                        .frame(maxWidth: .infinity)
                    }
                })
        }
    }
}

