import SwiftUI
import SwiftData

struct PeriodsRangeSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Query private var tables: [Table]
    @State var table: Table

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Time Range of Periods")) {
                    List {
                        ForEach(table.periods.sorted { $0.index < $1.index }, id: \.self) { period in // period[].indexの昇順に繰り返し
                            if period.index <= table.numOfPeriods {
                                HStack {
                                    Text("\(period.index)")
                                        .frame(width: 20)
                                    Divider()
                                    DatePicker("Start", selection: $table.periods[table.periods.firstIndex(of: period)!].startTime, in: getMinStartTime(period: period.index)..., displayedComponents: .hourAndMinute)
                                        .onChange(of: $table.periods[table.periods.firstIndex(of: period)!].startTime.wrappedValue) {
                                            setAppropriateTime()
                                            table.updateNotificationSetting()
                                        }
                                    Divider()
                                    DatePicker("End", selection: $table.periods[table.periods.firstIndex(of: period)!].endTime, in: getMinEndTime(period: period.index)..., displayedComponents: .hourAndMinute)
                                        .onChange(of: $table.periods[table.periods.firstIndex(of: period)!].endTime.wrappedValue) {
                                            setAppropriateTime()
                                            table.updateNotificationSetting()
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Time Range of Periods")
        .background(colorScheme == .dark ? .indigo.opacity(0.15) : .indigo.opacity(0.15))
        .scrollContentBackground(.hidden)
        .accentColor(colorScheme == .dark ? .indigo : .indigo)
    }
    
    func setAppropriateTime() {
        for period in table.periods {
            if period.startTime < getMinStartTime(period: period.index) {
                period.startTime = getMinStartTime(period: period.index)
            }
            if period.endTime < getMinEndTime(period: period.index) {
                period.endTime = getMinEndTime(period: period.index)
            }
        }
    }
    
    func getMinStartTime(period: Int) -> Date { // 設定できる開始時間の最小値
        var minStartTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0)) ?? Date()
        if period > 0 {
            minStartTime = table.getPeriod(index: period - 1).endTime
        }
        return minStartTime
    }
    
    func getMinEndTime(period: Int) -> Date { // 設定できる終了時間の最小値
        return table.getPeriod(index: period).startTime
    }
}
