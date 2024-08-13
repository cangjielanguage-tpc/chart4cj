package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_vertical_bar_groupBars_page1 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: BarChartModel = BarChartModel.build()
    var a:Any="第一注"
    var barntry:BarEntry=BarEntry(1980.0,100.0)
    var barntry1:BarEntry=BarEntry(1981.0,101.0)
    var barntry2:BarEntry=BarEntry(1982.0,64.0)

    var barntry3:BarEntry=BarEntry(1980.0,110.0)
    var barntry4:BarEntry=BarEntry(1981.0,130.0)
    var barntry5:BarEntry=BarEntry(1982.0,80.0)

    var barntry6:BarEntry=BarEntry(1980.0,104.0)
    var barntry7:BarEntry=BarEntry(1981.0,113.0)
    var barntry8:BarEntry=BarEntry(1982.0,71.0)

    var barntry9:BarEntry=BarEntry(1980.0,109.0)
    var barntry10:BarEntry=BarEntry(1981.0,11.0)
    var barntry11:BarEntry=BarEntry(1982.0,82.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
    private var ListbareEntry1:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry3,barntry4,barntry5)
    private var ListbareEntry2:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry6,barntry7,barntry8)
    private var ListbareEntry3:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry9,barntry10,barntry11)

//设置x洲并进行分组

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"大or小")
            var barDataSet1:BarDataSet=BarDataSet(ListbareEntry1,"左or右")
            var barDataSet2:BarDataSet=BarDataSet(ListbareEntry2,"前or后")
            var barDataSet3:BarDataSet=BarDataSet(ListbareEntry3,"1or2")

            var ListStackLabels:Array<String>=Array<String>(["周一","周二","周三"])
            var ListStackLabels1:Array<String>=Array<String>(["周四","周五","周六"])
            var ListStackLabels2:Array<String>=Array<String>(["周七","周八","周九"])
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

            barDataSet1.setFills(ListFill)
            barDataSet1.setBarShadowColor(0x00FFFF)                       //设置条形图阴影颜色
            barDataSet1.setBarBorderWidth(10.0)                       //设置条形图边框宽度
            barDataSet1.setStackLabels(ListStackLabels1)                       //设置堆叠标签

            barDataSet2.setFills(ListFill)
            barDataSet2.setBarShadowColor(0x00FFFF)                       //设置条形图阴影颜色
            barDataSet2.setBarBorderWidth(10.0)                       //设置条形图边框宽度
            barDataSet2.setStackLabels(ListStackLabels2)                       //设置堆叠标签

        var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet,barDataSet1,barDataSet2,barDataSet3])
            var barData:BarData=BarData(arrybarDataSet)
            barData.setBarWidth(3.0)    //设置每个条形图在坐标轴上的宽度，默认 0.85
            barData.setTopRadius(45.0)    //设置顶部圆角半径
            barData.setBarWidth(0.2);
            barData.groupBars(1980.0,0.08,0.003)
            return barData
            }


    func aboutToAppear(): BarChartModel {

            var xAxis = this.model.getXAxis().getOrThrow();
            xAxis.setLabelCount(4,false);
            xAxis.setPosition(XAxisPosition.BOTTOM);
            xAxis.setDrawGridLinesBehindData(true)
            let data: BarData = DataSet()
            this.model.setData(data)
            return  this.model
              //this.model.invalidate();
    }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
