package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_vertical_bar_barentry_page7 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: BarChartModel = BarChartModel.build()
    var a:Any="第一注"
    var barntry:BarEntry=BarEntry(-20.0,2.0,data: a)
    var barntry1:BarEntry=BarEntry(30.0,-3.0,data: a)
    var barntry2:BarEntry=BarEntry(40.0,4.0,data: a)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)

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
