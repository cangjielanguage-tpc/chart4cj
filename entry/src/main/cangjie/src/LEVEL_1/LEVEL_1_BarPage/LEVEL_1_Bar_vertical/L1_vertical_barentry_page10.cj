package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_barentry_page10 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: BarChartModel = BarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,2.0)
    var barntry1:BarEntry=BarEntry(30.0,-3.0)
    var barntry2:BarEntry=BarEntry(40.0,4.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
//BarDataSet相关设置


    func DataSet(): BarData{
            var ListStackLabels:Array<String>=Array<String>(["周一","周二","周三"])
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var fill:Fill=Fill(0xC0C0C0,0xD2B48C)   //白色黑色
            fill.setType(FillType.LINEAR_GRADIENT)   //设置填充样式
            fill.setColor(0xDA70D6)                 //设置颜色  紫色
            var ListGradientPositions:Array<Float64>=Array<Float64>([5.0,10.0,15.0])
            fill.setGradientPositions(ListGradientPositions)                 //设置渐变位置
            var ListGradientColors:Array<UInt32>=Array<UInt32>([0xDC143C,0x00FFFF,0xADFF2F])
            fill.setGradientColors(ListGradientColors)                 //设置渐变颜色   红绿黄
            fill.setGradientColors(0x808000,0xFFA500)                 //设置渐变颜色   橄榄绿 橙色
            fill.setAlpha(60.0)                 //设置渐变颜色   橄榄绿 橙色
            var ListFill:ArrayList<Fill>=ArrayList<Fill>(fill)
            var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
            var context: CanvasRenderingContext2D = CanvasRenderingContext2D(settings)
            fill.fillRect(context,Paint(),5.0,10.0,5.0,10.0,FillDirection.DOWN,radius:15.0,cornerType:RoundCornerType.UP)
            barDataSet.setFills(ListFill)
            barDataSet.setBarShadowColor(0x00FFFF)                       //设置条形图阴影颜色
            barDataSet.setBarBorderWidth(10.0)                       //设置条形图边框宽度
            barDataSet.setStackLabels(ListStackLabels)                       //设置堆叠标签
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
