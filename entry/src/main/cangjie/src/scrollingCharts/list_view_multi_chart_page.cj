/**
 * Created on 2024/9/7
 */
package ohos_app_cangjie_entry.scrollingCharts

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.scrollingCharts.listViewItems.*

@Entry
@Component
class ListViewMultiChartPage {
    var list: ArrayList<Any> = ArrayList<Any>()

    protected override func aboutToAppear() {
        // 30 items
        for (i in 0..12) {
            if (i % 3 == 0) {
                this.list.append(this.generateDataLine(i + 1))
            } else if (i % 3 == 1) {
                this.list.append(this.generateDataBar(i + 1))
            } else if (i % 3 == 2) {
                this.list.append(this.generateDataPie())
            }
        }
    }

    public let COLORFUL_COLORS: Array<UInt32> = [UInt32(ChartColor.rgb(193, 37, 82)), UInt32(ChartColor.rgb(255, 102, 0)),
    UInt32(ChartColor.rgb(245, 199, 0)), UInt32(ChartColor.rgb(106, 150, 31)), UInt32(ChartColor.rgb(179, 100, 53))]

    private func generateDataPie(): PieData {
        let entries: ArrayList<PiEntry> = ArrayList<PiEntry>()
        for (i in 0..4) {
            entries.append(PiEntry(30.0, "Quarter ${(i + 1)}"))
        }
        let d: PieDataSet = PieDataSet(entries, "")

        d.setSliceSpace(1.0)
        d.setColorsByVariable(COLORFUL_COLORS)
        d.setValueTextColor(0xffffff)

        return PieData(d)
    }

    let VORDIPLOM_COLORS: Array<UInt32> = [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
    UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)), UInt32(ChartColor.rgb(255, 140, 157))]
    private func generateDataLine(cnt: Int64): LineData {
        let values1: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        for (i in 0..12) {
            values1.append(EntryOhos(Float64(i), (Random().nextFloat64() * 65.0) + 40.0))
        }

        let d1: LineDataSet = LineDataSet(values1, "New DataSet ${cnt}, (1)")
        d1.setLineWidth(2.5)
        d1.setCircleRadius(4.5)
        d1.setHighLightColor(0xF47575)
        d1.setDrawValues(false)
        d1.setCircleColor(0x8CEAFF)

        let values2: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

        for (i in 0..12) {
            values2.append(EntryOhos(Float64(i), values1[i].getY() - 30.0))
        }

        let d2: LineDataSet = LineDataSet(values2, "New DataSet ${cnt}, (2)")
        d2.setLineWidth(2.5)
        d2.setCircleRadius(4.5)
        d2.setHighLightColor(0xF47575)
        d2.setColorByColor(VORDIPLOM_COLORS[0])
        d2.setCircleColor(VORDIPLOM_COLORS[0])
        d2.setDrawValues(false)

        let sets: ArrayList<ILineDataSet> = ArrayList<ILineDataSet>()
        sets.append(d1)
        sets.append(d2)

        return LineData(sets)
    }

    private func generateDataBar(cnt: Int64): BarData {
        let entries: ArrayList<BarEntry> = ArrayList<BarEntry>()

        for (i in 0..12) {
            entries.append(BarEntry(Float64(i), (Random().nextFloat64() * 70.0) + 30.0))
        }
        let d: BarDataSet = BarDataSet(entries, "New DataSet ${cnt}")
        d.setColorsByVariable(VORDIPLOM_COLORS)
        d.setHighLightAlpha(255.0)
        d.setValueTextSize(8.0)
        let dataSets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSets.append(d)

        let cd: BarData = BarData(dataSets)
        return cd
    }

    func build() {
        Column {
            List(space: 20, initialIndex: 0) {
                ForEach(
                    this.list,
                    itemGeneratorFunc: {
                        item: Any, _: Int64 => ListItem() {
                            if (item is PieData) {
                                PieChartItem(data: (item as PieData)())
                            }
                            if (item is LineData) {
                                LineChartItem(data: (item as LineData)())
                            }
                            if (item is BarData) {
                                BarChartItem(data: (item as BarData)())
                            }
                        }.editable(false)
                    }
                )
            }.listDirection(Axis.Vertical)
        }.width(100.percent).height(100.percent).backgroundColor(Color.WHITE)
    }
}
