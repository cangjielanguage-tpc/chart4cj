package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_pie_setValueLineVariableLength {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ListPiEntrycolor:Array<UInt32>=Array<UInt32>([0xFFFF00FF,0xFFA9A9A9,0xFFA52A2A])  //洋红色 深灰色 棕色
    private var ListHighlight:Array<Highlight>=Array<Highlight>([Highlight(0.2,y:0.3,dataSetIndex:0),Highlight(0.3,y:0.3,dataSetIndex:1),Highlight(0.5,y:0.5,dataSetIndex:2)])  //禁用设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)。在没有图标的情况下开启图标设置   setDrawValues
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setUseValueColorForLine(true)  //是否设置值引导线的颜色
        pieDataSet.setValueLineColor(0xFFFFB6C1)    //引导线颜色浅粉红色
        pieDataSet.setValueLineWidth(10.1)
        pieDataSet.setValueLinePart1OffsetPercentage(80.0)       //引导线第一段到圆心的距离
        pieDataSet.setValueLinePart1Length(-0.4)    //引导线第一段
        pieDataSet.setValueLinePart2Length(0.5)    //引导线第二段
        pieDataSet.setValueLineVariableLength(true)    //是否设置引导线
        return pieDataSet
        }

    func aboutToAppear(): PieChartModel {
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
