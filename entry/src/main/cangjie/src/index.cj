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

@Entry
@Component
class MyView {
    @State
    var message: String = "Hello Cangjie"
    func render() {
        Row {
            Column {
                Button(message).onClick {
                    evt => AppLog.info("Hello Cangjie")
                }.fontSize(40).height(80)
            }.width(100.percent)
        }.height(100.percent)
    }
}
