package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_piePiEntry {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2," ")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ListPiEntrycolor:Array<UInt32>=Array<UInt32>([0xFFFF00FF,0xFFA9A9A9,0xFFA52A2A])  //洋红色 深灰色 棕色

    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
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
