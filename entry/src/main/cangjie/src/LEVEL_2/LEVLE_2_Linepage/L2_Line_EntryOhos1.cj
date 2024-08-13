/**
 * Created on 2024/7/29
 */
package ohos_app_cangjie_entry.LEVEL_2.LEVLE_2_Linepage
import ohos.state_macro_manage.*
@Entry
@Component
class L2_Line_EntryOhos1 {

    private var title: String = "L2_Line_EntryOhos1"
    private var model: LineChartModel = LineChartModel.build()
    var line:EntryOhos=EntryOhos(5.0,5.0)
    private var ListLineEntry:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line)



    func DataSet(): LineData{
            var linedataSet:LineDataSet=LineDataSet(ListLineEntry,"线形图￥")
            var listlinedata:ArrayList<ILineDataSet>=ArrayList<ILineDataSet>([])
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