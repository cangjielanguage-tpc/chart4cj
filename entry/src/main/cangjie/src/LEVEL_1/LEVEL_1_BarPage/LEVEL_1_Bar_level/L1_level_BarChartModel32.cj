package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel32 {

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
            axisLeft.setDrawAxisLine(false)             //是否设置轴线。
            axisLeft.setCenterAxisLabels(false)         //设置轴标签是否居中显示。
            axisLeft.setAxisLineColor(Color.BLACK)    // 设置轴线颜色        猩红
            axisLeft.setAxisLineWidth(0.2)            // 设置轴线宽度
            axisLeft.setGranularityEnabled(true)     // 是否设置轴上的粒度显示
            axisLeft.setGranularity(0.6)             // 放大时设置轴上的最小间隔
            axisLeft.disableAxisLineDashedLine()               //禁用以虚线模式绘制轴线
            axisLeft.setAxisMinimum(1.5)                            //设置轴线最小值
            axisLeft.setAxisMaximum(2.5)                            //设置轴线的最大值
            axisLeft.setSpaceMin(2.0)                 //设置额外最小间距*
            axisLeft.setSpaceMax(4.0)                       //设置额外最大间距*
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
