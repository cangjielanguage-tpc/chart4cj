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
public class ManyBarChartsPage {
    var minOffset: Float64 = 15.0 //X轴线偏移量
    private var list: ArrayList<BarChartModel> = ArrayList<BarChartModel>()
    var pageInfo: NavPathStack = NavPathStack()
    protected override func aboutToAppear() {
        // 20 items
        for (i in 0..20) {
            this.setData(i + 1, this.createModel())
        }
    }

    private func createModel(): BarChartModel {
        let model: BarChartModel = BarChartModel.build()
        model.setDrawBarShadow(false)
        model.setDrawValueAboveBar(true)
        model.getDescription().setEnabled(false)
        model.setMaxVisibleValueCount(60)
        return model
    }

    func build() {
        NavDestination() {
            Column() {
            List(space: 20, initialIndex: 0) {
                ForEach(
                    this.list,
                    itemGeneratorFunc: {
                        item: BarChartModel, _: Int64 => ListItem() {
                            Column() {
                                BarChart(model: item)
                            }.width(100.percent).height(30.percent)
                        }.editable(false)
                    }
                )
            }.id("list").listDirection(Axis.Vertical).edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
                .chainAnimation(false) // 联动特效关闭
        }
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }

    let VORDIPLOM_COLORS: Array<UInt32> = [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
    UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)), UInt32(ChartColor.rgb(255, 140, 157))]

    private func setData(cnt: Int64, model: BarChartModel) {
        let entries: ArrayList<BarEntry> = ArrayList<BarEntry>()

        for (i in 0..12) {
            entries.append(BarEntry(Float64(i), (Random().nextFloat64() * 70.0) + 30.0))
        }

        let d: BarDataSet = BarDataSet(entries, "New DataSet ${cnt}")
        d.setColorsByVariable(VORDIPLOM_COLORS)
        d.setDrawIcons(false)

        let sets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        sets.append(d)

        let cd: BarData = BarData(sets)
        cd.setValueTextSize(10.0)

        model.setData(cd)

        this.list.append(model)
    }
}
