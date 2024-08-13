package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_vertical_BarChartModel29 {

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
            DashPathEffectConfig(60,2,5)
            axisLeft.addGridLine(GridLineConfig(8.0,0x98FB98,0.6,DashPathEffectConfig(20,50,50)))  //添加网格线
            axisLeft.setAxisMinLabels(2)               //设置轴上的最小标签数。
            axisLeft.setAxisMaxLabels(5)               //设置轴上的最大标签数。
            axisLeft.setDrawGridLines(false)            //是否设置网格线。
            axisLeft.setGridColor(Color.RED)          // 设置网格线颜色。 	浅粉红
            axisLeft.setGridLineWidth(0.5)            // 设置网格线宽度
            axisLeft.setDrawLabels(false)              //是否设置标签显示
            axisLeft.setLabelCount(5,false)            // 设置标签数量
            axisLeft.enableGridDashedLine(40,3,0)   //使网格线以虚线模式绘制
            this.model.setDrawGridBackground(false)   //是否设置网格背景颜色
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
