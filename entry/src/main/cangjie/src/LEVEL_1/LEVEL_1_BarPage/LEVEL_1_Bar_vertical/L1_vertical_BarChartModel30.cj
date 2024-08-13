package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_vertical_BarChartModel30 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: BarChartModel = BarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,20.0)
    var barntry1:BarEntry=BarEntry(30.0,-30.0)
    var barntry2:BarEntry=BarEntry(40.0,40.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
//Y轴相关设置


    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            var axisLeft = this.model.getAxisLeft().getOrThrow();  //获取左侧Y轴
            var limit:LimitLine=LimitLine(40.0,"限制线")
            limit.setLineWidth(2.0)
            limit.setLineColor(0x98FB98)          //设置限制线的颜色
            limit.enableDashedLine(30,2,5)    //设置限制线位虚线
            limit.setTextStyle(Style.STROKE)    //设置文本样式
            limit.setLabelPosition(LimitLabelPosition.LEFT_TOP)  //设置标签位置
            limit.setLabel("限制线1")
            axisLeft.addLimitLine(limit)  //添加限制线
            axisLeft.setDrawLimitLinesBehindData(true)  //如果设置为true，则在实际数据后面绘制LimitLines，否则在顶部绘制。默认值:false
            this.model
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
