package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel26 {

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
            axisLeft.setSpaceTop(20.0)   //设置顶轴空间占整个范围的百分比。
            axisLeft.setSpaceBottom(30.0)  //设置底部轴空间占整个范围的百分比
            axisLeft.setDrawZeroLine(true)  //将此设置为true以绘制零线，而不管是否启用了其他网格线。默认值:false
            axisLeft.setZeroLineColor(Color.RED)   //设置零线颜色
            axisLeft.setZeroLineWidth(2.0)         //设置零线宽度
            var axisRight = this.model.getAxisRight().getOrThrow();   //获取右侧Y轴
            axisRight.setSpaceTop(20.0)   //设置顶轴空间占整个范围的百分比。
            axisRight.setSpaceBottom(30.0)  //设置底部轴空间占整个范围的百分比
            axisRight.setDrawZeroLine(true)  //将此设置为true以绘制零线，而不管是否启用了其他网格线。默认值:false
            axisRight.setZeroLineColor(Color.RED)   //设置零线颜色
            axisRight.setZeroLineWidth(2.0)         //设置零线宽度
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
