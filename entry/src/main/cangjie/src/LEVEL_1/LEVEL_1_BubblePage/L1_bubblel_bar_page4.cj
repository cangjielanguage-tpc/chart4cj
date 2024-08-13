package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BubblePage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_bubblel_bar_page4 {

    private var title: String = "L1_bubblePage_chart_page2"
    private var model: BubbleChartModel = BubbleChartModel.build()
    var bubbley1:BubblesEntry=BubblesEntry(5.0,5.0,size:1.0)
    var bubbley2:BubblesEntry=BubblesEntry(10.0,10.0,size:2.0)
    var bubbley3:BubblesEntry=BubblesEntry(15.0,10.0,size:3.0)

    var bubbley4:BubblesEntry=BubblesEntry(5.0,6.0,size:1.0)
    var bubbley5:BubblesEntry=BubblesEntry(10.0,11.0,size:2.0)
    var bubbley6:BubblesEntry=BubblesEntry(15.0,11.0,size:3.0)
    
    var bubbley7:BubblesEntry=BubblesEntry(5.0,7.0,size:1.0)
    var bubbley8:BubblesEntry=BubblesEntry(10.0,12.0,size:2.0)
    var bubbley9:BubblesEntry=BubblesEntry(15.0,12.0,size:3.0)
    private var ListBubblesEntry:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubbley1,bubbley2,bubbley3)
    private var ListBubblesEntry1:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubbley4,bubbley5,bubbley6)
    private var ListBubblesEntry2:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubbley7,bubbley8,bubbley9)

//设置每个条形图在坐标轴上的宽度，默认 0.85

    func DataSet(): BubbleData{
            var bubbledataSet:BubbleDataSet=BubbleDataSet(ListBubblesEntry,"大or小")
            var bubbledataSet1:BubbleDataSet=BubbleDataSet(ListBubblesEntry1,"南or北")
            var bubbledataSet2:BubbleDataSet=BubbleDataSet(ListBubblesEntry2,"东or西")
            var listbubbledata:ArrayList<IBubbleDataSet>=ArrayList<IBubbleDataSet>([bubbledataSet,bubbledataSet1,bubbledataSet2])
            var bubbleData:BubbleData=BubbleData(listbubbledata)
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





