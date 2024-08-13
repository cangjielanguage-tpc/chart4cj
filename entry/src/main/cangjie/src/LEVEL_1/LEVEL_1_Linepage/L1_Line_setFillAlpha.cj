/**
 * Created on 2024/7/29
 */
package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Linepage
import ohos.state_macro_manage.*
@Entry
@Component
class L1_line_setFillAlpha {

    private var title: String = "L1_line_chart_page"
    private var model: LineChartModel = LineChartModel.build()
    var line:EntryOhos=EntryOhos(5.0,5.0)
    var line1:EntryOhos=EntryOhos(-5.0,-5.0)
    var line2:EntryOhos=EntryOhos(8.0,3.0)
    var line3:EntryOhos=EntryOhos(10.0,5.0)

    private var ListLineEntry:ArrayList<EntryOhos>=ArrayList<EntryOhos>(line,line1,line2,line3)

//设置绘图模式

    func DataSet(): LineData{
            var linedataSet:LineDataSet=LineDataSet(ListLineEntry,"线形图￥")
            var ChartColo:ChartColorStop=(0xD34A58, 20.0)
            var ChartColo1:ChartColorStop=(0x6EBE66, 30.0)
            var ChartColo2:ChartColorStop=(0x0000FF, 20.0)
            var ChartColo3:ChartColorStop=(0xFF0000, 30.0)
            var  chartcolorstop:ArrayList<ChartColorStop>=ArrayList<ChartColorStop>(ChartColo,ChartColo1,ChartColo2,ChartColo3)
            linedataSet.setGradientFillColor(chartcolorstop)
            linedataSet.setFillAlpha(80.0)
            linedataSet.setLineWidth(6.0)
            
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