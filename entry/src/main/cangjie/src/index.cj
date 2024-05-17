from ohos import base.LengthProp
from ohos import component.Column
from ohos import component.Row
from ohos import component.Button
from ohos import component.Text
from ohos import component.CustomView
from ohos import component.CJEntry
from ohos import component.loadNativeView
from ohos import state_manage.SubscriberManager
from ohos import state_manage.ObservedProperty
from ohos import state_macro_manage.Entry
from ohos import state_macro_manage.Component
from ohos import state_macro_manage.State
from ohos import state_macro_manage.r

from ohos import base.*
from ohos import component.*

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
