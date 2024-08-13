package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

//class MyL1Runner <: L1Runner {
//    public func onRun() {
//        AppLog.info("CJL1Runner onRun")
//        let delegator = AbilityDelegatorRegistry.getAbilityDelegator()
//        let want = Want(bundleName: "com.example.myapplication", abilityName: "CangjieAbility")
//        delegator.startAbility(want).get()
//        UIL1.setup()
//    }
//
//    public func onPrepare() {
//        AppLog.info("CJL1Runner onPrepare")
//    }
//}

@Entry
@Component
class L1_pieCenter1 {

    private var title: String = "L1_pieCenter1"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ListPiEntrycolor:Array<UInt32>=Array<UInt32>([0xFF00FF,0xA9A9A9,0xA52A2A])  //洋红色 深灰色 棕色

//未设置中心孔
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setAutomaticallyDisableSliceSpacing(true)         //切片空间
        pieDataSet.setSliceSpace(20.0)
        pieDataSet.setSelectionShift(20.0)
        pieDataSet.setXValuePosition(ValuePosition.INSIDE_SLICE)   //设置 x 轴值的位置 *
        pieDataSet.setYValuePosition(ValuePosition.OUTSIDE_SLICE)   //设置 y 轴值的位置 *
        pieDataSet.setUseValueColorForLine(true)
        pieDataSet.setValueLineColor(0xFFB6C1)    //引导线颜色浅粉红色
        pieDataSet.setValueLineWidth(10.1)
        pieDataSet.setValueLinePart1OffsetPercentage(80.0)       //引导线第一段到圆心的距离
        pieDataSet.setValueLinePart1Length(0.4)    //引导线第一段
        pieDataSet.setValueLinePart2Length(0.5)    //引导线第二段
        pieDataSet.setValueLineVariableLength(true)    //是否设置引导线

        pieDataSet.setColorsByVariable(ListPiEntrycolor)         //需测试多种颜色并设置透明度
        pieDataSet.setColorsByArrAndAlpha(ListPiEntrycolor,0.5)
        pieDataSet.setLabel("时间")        //设置图表标签

        pieDataSet.setValueFormatter(DefaultValueFormatter(200))   //设置值格式
        pieDataSet.setValueTextColor(0x00FF00)  //设置数据文本颜色  绿色
        pieDataSet.setValueTypeface(FontFamily.MONOSPACE)
        pieDataSet.setValueTextSize(600.0)     //需测试设置数据文本大小
        pieDataSet.setDrawIcons(true)   //设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
        pieDataSet.setDrawIcons(false)   //设置是否绘制数据项图标*
        pieDataSet.setVisible(true)   //设置是否绘制数据项图标*
        return pieDataSet
        }

    func aboutToAppear(): PieChartModel {

        this.model.setDrawSlicesUnderHole(true)   //启用或禁用孔后面切片内部尖端的可见性
        this.model.setTransparentCircleColor(0x000000);  //设置圈应有的颜色  黑色
        this.model.setTransparentCircleRadius(60.0);  //设置圈的半径，该圆画在图中的孔旁边，以最大半径的百分比(max=整个图表的半径)，默认为55%->表示默认比中心孔大5% *
        this.model.setTransparentCircleAlpha(255.0);   //设置圈的透明度，0=完全透明，255=完全不透明。默认值为100。*
        this.model.setDrawEntryLabels(true);    //将此设置为true则将条目标签绘制到饼图切片中*
        this.model.setEntryLabelColor(0x808080);   //设置绘制条目标签的颜色。 灰色
        this.model.setEntryLabelTypeface(FontFamily.MONOSPACE);  //为条目标签的绘制设置自定义字体。
        this.model.setEntryLabelTextSize(20.0);    //设置条目标签的大小。默认值:14vp
        this.model.setDrawRoundedSlices(true);    //设置是否以曲线方式绘制切片，仅在启用绘制孔且切片未在孔下绘制时起作用
        this.model.setUsePercentValues(true);    //如果启用此功能，PieChart中的值将以百分数绘制，而不是以其原始值绘制,如果为IValueFormatter，提供的格式化的值将以百分比形式提供
        this.model.setCenterTextRadiusPercent(90.0);   //中心文本的限界框以饼状孔的百分比表示，默认值1.0(100%)
        this.model.setMaxAngle(180.0);   //设置用于计算圆饼的最大角度。360表示它是一个完整的派图，180结果是一个半派图。默认值:360
        this.model.setMinAngleForSlices(10.0)  //设置角度来设置切片的最小大小，您必须调用{@link#notifyDataSetchanged()}和{@link#invalidate()}来进行更改，只有当有足够的空间让所有切片具有最小角度时才起作用。
        this.model.setExtraOffsets(0.0,0.0,0.0,0.0)   //设置图表额外偏移量*
        let data: PieData = PieData(DataSet())
        this.model.setData(data)
        return  this.model

    }


//let scroller = Scroller()
//    func build() {
//        Column(30) {
//            Stack(Alignment.End) {
//                Scroll(this.scroller) {
//                    Column(){
//                            PieChart(model: aboutToAppear())
//                        }
//                    }.width(100.percent)
//                }
//                .width(30)
//                .backgroundColor(0xededed)
//            }
//    }

    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            PieChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}