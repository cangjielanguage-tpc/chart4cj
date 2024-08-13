package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieValueTextColors {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ValueTextColors:ArrayList<UInt32>=ArrayList<UInt32>([0xBF3EFF,0xB3EE3A,0xCD0000])  //深紫色 靛青 深岩暗蓝灰色
//设置数据文本
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setLabel("饼状图【piechart】1")         //设置图表标签
        pieDataSet.setValueTextColors(ValueTextColors)    //设置数据文本颜色
        pieDataSet.setValueTypeface(FontFamily.SERIF)    //设置数据文本颜色
        pieDataSet.setValueTextSize(200.0)    //设置数据文本大小
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
