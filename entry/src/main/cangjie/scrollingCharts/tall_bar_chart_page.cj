/**
 * Created on 2024/9/12
 */
package ohos_app_cangjie_entry.scrollingCharts

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import tpc.UIKit.*
import ohos.state_macro_manage.*

@Component
public class TallBarChartPage {
    var scroller: Scroller = Scroller()
    @State
    var model: BarChartModel = BarChartModel.build()
    var minOffset: Float64 = 15.0 //X轴线偏移量
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var bottomAxis: XAxis = XAxis()
    var pageInfo: NavPathStack = NavPathStack()

    protected override func aboutToAppear() {
        let leftAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(11, false)
            // leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisMinimum(0.0)
            leftAxis.setAxisMaximum(100.0)
            leftAxis.enableGridDashedLine(10.0, 10.0)
        }

        let rightAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setDrawGridLines(false)
            rightAxis.setLabelCount(7, false)
            rightAxis.setSpaceTop(11.0)
            rightAxis.setAxisMinimum(0.0)
            rightAxis.setAxisMaximum(100.0)
        }

        let xAxis = this.model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setLabelCount(6, false)
            xAxis.setPosition(XAxisPosition.BOTTOM)
            xAxis.setAxisMinimum(0.0)
            xAxis.setAxisMaximum(12.0)
        }

        this.setData(12, 100.0)

        this.model.setDrawBarShadow(false)
        this.model.setDrawValueAboveBar(true)
        this.model.getDescription().setEnabled(false)
        this.model.setMaxVisibleValueCount(60)
    }

    func build() {
        NavDestination() {
            Column() {
            Scroll(this.scroller) {
                Column() {
                     Text("START OF SCROLLVIEW").width(100.percent).textAlign(TextAlign.Center)
                    Blank().height(350.px)
                    Column() {
                        BarChart(model: this.model)
                    }.width(80.percent).height(150.percent)

                    Blank().height(700.px)

                 Text("END OF SCROLLVIEW").width(100.percent).textAlign(TextAlign.Center)

                }.width(100.percent).alignItems(HorizontalAlign.Start)
            }.width(100.percent).height(100.percent)
        }
         }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }

    let VORDIPLOM_COLORS: Array<UInt32> = [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
    UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)), UInt32(ChartColor.rgb(255, 140, 157))]

    private func setData(count: Int64, range: Float64) {
        let start: Int64 = 0

        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()

        for (i in start..(start + count)) {
            let multi = range
            let val: Float64 = round(Random().nextFloat64() * multi)
            values.append(BarEntry(Float64(i), val))
        }

        let set1: BarDataSet

        let barData = this.model.getBarData()

        if (barData.isSome() && barData().getDataSetCount() > 0) {
            set1 = (barData().getDataSetByIndex(0) as BarDataSet)()
            set1.setEntries(values)
            barData().notifyDataChanged()
            this.model.notifyDataSetChanged()
        } else {
            set1 = BarDataSet(values, "Data Set")

            set1.setColorsByVariable(VORDIPLOM_COLORS)
            set1.setDrawValues(false)

            let dataSets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
            dataSets.append(set1)

            let data: BarData = BarData(dataSets)

            this.model.setData(data)
            this.model.setFitBars(true)
        }
    }
}
