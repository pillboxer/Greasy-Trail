import SwiftUI
import ComposableArchitecture
import UI
import Core
import Model

struct AddPerformanceView: View {
    
    @EnvironmentObject var viewStore: ViewStore<AddState, AddAction>
    
    var body: some View {
        HStack(alignment: .top) {
            firstColumnView
            secondColumnView
            thirdColumnView
        }
    }
}

extension AddPerformanceView {
    
    private var venue: Binding<String> {
        viewStore.binding(get: { $0.performanceVenueField },
                          send: { .updatePerformanceVenue($0) })
    }
    
    private var date: Binding<Date> {
        viewStore.binding(get: { $0.performanceDateField },
                          send: { .updatePerformanceDate($0) })
    }
    
    private var dateFormat: Binding<PerformanceDateFormat> {
        viewStore.binding(get: { $0.performanceDateFormat },
                          send: { .updatePerformanceDateFormat($0) })
    }
    
    private var firstColumnView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("add_performance_field_0")
                Spacer()
                Image(systemName: "building.columns.fill")
            }
            Divider().padding(.bottom, 10)
            HStack {
                NSTextFieldRepresentable(placeholder: "", text: venue)
                NSDatePickerRepresentable(date: date)
                    .frame(maxWidth: 80)
            }
            Picker("Date Format", selection: dateFormat) { 
                ForEach(PerformanceDateFormat.allCases, id: \.self) { format in
                    Text(format.description)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .font(.footnote)
    }
    
}

extension AddPerformanceView {
    
    private func bindingForLB(at index: Int) -> Binding<String> {
        return viewStore.binding(get: { state in
            guard index < state.performanceLBs.count else {
                return ""
            }
            let lbNumber = state.performanceLBs[index]
            if lbNumber == 0 {
                return ""
            } else {
                return String(lbNumber)
            }
        }, send: { .setLB(lbNumber: Int($0) ?? 0, index: index)})
    }
    
    private var secondColumnView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("add_performance_field_1").font(.footnote)
                    Spacer()
                    PlainOnTapButton(systemImage: "plus.circle") {
                        viewStore.send(.incrLBCount)
                    }
                }
                Divider().padding(.bottom)
                if !(viewStore.performanceLBs.isEmpty) {
                    ForEach(Array(viewStore.performanceLBs.enumerated()),
                            id: \.offset) { index, _ in
                        HStack {
                            NSTextFieldRepresentable(placeholder: "add_performance_field_1_placeholder",
                                                     text: bindingForLB(at: index))
                            PlainOnTapButton(systemImage: "minus.circle") {
                                viewStore.send(.removeLB(at: index))
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
}

extension AddPerformanceView {
    
    private func bindingForSong(at index: Int) -> Binding<String> {
        return viewStore.binding(get: { state in
            guard index < state.performanceSongs.count else {
                return ""
            }
            let song = state.performanceSongs[index]
            return song.title
        }, send: { .setSong(title: $0, index: index) })
    }
    
    private var thirdColumnView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("add_performance_field_2").font(.footnote)
                    Spacer()
                    PlainOnTapButton(systemImage: "plus.circle") {
                        viewStore.send(.incrSongCount)
                    }
                }
                Divider().padding(.bottom)
                ForEach(Array(viewStore.performanceSongs.enumerated()), id: \.offset) { index, _ in
                    HStack {
                        NSTextFieldRepresentable(placeholder: "add_performance_field_2_placeholder",
                                                 text: bindingForSong(at: index),
                                                 textColor: viewStore.performanceSongs[index].uuid ==
                            .invalid ? .red : nil)
                        PlainOnTapButton(systemImage: "minus.circle") {
                            viewStore.send(.removeSong(at: index))
                        }
                    }
                }
            }
            .padding()
            
        }
    }
}
