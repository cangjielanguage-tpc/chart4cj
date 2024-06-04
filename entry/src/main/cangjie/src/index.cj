@Entry
@Component
class MyView {
    @State
    var message: String = "Hello Cangjie"
    func render() {
        Row {
            Column {
                Text("图表测试").width(100.percent).fontColor(0x000000).backgroundColor(0xFFFFFF).fontSize(25)
                Divider().color(0x000000).strokeWidth(1).margin(top: 10, bottom: 10)
                Scroll() {
                    Column {
                        Text("饼图测试").width(100.percent).fontColor(0x000000).backgroundColor(0xFFFFFF).fontSize(15)
                        Divider().color(0x000000).strokeWidth(1).margin(top: 10, bottom: 10)
                        Navigator("Pie1Page", NavigationType.Push) {
                            Button("跳转饼图页面").height(40).width(80.percent).shape(ShapeType.Capsule).
                                fontColor(0xFFFFFF).backgroundColor(0xFF0000).padding(5).align(Alignment.Center).margin(5).
                                fontSize(18)
                        }
                    }
                }
            }.width(100.percent)
        }.height(100.percent)
    }
}
