/**
 * Created on 2024/5/16
 */

package core.pie

public interface AnimatorUpdateListener {
    func onAnimationUpdate(result: AnimatorResult): Unit
}

public class ChartAnimator {
    /**
     * object that is updated upon animation update
     */
    private var mListener: ?AnimatorUpdateListener
    /**
     * The phase of drawn values on the y-axis.
     */
    protected var mPhaseY: Float64 = 1.0
    /** The phase of drawn values on the x-axis. 0 - 1 */
    protected var mPhaseX: Float64 = 1.0
    private var isShowXCallback: Bool = false
    private var isShowYCallback: Bool = false

    public init(listener: ?AnimatorUpdateListener) {
        this.mListener = listener
    }

    private func xAnimator(duration: Int32, easing: String): AnimatorResult {
        let options: AnimatorOptions = AnimatorOptions(
            duration: duration,
            easing: easing,
            delay: 0,
            fill: AnimatorFill.Forwards,
            direction: AnimatorDirection.Normal,
            iterations: 1,
            begin: 0.0,
            end: 1.0
        )
        let animatorResult = AnimatorResult(options)
        animatorResult.onframe = {
            value =>
            this.mPhaseX = value
            if (this.isShowXCallback && this.mListener.isSome()) {
                this.mListener?.onAnimationUpdate(animatorResult)
            }
        }

        return animatorResult
    }

    private func yAnimator(duration: Int32, easing: String): AnimatorResult {
        let options: AnimatorOptions = AnimatorOptions(
            duration: duration,
            easing: easing,
            delay: 0,
            fill: AnimatorFill.Forwards,
            direction: AnimatorDirection.Normal,
            iterations: 1,
            begin: 0.0,
            end: 1.0
        )
        let animatorResult = AnimatorResult(options)
        animatorResult.onframe = {
            value =>
            this.mPhaseY = value
            if (this.isShowYCallback && this.mListener.isSome()) {
                this.mListener?.onAnimationUpdate(animatorResult)
            }
        }

        return animatorResult
    }

    /**
     * Animates values along the X axis.
     *
     * @param durationMillis animation duration
     * @param easing EasingFunction
     */
    public func animateX(durationMillis: Int32, easing!: String = "linear") {
        let animatorXResult = this.xAnimator(durationMillis, easing)
        this.isShowXCallback = true
        this.isShowYCallback = false
        animatorXResult.play()
    }

    /**
     * Animates values along both the X and Y axes.
     *
     * @param durationMillisX animation duration along the X axis
     * @param durationMillisY animation duration along the Y axis
     * @param easing EasingFunction for both axes
     */
    public func animateXY(durationMillisX: Int32, durationMillisY: Int32, xEasing!: String = "linear",
        yEasing!: String = "linear") {
        let xAnimatorResult = this.xAnimator(durationMillisX, xEasing)
        let yAnimatorResult = this.yAnimator(durationMillisY, yEasing)

        if (durationMillisX > durationMillisY) {
            this.isShowXCallback = true
            this.isShowYCallback = false
        } else {
            this.isShowXCallback = false
            this.isShowYCallback = true
        }

        xAnimatorResult.play()
        yAnimatorResult.play()
    }

    /**
     * Animates values along the Y axis.
     *
     * @param durationMillis animation duration
     * @param easing EasingFunction
     */
    public func animateY(durationMillis: Int32, easing!: String = "linear") {
        let animatorY: AnimatorResult = this.yAnimator(durationMillis, easing)
        this.isShowXCallback = false
        this.isShowYCallback = true
        animatorY.play()
    }

    /**
     * Gets the Y axis phase of the animation.
     *
     * @return float value of {@link #mPhaseY}
     */
    public func getPhaseY(): Float64 {
        return this.mPhaseY
    }

    /**
     * Sets the Y axis phase of the animation.
     *
     * @param phase float value between 0 - 1
     */
    public func setPhaseY(phase: Float64) {
        var p: Float64 = phase
        if (phase > 1.0) {
            p = 1.0
        } else if (phase < 0.0) {
            p = 0.0
        }
        this.mPhaseY = p
    }

    /**
     * Gets the X axis phase of the animation.
     *
     * @return float value of {@link #mPhaseX}
     */
    public func getPhaseX(): Float64 {
        return this.mPhaseX
    }

    /**
     * Sets the X axis phase of the animation.
     *
     * @param phase float value between 0 - 1
     */
    public func setPhaseX(phase: Float64) {
        var p: Float64 = phase
        if (phase > 1.0) {
            p = 1.0
        } else if (phase < 0.0) {
            p = 0.0
        }
        this.mPhaseX = p
    }
}
