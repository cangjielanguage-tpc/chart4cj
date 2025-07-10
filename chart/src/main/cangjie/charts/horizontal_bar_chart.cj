/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package chart.charts

import ohos.state_macro_manage.*

@Component
public class HorizontalBarChart {
    var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var antiAliasing: Bool = true
    private var setting: ?RenderingContextSettings = Option<RenderingContextSettings>.None
    private var context2D: ?CanvasRenderingContext2D = Option<CanvasRenderingContext2D>.None

    protected override func aboutToAppear() {
        this.setting = RenderingContextSettings(antialias: this.antiAliasing)
        this.context2D = CanvasRenderingContext2D(this.setting())
    }

    protected override func aboutToDisappear(): Unit {
        this.model.clearJobs()
    }

    func invalidate(){
        this.model.invalidate()
    }

    func build() {
        Column() {
            Stack(Alignment.TopStart) {
                if(let Some(context2D) <- this.context2D) {
                    Canvas(context2D).onReady(
                        {
                            =>
                            this.model.setContext2D(context2D)
                            this.model.onDraw(context2D)
                        }
                    ).onAreaChange(
                        {
                        oldArea: Area, newArea: Area => if (((newArea.width != oldArea.width) || (newArea.height != oldArea.
                            height))) {
                            this.model.onChartSizeChanged(newArea.width, newArea.height, oldArea.width, oldArea.height)
                        }
                    }).onTouch({
                        event => this.model.onTouchEvent(event)
                    })
                    .hitTestBehavior(if(this.model.getTouchEnabled()) {this.model.getHitTestMode() }else { HitTestMode.None } )
                    .gesture(
                        GestureGroup(GestureMode.Exclusive,
                        [
                            SwipeGesture()
                                .onAction({event: GestureEvent =>
                                    if (this.model.isDragDecelerationEnabled()) {
                                        this.model.computeScrollHorizontal(event);
                                    }
                                }),
                            TapGesture( count: 2 )
                                .onAction({event: GestureEvent =>
                                    this.model.onDoubleTap(false, event);
                                }),
                            TapGesture( count: 1 )
                                .onAction({event: GestureEvent =>
                                    this.model.onSingleTapUp(false, event);
                                }),
                            LongPressGesture()
                                .onAction({event: GestureEvent =>
                                    this.model.onLongPress(false, LongPressType.DOWN, event);
                                })
                                .onActionEnd({event: GestureEvent =>
                                    this.model.onLongPress(false, LongPressType.UP, event);
                                }),
                            PinchGesture( fingers: 2 )
                                .onActionStart({event: GestureEvent =>
                                    this.model.onPinch(false, PinchActionType.START, event);
                                })
                                .onActionUpdate({event: GestureEvent =>
                                    this.model.onPinch(false, PinchActionType.UPDATE, event);
                                })
                                .onActionEnd({event: GestureEvent =>
                                    this.model.onPinch(false, PinchActionType.END, event);
                                })
                        ]
                        )
                    )
//                    .scale(x: if(this.model.getHorizontalFlip()) { -1} else { 1} )
                }

            }
        }
    }
}
