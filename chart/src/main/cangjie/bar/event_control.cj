/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar

public enum EventType <: Equatable<EventType> & Hashable {
    | SingleTap
    | DoubleTap
    | LongPress

    public operator func ==(b: EventType): Bool {
        match ((this, b)) {
            case (SingleTap, SingleTap) => true
            case (DoubleTap, DoubleTap) => true
            case (LongPress, LongPress) => true
            case _ => false
        }
    }

    public operator func !=(b: EventType): Bool {
        return !(this == b)
    }

    public func hashCode(): Int64 {
        match (this) {
            case SingleTap => 1
            case DoubleTap => 2
            case LongPress => 3
            case _ => 0
        }
    }
}

public class EventControl {
    private var eventMap: HashMap<EventType, Bool> = HashMap<EventType, Bool>()

    public init() {
        this.eventMap.add(EventType.SingleTap, true)
        this.eventMap.add(EventType.DoubleTap, true)
        this.eventMap.add(EventType.LongPress, true)
    }

    // 事件是否启用
    public func eventIsEnable(evType: EventType) {
        return this.eventMap.get(evType)
    }

    // 事件是否禁用
    public func eventIsDisable(evType: EventType) {
        return !this.eventMap.contains(evType)
    }

    // 启用所有事件
    public func setAllEventEnable() {
        for ((k, v) in this.eventMap) {
            eventMap[k] = true
        }
        return this
    }
    // 禁用所有事件
    public func setAllEventDisable() {
        for ((k, v) in this.eventMap) {
            eventMap[k] = false
        }

        return this
    }

    // 根据事件类型启用事件
    public func setEventEnable(evType: EventType) {
        this.setEvent(evType, true)
        return this
    }

    // 根据事件类型禁用事件
    public func setEventDisable(evType: EventType) {
        this.setEvent(evType, false)
        return this
    }

    private func setEvent(evType: EventType, sel: Bool) {
        if (this.eventMap.contains(evType)) {
            this.eventMap.add(evType, sel)
        }
    }
}
