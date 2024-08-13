package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Barpage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_level_bar_chartModel2 {

    private var title: String = "L2_level_bar_chartModel2"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var a:Any="第一注"
    var barntry:BarEntry=BarEntry(20.0,2.0,data: a)
    var barntry1:BarEntry=BarEntry(30.0,3.0,data: a)
    var barntry2:BarEntry=BarEntry(40.0,4.0,data: a)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)


//设置条形图阴影颜色

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"大or小")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([])
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
