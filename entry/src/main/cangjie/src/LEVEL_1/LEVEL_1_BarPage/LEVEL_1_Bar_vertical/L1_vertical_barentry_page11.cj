package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_barentry_page11 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: BarChartModel = BarChartModel.build()
    var barntry:BarEntry=BarEntry(-20.0,2.0)
    var barntry1:BarEntry=BarEntry(30.0,-3.0)
    var barntry2:BarEntry=BarEntry(40.0,4.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
    private var arr:Array<Int64>=Array<Int64>([10,20,30])


//BarData相关设置


    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"男or女")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet])
            var barData:BarData=BarData(arrybarDataSet)
            return barData
            }


    func aboutToAppear(): BarChartModel {
            let data: BarData = DataSet()
            this.model.setDrawBarShadow(true)  //是否设置在每个条目后面设置阴影
            this.model.setFitBars(true)       //是否在x轴范围的两侧各增加一半条形图宽度，以使条形图完全显示出来。
            this.model.setDrawValueAboveBar(true)  //设置值是否在条形图的上方绘制
            this.model.setLongPressCursorEnabled(true)   //是否设置长按光标显示
            this.model.setLongPressDuration(2)   //设置长按时间间隔
            this.model.setYAxisExtensionLine(true)   //是否设置y坐标轴延长线
            this.model.setScaleMinima(0.6,0.6)   //是否设置y坐标轴延长线
            this.model.setVisibleXRangeMaximum(15.0)   //设置最小可见区域
            this.model.setVisibleXRangeMinimum(2.0)     //设置最小可见区域
            this.model.setVisibleYRangeMaximum(60.0,AxisDependency.RIGHT)   //设置Y轴最大区域大小
            this.model.setVisibleYRangeMinimum(5.0,AxisDependency.RIGHT)   //设置Y轴最小区域大小
            this.model.moveViewToX(30.0)   //将当前左侧视口移动到指定的x位置
            this.model.moveViewTo(30.0,30.0,AxisDependency.RIGHT)   //将使当前视图的左侧移动到x轴上的指定位置，并将视图中心移动到y轴的指定位置
            this.model.moveViewToAnimated(30.0,30.0,AxisDependency.RIGHT,2.0)   //将使当前视图的左侧移动到x轴上的指定位置，并将视图中心移动到y轴的指定位置,启动动画效果*
            this.model.setViewPortOffsets(10.0,20.0,30.0,5.0)   //设置当前视口的偏移量
            this.model.setMaxVisibleValueCount(2)   //设置图表可绘制的最大数量
            var axisLeft = this.model.getAxisLeft().getOrThrow();  //获取左侧Y轴
            axisLeft.addGridLine(GridLineConfig(5.0,0x00BFFF,2.0,DashPathEffectConfig(60,2,5)))  //添加网格线
            axisLeft.setAxisMinLabels(2)               //设置轴上的最小标签数。
            axisLeft.setAxisMaxLabels(5)               //设置轴上的最大标签数。
            axisLeft.setDrawGridLines(true)            //是否设置网格线。
            axisLeft.setGridColor(Color.RED)          // 设置网格线颜色。 	浅粉红
            axisLeft.setGridLineWidth(0.5)            // 设置网格线宽度
            axisLeft.setDrawLabels(true)              //是否设置标签显示
            axisLeft.setLabelCount(5,true)            // 设置标签数量
            axisLeft.setGridDashedLine(DashPathEffect(arr,2))   //设置网格线的形式
            var xAxis = this.model.getXAxis().getOrThrow();   //获取X轴
            xAxis.addGridLine(GridLineConfig(5.0,0x00BFFF,2.0,DashPathEffectConfig(60,2,5)))  //添加网格线
            xAxis.setAxisMinLabels(2)               //设置轴上的最小标签数。
            xAxis.setAxisMaxLabels(5)               //设置轴上的最大标签数。
            xAxis.setDrawGridLines(true)            //是否设置网格线。
            xAxis.setGridColor(Color.RED)          // 设置网格线颜色。 	浅粉红
            xAxis.setGridLineWidth(0.5)            // 设置网格线宽度
            xAxis.setDrawLabels(true)              //是否设置标签显示
            xAxis.setLabelCount(5,true)            // 设置标签数量
            xAxis.setGridDashedLine(DashPathEffect(arr,2))   //设置网格线的形式
            this.model.setDrawGridBackground(true)   //是否设置网格背景颜色
            this.model.setDrawBorders(true)          //是否设置边框线
            this.model.setClipValuesToContent(true)               //设置值是否在矩阵中*。
            this.model.setClipDataToContent(true)               //设置数据是否在矩阵中
            this.model.setBorderWidth(2.0)            //设置边框线的宽度
            this.model.setBorderColor(0xFFB6C1)          //设置边框线的颜色 	浅粉红
            this.model.setMinOffset(2.0)                   //设置图表最小偏移量
            this.model.onSizeChanged(2.0,10.0,15.0,15.0)                   //图表尺寸改变********
            this.model.setDragDecelerationFrictionCoef(20.0)   //设置 拖动减速摩擦*
            this.model.animateXY(1000,1000,easingX:"ease",easingY:"linear")        //展示图表时同时带有X轴，Y轴动画
            this.model.setExtraOffsets(0.0,10.0,10.0,10.0)   //设置图表额外偏移量**
            this.model.setLogEnabled(true)   //将其设置为 true 可启用图表的log输出**
            this.model.setNoDataText("无数据")   //将其设置为 true 可启用图表的log输出**
            this.model.setNoDataTextColor(Color.RED)   //设置无数据文本的颜色
            this.model.setNoDataTextTypeface(FontFamily.SERIF)   //设置无数据文本的字体
            this.model.setNoDataTextAlignment(TextAlignStyle.Center)   //对齐无数据文本
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
