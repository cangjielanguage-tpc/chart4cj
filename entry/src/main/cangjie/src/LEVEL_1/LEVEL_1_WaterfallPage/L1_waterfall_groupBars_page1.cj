package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_WaterfallPage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_waterfall_groupBars_page1 {

    private var title: String = "L1_waterfallPage_chart_page"
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    var Waterfall:WaterfallEntry=WaterfallEntry(5.0,5.0,8.0)
    var Waterfall1:WaterfallEntry=WaterfallEntry(-5.0,-5.0,2.0)
    var Waterfall2:WaterfallEntry=WaterfallEntry(8.0,3.0,7.0)

    var Waterfall3:WaterfallEntry=WaterfallEntry(5.0,9.0,10.0)
    var Waterfall4:WaterfallEntry=WaterfallEntry(-5.0,3.0,6.0)
    var Waterfall5:WaterfallEntry=WaterfallEntry(8.0,2.0,9.0)

    private var ListbubbleEntry:ArrayList<WaterfallEntry>=ArrayList<WaterfallEntry>(Waterfall,Waterfall1,Waterfall2)
    private var ListbubbleEntry1:ArrayList<WaterfallEntry>=ArrayList<WaterfallEntry>(Waterfall3,Waterfall4,Waterfall5)


    func DataSet(): WaterfallData{
            var waterfalldataSet:WaterfallDataSet=WaterfallDataSet(ListbubbleEntry,"瀑布图#")
            var waterfalldataSet1:WaterfallDataSet=WaterfallDataSet(ListbubbleEntry1,"瀑布图#")
            var listwaterfalldata:Array<IWaterfallDataSet>=[waterfalldataSet,waterfalldataSet1]
            var waterfalldata:WaterfallData=WaterfallData(listwaterfalldata)

            return waterfalldata
    }



    func aboutToAppear(): WaterfallChartModel {
            let data: WaterfallData = DataSet()
            var xAxis = this.model.getXAxis().getOrThrow();
            xAxis.setLabelCount(4,false);
            xAxis.setPosition(XAxisPosition.BOTTOM);
            xAxis.setDrawGridLinesBehindData(true)
            this.model.groupBars(-5.0,0.08,0.003)
            this.model.setData(data)
            return  this.model
        }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            WaterfallChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}





