package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_bar_barentry_page4 {

    private var title: String = "L1_bar_chart_page2"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var ListBar1:Array<Float64>=Array<Float64>([3.0,-4.2,5.3])
    var barntry:BarEntry=BarEntry(-5.0,ListBar1)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry)

//不同的构造方法，缺少icon的构造方法后续待测试

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            this.model.setData(data)
            return  this.model

        }




    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
