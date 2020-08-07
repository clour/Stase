//
//  PragredScrollView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/8/5.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct PragredScrollView<Content>: View where Content: View {
    var axes: Axis.Set = .vertical
    var reversed: Bool = false
    var scrollToEnd: Bool = false
    var content: () -> Content

    @State private var contentSize: CGFloat = .zero
    @State private var contentOffset: CGFloat = .zero
    @State private var scrollOffset: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            if self.axes == .vertical {
                self.vertical(geometry: geometry)
            } else {
                self.horizontal(geometry: geometry)
            }
        }
        .clipped()
    }

    private func vertical(geometry: GeometryProxy) -> some View {
        VStack {
            content()
        }
        .modifier(ViewHeightKey())
        .onPreferenceChange(ViewHeightKey.self) {
            self.updateSize(with: $0, outer: geometry.size.height)
        }
        .frame(height: geometry.size.height, alignment: (reversed ? .bottom : .top))
        .offset(y: contentOffset + scrollOffset)
        .animation(.easeInOut)
        .gesture(DragGesture()
            .onChanged { self.onDragChanged($0) }
            .onEnded { self.onDragEnded($0, outer: geometry.size.height) }
        )
    }
    
    private func horizontal(geometry: GeometryProxy) -> some View {
        HStack {
            content()
        }
        .modifier(ViewWidthKey())
        .onPreferenceChange(ViewWidthKey.self) {
            self.updateSize(with: $0, outer: geometry.size.width)
        }
        .frame(width: geometry.size.width, alignment: (reversed ? .trailing : .leading))
        .offset(x: contentOffset + scrollOffset)
        .animation(.easeInOut)
        .gesture(DragGesture()
            .onChanged { self.onDragChanged($0) }
            .onEnded { self.onDragEnded($0, outer: geometry.size.width) }
        )
    }

    private func onDragChanged(_ value: DragGesture.Value) {
        if self.axes == .vertical {
            self.scrollOffset = value.location.y - value.startLocation.y
        } else {
            self.scrollOffset = value.location.x - value.startLocation.x
        }
        
    }

    private func onDragEnded(_ value: DragGesture.Value, outer: CGFloat) {
        let scrollOffset = self.axes == .vertical ? value.predictedEndLocation.y - value.startLocation.y : value.predictedEndLocation.x - value.startLocation.x

        self.updateOffset(with: scrollOffset, outer: outer)
        self.scrollOffset = 0
    }

    private func updateSize(with size: CGFloat, outer: CGFloat) {
        let delta = self.contentSize - size
        self.contentSize = size
        if scrollToEnd {
            self.contentOffset = self.reversed ? size - outer - delta : outer - size
        }
        if abs(self.contentOffset) > .zero {
            self.updateOffset(with: delta, outer: outer)
        }
    }

    private func updateOffset(with delta: CGFloat, outer: CGFloat = .zero) {
        let limit = self.contentSize - outer

            if limit < .zero {
                 self.contentOffset = .zero
            } else {
                var proposedOffset = self.contentOffset + delta
                if (self.reversed ? proposedOffset : -proposedOffset) < .zero {
                    proposedOffset = 0
                } else if (self.reversed ? proposedOffset : -proposedOffset) > limit {
                    proposedOffset = (self.reversed ? limit : -limit)
                }
                self.contentOffset = proposedOffset
            }
        
        
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.height)
        })
    }
}

struct ViewWidthKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewWidthKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.width)
        })
    }
}

