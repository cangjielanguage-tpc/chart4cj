package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieExtraOffsets3 {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
//设置附加到视口顶部的额外偏移
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setLabel("饼状图【piechart】1")         //设置图表标签
        pieDataSet.setDrawValues(true)                  //设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
        return pieDataSet
        }

    func aboutToAppear(): PieChartModel {
        this.model.setExtraRightOffset(100.0)            //设置附加到视口顶部的额外偏移
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
