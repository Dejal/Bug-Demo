//
//  DemoRow.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-07.
//  Copyright © 2022 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

//struct ExperimentalView: View {
//    @State private var isExpanded = false
//    
//    var body: some View {
//        Button {
//            withAnimation {
//                isExpanded.toggle()
//            }
//        } label: {
//            Text(isExpanded ? "Collapse" : "Expand")
//        }
//        
//        VStack {
////            Text("Unchanging Header")
//            Text(isExpanded ? "Expanded content" : "Collapsed content")
//            
//            if isExpanded {
//                Text("More content")
//                Text("Yet more content")
//                Text("Another content")
//                Text("One more")
//                HStack {
//                    Button {
//                        
//                    } label: {
//                        Text("Cancel")
//                    }
//                    Button {
//                        
//                    } label: {
//                        Text("Save")
//                    }
//                }
//            } else {
//                Text("Some content")
//            }
//        }
//        .transition(.scale)
//    }
//}

//struct Collapsible<Content: View>: View {
//    @State var label: () -> Text
//    @State var content: () -> Content
//
//    @State private var collapsed: Bool = true
//
//    var body: some View {
//        VStack {
//            Button(
//                action: {
//                    withAnimation(.easeInOut(duration: 2)) {
//                        self.collapsed.toggle()
//                    }
//                },
//                label: {
//                    HStack {
//                        self.label()
//                        Spacer()
//                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
//                    }
//                    .padding(.bottom, 1)
//                    .background(Color.white.opacity(0.01))
//                }
//            )
//            .buttonStyle(PlainButtonStyle())
//
//            VStack {
//                self.content()
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
//            .clipped()
////            .animation(.easeOut)
//            .transition(.slide)
//        }
//    }
//}
//
//struct ExperimentalView: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Collapsible { Text("Collapsible") }
//        content: {
//                Text("Content")
//                    .padding()
//                    .background(Color.red)
//                    .transition(.scale)
//            }
//            Spacer(minLength: 0)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}

//struct ExpandViewer <Content: View>: View {
//
//    @State private var isExpanded = false
//    @ViewBuilder let expandableView : Content
//
//    var body: some View {
//        VStack {
//
//            Button(action: {
//                withAnimation(.easeIn(duration: 0.5)) {
//                    self.isExpanded.toggle()
//                }
//
//            }){
//                Text(self.isExpanded ? "Hide" : "View")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
//                    .background(.blue)
//                    .cornerRadius(5.0)
//            }
//
//            if self.isExpanded {
//                self.expandableView
//            }
//
//        }
//
//    }
//}

//struct ExperimentalView: View {
//    var body: some View {
//        ExpandViewer {
//            Text("Hidden Text")
//            Text("Hidden Text")
//        }
//        .transition(.move(edge: .bottom))
//    }
//}

//struct ExperimentalView: View {
//
//    @State var isExpanded = false
//    @State var subviewHeight : CGFloat = 0
//
//    var body: some View {
//        VStack {
//            Text("Headline")
//            VStack {
//                Text("More Info")
//                Text("And more")
//                Text("And more")
//                Text("And more")
//                Text("And more")
//                Text("And more")
//            }
//        }
//        .background(GeometryReader {
//            Color.clear.preference(key: ViewHeightKey.self,
//                                   value: $0.frame(in: .local).size.height)
//        })
//        .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
//        .frame(height: isExpanded ? subviewHeight : 50, alignment: .top)
//        .padding()
//        .clipped()
//        .frame(maxWidth: .infinity)
//        .transition(.move(edge: .bottom))
//        .background(Color.gray.cornerRadius(10.0))
//        .onTapGesture {
//            withAnimation(.easeIn(duration: 2.0)) {
//                isExpanded.toggle()
//            }
//        }
//    }
//}
//
//struct ViewHeightKey: PreferenceKey {
//    static var defaultValue: CGFloat { 0 }
//    static func reduce(value: inout Value, nextValue: () -> Value) {
//        value = value + nextValue()
//    }
//}

struct DemoRow: View {
    @EnvironmentObject var model: Model
    
    @State private var isHover = false
    @State private var isEditingTravel = false
    
    var row: Row
    
    var body: some View {
        if row.showMoreButton {
            Button("Previous Week") {
                model.load(more: true)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
        if isEditingTravel {
            TravelForm(isEditingTravel: $isEditingTravel, row: row)
                .transition(.slide)
        } else {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    WeatherDate(isHover: isHover, row: row)
                    
                    Text("\(row.title)")
                        .foregroundColor(isEditingAnyRow ? .secondary : .primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                
                HStack(alignment: .firstTextBaseline) {
                    Text(row.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 5)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 100, alignment: .trailing)
                    
                    Text(row.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .background(RoundedRectangle(cornerRadius: 6, style: .continuous)
                .foregroundColor(isHover ? .accentColor : .clear)
                .padding([.top, .bottom], -6)
                .padding([.leading, .trailing], -10))
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 3)
            //        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .onHover(perform: { hover in
                isHover = !isEditingAnyRow && hover
            })
            .onTapGesture {
                if isEditingAnyRow {
                    return
                }
                
                model.editingTravel = model.travel(onOrBefore: row.day)
                
                withAnimation(.easeInOut) {
                    isEditingTravel = true
                }
            }
        }
    }
    
    var isEditingAnyRow: Bool {
        return model.editingTravel != Travel.none
    }
    
    var isEditingThisRow: Bool {
        return model.editingTravel.day == row.day
    }
    
    var isEditingAnotherRow: Bool {
        return model.editingTravel != Travel.none && model.editingTravel.day != row.day
    }
}

struct DemoRow_Previews: PreviewProvider {
    static var previews: some View {
        DemoRow(row: Row(day: .today, title: "⛅️ 70↑ 40↓", detail: "Notes here", location: "Somewhere, US", showMoreButton: false))
            .environmentObject(Model.shared)
    }
}

struct WeatherDate: View {
    @EnvironmentObject var model: Model
    
    var isHover = false
    var row: Row
    
    var body: some View {
        if Calendar.current.isDateInToday(row.day.noon) {
            HStack {
                Spacer()
                Text("\(row.dateString)")
                    .padding([.leading, .trailing], 7)
                    .bold()
                    .foregroundColor(.black)
                    .background(isEditingAnyRow ? Color.secondary : (isHover ? .white : .accentColor))
                    .clipShape(Capsule())
            }
            .padding(.trailing, 5)
            .frame(maxWidth: 100, alignment: .trailing)
            // not sure what this was for?
            //                    .alignmentGuide(.trailing) { d in d[.trailing] }
        } else {
            Text("\(row.dateString)")
                .padding(.trailing, 5)
                .frame(maxWidth: 100, alignment: .trailing)
                .foregroundColor(isEditingAnyRow ? .secondary : .primary)
            // not sure what this was for?
            //                        .alignmentGuide(.trailing) { d in d[.trailing] }
        }
    }
    
    var isEditingAnyRow: Bool {
        return model.editingTravel != Travel.none
    }
}
