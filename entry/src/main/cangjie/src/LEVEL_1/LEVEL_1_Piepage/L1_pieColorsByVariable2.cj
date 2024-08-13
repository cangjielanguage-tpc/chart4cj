package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieColorsByVariable2 {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var PiEntrycolor:Array<UInt32>=Array<UInt32>([0xFF00FF,0xA9A9A9,0xA52A2A])  //洋红色 深灰色 棕色
    private var ListPiEntrycolor:ArrayList<UInt32>=ArrayList<UInt32>([0xFF00FF,0xA9A9A9,0xA52A2A])  //洋红色 深灰色 棕色
    private var ListHighlight:Array<Highlight>=Array<Highlight>([Highlight(0.2,y:0.3,dataSetIndex:0),Highlight(0.3,y:0.3,dataSetIndex:1),Highlight(0.5,y:0.5,dataSetIndex:2)])  //扇面设置颜色，重用，未设置透明度
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setColorsByList(ListPiEntrycolor)         //设置多种颜色
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
