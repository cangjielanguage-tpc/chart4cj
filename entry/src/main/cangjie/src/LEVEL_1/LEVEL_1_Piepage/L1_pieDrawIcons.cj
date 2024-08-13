package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieDrawIcons {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ListPiEntrycolor:Array<UInt32>=Array<UInt32>([0xFF00FF,0xA9A9A9,0xA52A2A])  //洋红色 深灰色 棕色
    private var ListHighlight:Array<Highlight>=Array<Highlight>([Highlight(0.2,y:0.3,dataSetIndex:0),Highlight(0.3,y:0.3,dataSetIndex:1),Highlight(0.5,y:0.5,dataSetIndex:2)])  //禁用设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)。在没有图标的情况下开启图标设置   setDrawValues
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setAutomaticallyDisableSliceSpacing(true)         //切片空间
        pieDataSet.setSliceSpace(20.0)
        pieDataSet.setSelectionShift(20.0)
        pieDataSet.setXValuePosition(ValuePosition.INSIDE_SLICE)
        pieDataSet.setYValuePosition(ValuePosition.OUTSIDE_SLICE)
        pieDataSet.setDrawValues(false)
        pieDataSet.setUseValueColorForLine(true)  //是否设置值引导线的颜色
        pieDataSet.setValueLineColor(0xFFFFB6C1)    //引导线颜色浅粉红色
        pieDataSet.setValueLineWidth(10.1)
        pieDataSet.setValueLinePart1OffsetPercentage(80.0)       //引导线第一段到圆心的距离
        pieDataSet.setValueLinePart1Length(0.4)    //引导线第一段
        pieDataSet.setValueLinePart2Length(0.5)    //引导线第二段
        pieDataSet.setValueLineVariableLength(true)    //是否设置引导线
        pieDataSet.setColorsByVariable(ListPiEntrycolor)         //需测试多种颜色并设置透明度
        pieDataSet.setColorsByArrAndAlpha(ListPiEntrycolor,0.5)
        pieDataSet.setLabel("时间")        //设置图表标签
        pieDataSet.setValueFormatter(DefaultValueFormatter(200))   //设置值格式
        pieDataSet.setValueTextColor(0xFF00FF00)  //设置数据文本颜色  绿色
        pieDataSet.setValueTypeface(FontFamily.MONOSPACE)
        pieDataSet.setValueTextSize(60.0)     //需测试设置数据文本大小
        pieDataSet.setDrawIcons(false)   //设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
        pieDataSet.setDrawIcons(true)   //设置是否绘制数据项图标*
        pieDataSet.setVisible(true)   //设置是否绘制数据项图标*
        return pieDataSet
        }

    func aboutToAppear(): PieChartModel {
        this.model.setHoleColor(0xFFFFFF00);      //设置在 Pie Chart中心绘制的孔的颜色(如果启用)
        this.model.setDrawSlicesUnderHole(true)   //启用或禁用孔后面切片内部尖端的可见性
        this.model.setDrawHoleEnabled(true);     //将此设置为true将饼图中心画为空
        this.model.setCenterText("中心孔");          //设置显示在 PieChart 中心的文本 String。
        this.model.setDrawCenterText(true);        //将其设置为true以绘制显示在扇形图中心的文字
        this.model.setCenterTextTypeface(FontFamily.SANS_SERIF)    //设置中心文本绘制的字体
        this.model.setCenterTextSize(30.0);             //设置PieChart的中心文本的大小
        this.model.setCenterTextSizePixels(40.0);  //设置PieChart中心文本的大小(以像素为单位)
        this.model.setCenterTextOffset(0.0,666.6);   //设置中心文本相对于原始位置的偏移量。默认的x=0，y=0
        this.model.setCenterTextColor(0xFF00FFFF);   //设置PieChart中心文本的颜色。
        this.model.setHoleRadius(70.0); //以最大半径的百分比设置图中心孔的半径(max=整个图表的半径)，默认为50%
        this.model.setTransparentCircleColor(0xFF000000);  //设置圈应有的颜色  黑色
        this.model.setTransparentCircleRadius(60.0);  //设置圈的半径，该圆画在图中的孔旁边，以最大半径的百分比(max=整个图表的半径)，默认为55%->表示默认比中心孔大5% *
        this.model.setTransparentCircleAlpha(255.0);   //设置圈的透明度，0=完全透明，255=完全不透明。默认值为100。*
        this.model.setDrawEntryLabels(true);    //将此设置为true则将条目标签绘制到饼图切片中*
        this.model.setEntryLabelColor(0xFF808080);   //设置绘制条目标签的颜色。 灰色
        this.model.setEntryLabelTypeface(FontFamily.MONOSPACE);  //为条目标签的绘制设置自定义字体。
        this.model.setEntryLabelTextSize(20.0);    //设置条目标签的大小。默认值:14vp
        this.model.setDrawRoundedSlices(true);    //设置是否以曲线方式绘制切片，仅在启用绘制孔且切片未在孔下绘制时起作用
        this.model.setUsePercentValues(true);    //如果启用此功能，PieChart中的值将以百分数绘制，而不是以其原始值绘制,如果为IValueFormatter，提供的格式化的值将以百分比形式提供
        this.model.setCenterTextRadiusPercent(90.0);   //中心文本的限界框以饼状孔的百分比表示，默认值1.0(100%)
        this.model.setMaxAngle(360.0);   //设置用于计算圆饼的最大角度。360表示它是一个完整的派图，180结果是一个半派图。默认值:360
        this.model.setMinAngleForSlices(10.0)  //设置角度来设置切片的最小大小，您必须调用{@link#notifyDataSetchanged()}和{@link#invalidate()}来进行更改，只有当有足够的空间让所有切片具有最小角度时才起作用。

        this.model.animateXY(1000,1000,easingX:"ease",easingY:"linear")        //未设置监听事件
        this.model.setExtraOffsets(0.0,100.0,10.0,100.0)   //设置图表额外偏移量*
        this.model.setLogEnabled(true)   //将其设置为 true 可启用图表的log输出
        var desc=Description()
        desc.setText("柱状图")
        this.model.setDescription(desc)   //设置图表描述信息
        this.model.onSizeChanged(100.0,100.0,200.0,200.0)   //改变图表大小
        let data: PieData = PieData(DataSet())
        this.model.setData(data)
        return  this.model

    }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            PieChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
