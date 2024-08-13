package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel25 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
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
            //var xAxis = this.model.getXAxis().getOrThrow();   //获取X轴
            var axisLeft = this.model.getAxisLeft().getOrThrow();  //获取左侧Y轴
            axisLeft.setMinWidth(2.0)
            axisLeft.setMaxWidth(3.0)
            axisLeft.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            axisLeft.setLabelXOffset(5.0)
            axisLeft.setDrawTopYLabelEntry(true)
            axisLeft.setInverted(true)
            var axisRight = this.model.getAxisRight().getOrThrow();   //获取右侧Y轴
            axisRight.setMinWidth(2.0)
            axisRight.setMaxWidth(3.0)
            axisRight.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            axisRight.setLabelXOffset(5.0)
            axisRight.setDrawTopYLabelEntry(true)
            axisRight.setInverted(true)
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
