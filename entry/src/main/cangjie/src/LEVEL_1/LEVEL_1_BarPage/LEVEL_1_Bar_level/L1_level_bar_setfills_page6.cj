package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_bar_setfills_page6 {

    private var title: String = "L1_bar_chart_page2"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var barntry1:BarEntry=BarEntry(20.0,20.0)
    var barntry2:BarEntry=BarEntry(30.0,30.0)
    var barntry3:BarEntry=BarEntry(40.0,40.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry1,barntry2,barntry3)

//设置数据集条形图的填充

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var fill:Fill=Fill(0xFF1493,0xFF0000)   //白色黑色
            fill.setAlpha(60.0)                 //设置渐变颜色   橄榄绿 橙色
            var ListFill:ArrayList<Fill>=ArrayList<Fill>(fill)
            barDataSet.setFills(ListFill)
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
