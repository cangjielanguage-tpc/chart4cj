/**
 * Created on 2024/7/29
 */
package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Linepage
import ohos.state_macro_manage.*
@Entry
@Component
class L1_line_EntryOhospage2 {

    private var title: String = "L1_line_chart_page"
    private var model: LineChartModel = LineChartModel.build()
    var line:EntryOhos=EntryOhos(5.0,5.0)
    var line1:EntryOhos=EntryOhos(-5.0,-5.0)
    var line2:EntryOhos=EntryOhos(8.0,3.0)
    var line3:EntryOhos=EntryOhos(10.0,5.0)
    var line4:EntryOhos=EntryOhos(5.0,6.0)
    var line5:EntryOhos=EntryOhos(-5.0,-6.0)
    var line6:EntryOhos=EntryOhos(8.0,4.0)
    var line7:EntryOhos=EntryOhos(10.0,6.0)
    private var ListLineEntry:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line,line1,line2,line3)
    private var ListLineEntry1:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line4,line5,line6,line7)



    func DataSet(): LineData{
            var linedataSet:LineDataSet=LineDataSet(ListLineEntry,"线形图￥")
            var linedataSet1:LineDataSet=LineDataSet(ListLineEntry,"￥线形图")
            var listlinedata:ArrayList<ILineDataSet>=ArrayList<ILineDataSet>([linedataSet,linedataSet1])
            var linedata:LineData=LineData(listlinedata)
            return linedata
    }



    func aboutToAppear(): LineChartModel {
            let data: LineData = DataSet()
            this.model.setData(data)
            return  this.model
        }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            LineChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}