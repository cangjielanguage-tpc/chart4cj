/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts

import ohos.hilog.*
//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import tpc.UIKit.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.scrollingCharts.viewPageItems.*

@Component
public class ViewPagerPage {
    private var swiperController: SwiperController = SwiperController()
    private var data: MyDataSource = MyDataSource(ArrayList<Order>())
    var pageInfo: NavPathStack = NavPathStack()

    protected override func aboutToAppear() {
        let datas: ArrayList<Order> = ArrayList<Order>()
        for (i in 0..5) {
            datas.append(Order("${i}", i * i))
        }
        this.data = MyDataSource(datas)
    }

    func build() {
        NavDestination() {
            Column(5.0) {
            Swiper(this.swiperController) {
                LazyForEach(this.data,
                    itemGeneratorFunc: {
                    item: Order, idx: Int64 =>
                            Column() {
                        if (item.name =='0') {
                            fragSimpleLineIndex()
                        } else if ('1' == item.name) {
                            fragSimpleLineCircleIndex()
                        } else if ('2' == item.name) {
                            fragSimpleBarIndex()
                        } else if ('3' == item.name) {
                            FragSimpleScatterIndex()
                        } else if ('4' == item.name) {
                            fragmentSimplePieIndex()
                        }
                    }
                })
            }.index(0).indicator(false) // 默认开启指示点
                .loop(false) // 默认开启循环播放
                //.duration(1000)
                .vertical(false) // 默认横向切换
                .itemSpace(0).width(100.percent).height(100.percent).
                cachedCount(0).onChange({
                index => Hilog.info(0x0000, "test", "index:${ index.toString()}")
            })
        }
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }
}

public  class Order {
    public Order(
        let name: String,
        let id: Int64
    ) {}
}

public class MyDataSource <: IDataSource<Order> {
    public MyDataSource(let data_: ArrayList<Order>) {}
    public var listenerOp: Option<DataChangeListener> = None
    public func totalCount(): Int64 {
        return data_.size
    }
    public func getData(index: Int64): Order {
        return data_[index]
    }

    public func onRegisterDataChangeListener(listener: DataChangeListener): Unit {
        listenerOp = listener
    }

    public func onUnregisterDataChangeListener(listener: DataChangeListener): Unit {
        listenerOp = None
    }

    public func notifyChange(): Unit {
        let listener: DataChangeListener = listenerOp.getOrThrow()
        listener.onDataReloaded()
    }
}
