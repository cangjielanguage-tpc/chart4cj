package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel36 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,20.0)
    var barntry1:BarEntry=BarEntry(30.0,-30.0)
    var barntry2:BarEntry=BarEntry(40.0,40.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
    private var arr:Array<Int64>=Array<Int64>([10,20,30])
//x轴相关设置


    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            var xAxis = this.model.getXAxis().getOrThrow();   //获取X轴
            xAxis.setPosition(XAxisPosition.BOTTOM)  //设置轴位置
            xAxis.setLabelRotationAngle(6)               //设置绘制X轴标签的角度。
            xAxis.setAvoidFirstLastClipping(true)               //如果设置为true，将避免图表中第一个和最后一个标签从图表边缘或屏幕上“剪切”。
            xAxis.setLabelXOffset(0)            //设置标签偏移量
            xAxis.setXAxisLabelPosition(XAxisLabelPosition.LEFT)          //设置x标签的位置
            this.model.setDrawGridBackground(true)   //是否设置网格背景颜色
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
