package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel45 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,20.0)
    var barntry1:BarEntry=BarEntry(30.0,-30.0)
    var barntry2:BarEntry=BarEntry(40.0,40.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
    private var dash:Array<Int64>=Array<Int64>([0,0,0,0,1,0,0,0])
//设置是否开启绘画标记点显示


    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            var leng=this.model.getLegend().getOrThrow()
            var legend1:LegendEntry=LegendEntry("周一",LegendForm.EMPTY,2.0,0.5,DashPathEffect(dash,0),0xFF1493)
            var legend2:LegendEntry=LegendEntry("周一",LegendForm.EMPTY,2.0,0.5,DashPathEffect(dash,0),0xFF1493)
            var legend3:LegendEntry=LegendEntry("周一",LegendForm.EMPTY,2.0,0.5,DashPathEffect(dash,0),0xFF1493)
            var legends:ArrayList<LegendEntry>=ArrayList<LegendEntry>(legend1,legend2,legend3)
            leng.setEntries(legends)
            this.model.setDrawMarkerViews(true)   //设置是否开启绘画标记点显示
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
