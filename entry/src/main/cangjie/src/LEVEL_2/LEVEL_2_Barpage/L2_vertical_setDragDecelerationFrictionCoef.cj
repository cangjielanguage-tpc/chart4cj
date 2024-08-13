package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Barpage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_vertical_setDragDecelerationFrictionCoef {

    private var title: String = "L2_vertical_setDragDecelerationFrictionCoef"
    private var model: BarChartModel = BarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,20.0)
    var barntry1:BarEntry=BarEntry(30.0,-30.0)
    var barntry2:BarEntry=BarEntry(40.0,40.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)



    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            this.model.setDragDecelerationFrictionCoef(-20.0)
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
