package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieDescription {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
//设置图表描述信息
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setLabel("饼状图【piechart】1")         //设置图表标签
        pieDataSet.setDrawValues(true)                  //设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
        return pieDataSet
        }   

    func aboutToAppear(): PieChartModel {
        this.model.setLogEnabled(true)            //将其设置为 true 可启用图表的log输出
        this.model.clear()                         //clearValues  清空图表的所有数据，将其置空null，并刷新图表。
        this.model.setNoDataText("无数据")          //设置文本，通知用户没有可用于绘制图表的数据。
        this.model.setNoDataTextColor(Color.RED)    //红色
        this.model.setNoDataTextTypeface(FontFamily.SERIF)   //设置无数据文本的字体
        this.model.setNoDataTextAlignment(TextAlignStyle.Center)   //对齐无数据文本
        var des=Description()
        des.setText("图表描述信息")
        des.setPosition(10.0, -20.0)
        des.setTextAlign(TextAlignStyle.Left)
        this.model.setDescription(des)
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
