package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Barpage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_vertical_bar_setBarWidth_page {

    private var title: String = "L1_bar_vertical_page"
    private var model: BarChartModel = BarChartModel.build()
    var ListBar1:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var ListBar2:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var ListBar3:Array<Float64>=Array<Float64>([30.0,40.2,50.3])
    var barntry1:BarEntry=BarEntry(5.0,ListBar1)
    var barntry2:BarEntry=BarEntry(10.0,ListBar2)
    var barntry3:BarEntry=BarEntry(15.0,ListBar3)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry1,barntry2,barntry3)

//设置每个条形图在坐标轴上的宽度，默认 0.85

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            barData.setBarWidth(-3.0)    //设置每个条形图在坐标轴上的宽度，默认 0.85
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
