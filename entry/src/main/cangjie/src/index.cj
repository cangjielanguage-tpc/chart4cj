/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry

 internal import ohos.base.LengthProp
 internal import ohos.component.Column
 internal import ohos.component.Row
 internal import ohos.component.Button
 internal import ohos.component.Text
 internal import ohos.component.CustomView
 internal import ohos.component.CJEntry
 internal import ohos.component.loadNativeView
 internal import ohos.state_manage.SubscriberManager
 internal import ohos.state_manage.ObservedProperty
 internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import std.collection.*
import ohos_app_cangjie_entry.pageconfig.*

@Entry
@Component
class MyView {
    private let title: String = "chart Example"
    var scroller: Scroller = Scroller()
    @State
    var message: String = "Hello Cangjie"
    @State
    var pageItemArr: ArrayList<ContentItem> = ContentItemData.getData()

    func build() {
        Row {
            Column {
                Scroll(this.scroller) {
                    Column() {
                        ForEach(this.pageItemArr,
                            itemGeneratorFunc: {
                            item: ContentItem, _: Int64 => if (item.getIsSection()) {
                                ItemTitle(itemData: item)
                            } else {
                                Flex() {
                                    Item(itemData: item);
                                }.onClick {
                                    e => Router.push(url: item.getPagePath())
                                }
                            }
                        })
                    }.width(100.percent).padding(bottom: 80)
                }.height(100.percent).scrollable(ScrollDirection.Vertical).scrollBarWidth(0).backgroundColor(
                    Color.WHITE)
            }.width(100.percent)
        }.height(100.percent)
    }


}

@Component
class ItemTitle {
    @State
    var itemData: ContentItem = ContentItem("title");
    @State
    var backGroundTitle: Color = Color.WHITE

    func build() {
        Column() {
            Text(this.itemData.getName()).fontSize(21).padding(16).fontColor(Color.GRAY)
            Blank().width(100.percent).height(1).color(0xdddddd)
        }.backgroundColor(this.backGroundTitle)
    }
}

@Component
class Item {
    @State
    var itemData: ContentItem = ContentItem("title");
    @State
    var backGround: Color = Color.WHITE

    func build() {
        Column() {
            Text(this.itemData.getName()).fontSize(16).fontColor(Color.BLACK).margin(left: 4).padding(8).alignSelf(
                ItemAlign.Start).width(100.percent)
            Text(this.itemData.getDesc()).fontSize(12).fontColor(Color.GRAY).margin(left: 4).padding(top: 0, right: 8,
                bottom: 8, left: 8).alignSelf(ItemAlign.Start).width(100.percent)
            Blank().width(100.percent).height(1).backgroundColor(0xdddddd)
        }.backgroundColor(this.backGround)
    }
}
