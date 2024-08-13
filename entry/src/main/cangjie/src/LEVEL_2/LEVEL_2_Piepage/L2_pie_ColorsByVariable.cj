package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_pie_ColorsByVariable {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var PiEntrycolor:Array<UInt32>=Array<UInt32>([0xFF00FF,0xA9A9A9,0xA52A2A])  //洋红色 深灰色 棕色
//扇面设置颜色，未重用，未设置透明度
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        pieDataSet.setColorsByVariable(PiEntrycolor)         //设置多种颜色
        pieDataSet.setColorByAlpha(0x808080,-0.8)      //某个没有的颜色设置具有特定alpha值的颜色
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
