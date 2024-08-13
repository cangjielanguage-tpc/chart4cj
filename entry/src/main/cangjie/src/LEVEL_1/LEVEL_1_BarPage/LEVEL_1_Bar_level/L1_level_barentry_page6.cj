package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_bar_barentry_page6 {

    private var title: String = "L1_bar_chart_page2"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var ListBar1:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var ListBar2:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var ListBar3:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var barntry1:BarEntry=BarEntry(5.0,ListBar1)
    var barntry2:BarEntry=BarEntry(10.0,ListBar2)
    var barntry3:BarEntry=BarEntry(15.0,ListBar3)
    private var ListbareEntry1:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry1,barntry2,barntry3)
    private var ListbareEntry2:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry1,barntry2,barntry3)
    private var ListbareEntry3:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry1,barntry2,barntry3)

//不同的构造方法，缺少icon的构造方法后续待测试

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry1,"大or小")
            var barDataSet1:BarDataSet=BarDataSet(ListbareEntry2,"左or右")
            var barDataSet2:BarDataSet=BarDataSet(ListbareEntry3,"前or后")
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
