////
////  ContentView.swift
////  Dreamy
////
////  Created by Reynaldo Aguilar on 5/12/2024.
////
//
//import SwiftUI
//
//struct DraggingState {
//    private var isActive = false
//
//    private var translation: CGSize = .zero
//
//    var offset: CGSize {
//        translation
//    }
//
//    var scale: CGSize {
//        let value: CGFloat = 1 - min(max(translation.height, 0), 200) / 200 * 0.3
//
//        return CGSize(width: value, height: value)
//    }
//
//    var shouldDismiss: Bool {
//        translation.height > 100
//    }
//
//    mutating func update(translation: CGSize) {
//        if isActive || translation.height > 0 {
//            self.translation = translation
//            isActive = true
//        }
//    }
//
//    mutating func reset() {
//        isActive = false
//        translation = .zero
//    }
//}
//
//struct ContentView: View {
//    let spacing: CGFloat = 6
//
//    @State var selectedItem: CarouselItem?
//    @State var deselectingItem: CarouselItem?
//
//    @Namespace var transition
//
//    @State var draggingState: DraggingState = .init()
//
//    var body: some View {
//        ZStack {
//            carousel()
//                .opacity(selectedItem == nil ? 1 : 0)
//
//            if let selectedItem {
//                CarouselItemView(item: selectedItem)
//                    .matchedGeometryEffect(id: selectedItem.id, in: transition, isSource: true)
//
//                    .offset(draggingState.offset)
//                    .gesture(
//                        DragGesture(minimumDistance: 50)
//                            .onChanged { value in
//                                draggingState.update(translation: value.translation)
//                            }
//                            .onEnded { value in
//                                withAnimation {
//                                    if draggingState.shouldDismiss {
//                                        self.deselectingItem = selectedItem
//                                        self.selectedItem = nil
//                                        draggingState.reset()
//                                    } else {
//                                        draggingState.reset()
//                                    }
//                                }
//
//                                draggingState.reset()
//                            }
//                    )
//                    .frame(maxHeight: .infinity)
//                    .background(.ultraThinMaterial)
//            }
//        }
//        .frame(maxHeight: .infinity)
//        .background {
//            Color(white: 0.1).ignoresSafeArea(.all)
//        }
//    }
//
//    @ViewBuilder
//    func carousel() -> some View {
//
//        ScrollView(.horizontal, showsIndicators: false) {
//            MosaicLayout(viewportSize: CGSize(width: UIScreen.main.bounds.width, height: 100), spacing: spacing) {
//                ForEach(CarouselItem.allItem) { item in
//                    CarouselItemView(item: item)
//                        .matchedGeometryEffect(id: item.id, in: transition, isSource: item.id != selectedItem?.id)
//                        .zIndex(item.id == selectedItem?.id || item.id == deselectingItem?.id ? 1 : 0)
//                        .onTapGesture {
//                            withAnimation {
//                                draggingState.reset()
//                                self.selectedItem = item
//                                self.deselectingItem = nil
//                            }
//                        }
//                }
//            }
//        }
//        .scrollClipDisabled()
//        .scrollTargetBehavior(.paging)
//        // TODO: Clean up these spacings here and inside the layout
//        .padding(.leading, 2 * spacing)
//        .padding(.trailing, spacing)
//    }
//}
//
//#Preview {
//    ContentView()
//}
