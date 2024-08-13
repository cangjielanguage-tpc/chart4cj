/**
 * Created on 2024/7/29
 */

package ohos_app_cangjie_entry.LEVEL_0.LEVLE_0_Linepage
import ohos.ui_test.*
import ohos.state_macro_manage.*
import ohos.router.*
@Entry
@Component
class LEVEL_0_line_EntryOhospage {


    let driver: Driver = Driver.create()
    let button: UIComponent = driver.waitForComponent(On().text("回退"),60000)
    private var title: String = "LEVEL_0_line_chart_page"
    private var model: LineChartModel = LineChartModel.build()
    var line:EntryOhos=EntryOhos(5.0,5.0)
    var line1:EntryOhos=EntryOhos(-5.0,-5.0)
    var line2:EntryOhos=EntryOhos(8.0,3.0)
    var line3:EntryOhos=EntryOhos(10.0,5.0)
    private var ListLineEntry:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line,line1,line2,line3)



    func DataSet(): LineData{
            var linedataSet:LineDataSet=LineDataSet(ListLineEntry,"线形图￥")
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
            Text("回退").onClick({evt =>Router.back()}).height(40)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}