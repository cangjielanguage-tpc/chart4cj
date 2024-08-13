package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_pieCenterTextRadiusPercent {

    private var title: String = "HLT_Pie_chart_pag1e"
    private var model: PieChartModel = PieChartModel.build()
    var pientry:PiEntry=PiEntry(0.2,"周一")
    var pientry1:PiEntry=PiEntry(0.3,"周二")
    var pientry2:PiEntry=PiEntry(0.5,"周三")
    private var ListPiEntry:ArrayList<PiEntry>=ArrayList<PiEntry>(pientry,pientry1,pientry2)
    private var ValueTextColors:ArrayList<UInt32>=ArrayList<UInt32>([0x8B008B,0x4B0082,0x483D8B])  //深紫色 靛青 深岩暗蓝灰色
//设置圈的透明度
    func DataSet(): PieDataSet{
        var pieDataSet:PieDataSet=PieDataSet(ListPiEntry,"time")
        return pieDataSet
        }

    func aboutToAppear(): PieChartModel {
        this.model.setDrawHoleEnabled(true)                   //将此设置为true将饼图中心画为空
        this.model.setHoleRadius(0.3)                         //以最大半径的百分比设置图中心孔的半径(max=整个图表的半径)，默认为50%
        this.model.setHoleColor(0x00FFFF)                  //设置在 Pie Chart中心绘制的孔的颜色(如果启用)
        this.model.setDrawSlicesUnderHole(true)                 //启用或禁用孔后面切片内部尖端的可见性
        this.model.setCenterText("中心孔")                       //设置显示在 PieChart 中心的文本 String
        this.model.setDrawCenterText(true)                      //将其设置为true以绘制显示在扇形图中心的文字
        this.model.setCenterTextTypeface(FontFamily.NONE)          //设置中心文本绘制的字体
        this.model.setCenterTextSizePixels(3000.0)                  //设置PieChart中心文本的大小(以像素为单位)
        this.model.setTransparentCircleRadius(0.4)                //设置圈的半径，该圆画在图中的孔旁边，以最大半径的百分比(max=整个图表的半径)，默认为55%->表示默认比中心孔大5% *
        this.model.setTransparentCircleColor(0xFFFFF0)          //象牙色  设置圈应有的颜色。*
        this.model.setCenterTextRadiusPercent(0.2)                  //中心文本的限界框以饼状孔的百分比表示，默认值1.0(100%)
        this.model.setTransparentCircleAlpha(150.0)
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
