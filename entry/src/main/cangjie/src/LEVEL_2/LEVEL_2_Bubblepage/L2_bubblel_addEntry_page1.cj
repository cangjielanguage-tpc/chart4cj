package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Bubblepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_bubblel_addEntry_page1 {

    private var title: String = "L1_bubblePage_chart_page2"
    private var model: BubbleChartModel = BubbleChartModel.build()
    var bubbley1:BubblesEntry=BubblesEntry(5.0,5.0,size:1.0)
    var bubbley2:BubblesEntry=BubblesEntry(10.0,10.0,size:2.0)
    var bubbley3:BubblesEntry=BubblesEntry(15.0,15.0,size:3.0)
    var bubbley4:BubblesEntry=BubblesEntry(-10.0,15.0,size:3.0)
    private var ListBubblesEntry:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubbley1,bubbley2,bubbley3)

//在指定的索引处向DataSet添加一个Entry。条目添加到列表的未尾。

    func DataSet(): BubbleData{
            var bubbledataSet:BubbleDataSet=BubbleDataSet(ListBubblesEntry,"气泡图￥")
            var listbubbledata:ArrayList<IBubbleDataSet>=ArrayList<IBubbleDataSet>([bubbledataSet])
            var bubbleData:BubbleData=BubbleData(listbubbledata)
            bubbleData.addEntry(bubbley4,-3)
            return bubbleData
    }



    func aboutToAppear(): BubbleChartModel {
            let data: BubbleData = DataSet()
            this.model.setData(data)
            return  this.model
        }




    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BubbleChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}





