/**
 * Created on 2024/7/29
 */
package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Linepage
import ohos.state_macro_manage.*
@Entry
@Component
class L1_line_setCubicIntensity {

    private var title: String = "L1_line_chart_page"
    private var model: LineChartModel = LineChartModel.build()
    var line:EntryOhos=EntryOhos(5.0,5.0)
    var line1:EntryOhos=EntryOhos(-5.0,-5.0)
    var line2:EntryOhos=EntryOhos(8.0,3.0)
    var line3:EntryOhos=EntryOhos(10.0,5.0)
    private var ListLineEntry:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line,line1,line2,line3)

//设置曲线强度

    func DataSet(): LineData{
            var linedataSet:LineDataSet=LineDataSet(ListLineEntry,"线形图￥")
            linedataSet.setMode(Mode.HORIZONTAL_BEZIER)
            linedataSet.setCubicIntensity(0.8)
            var listlinedata:ArrayList<ILineDataSet>=ArrayList<ILineDataSet>([linedataSet])
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