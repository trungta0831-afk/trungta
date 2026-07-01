package com.gloryvn.dragbot
import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.*
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.Button
import android.widget.FrameLayout
import android.widget.Toast
import kotlin.math.sqrt
class DragService : AccessibilityService() {
    private lateinit var wm: WindowManager
    private var overlay: FrameLayout? = null
    private var active = false
    private val handler = Handler(Looper.getMainLooper())
    private var imageReader: android.media.ImageReader? = null
    private var virtualDisplay: android.hardware.display.VirtualDisplay? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        wm = getSystemService(WINDOW_SERVICE) as WindowManager
        createOverlay()
        initScreenCapture()
        handler.postDelayed(scanLoop, 1000)
        Toast.makeText(this, "Drag Bot sẵn sàng", Toast.LENGTH_SHORT).show()
    }

    private fun initScreenCapture() {
        val dm = resources.displayMetrics
        imageReader = android.media.ImageReader.newInstance(dm.widthPixels, dm.heightPixels, android.graphics.PixelFormat.RGBA_8888, 1)
        virtualDisplay = getSystemService(android.hardware.display.DisplayManager::class.java)?.createVirtualDisplay(
            "Capture", dm.widthPixels, dm.heightPixels, dm.densityDpi,
            imageReader?.surface, android.hardware.display.DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR
        )
    }

    private fun captureBitmap(): Bitmap? {
        val img = imageReader?.acquireLatestImage() ?: return null
        val planes = img.planes
        val buf = planes[0].buffer
        val ps = planes[0].pixelStride
        val rs = planes[0].rowStride
        val pad = rs - ps * img.width
        val bmp = Bitmap.createBitmap(img.width + pad / ps, img.height, Bitmap.Config.ARGB_8888)
        bmp.copyPixelsFromBuffer(buf)
        img.close()
        return bmp
    }

    private fun createOverlay() {
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
            android.graphics.PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP or Gravity.START
        overlay = FrameLayout(this).apply {
            setBackgroundColor(0x2200FF00)
            val btn = Button(context).apply {
                text = "DRAG: OFF"
                setBackgroundColor(Color.BLACK)
                setTextColor(Color.WHITE)
                setOnClickListener {
                    active = !active
                    text = if (active) "DRAG: ON" else "DRAG: OFF"
                    Toast.makeText(context, if (active) "Drag ON" else "Drag OFF", Toast.LENGTH_SHORT).show()
                }
            }
            addView(btn, FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT))
        }
        wm.addView(overlay, params)
    }

    private val scanLoop = object : Runnable {
        override fun run() {
            if (active) {
                val dm = resources.displayMetrics
                val cx = dm.widthPixels / 2
                val cy = dm.heightPixels / 2
                val target = findRedTarget(cx, cy, 350)
                target?.let { (tx, ty) ->
                    val dx = tx - cx
                    val dy = ty - cy
                    if (sqrt((dx*dx + dy*dy).toDouble()) > 40.0) {
                        performDrag(cx.toFloat(), cy.toFloat(), tx.toFloat(), ty.toFloat())
                    }
                }
            }
            handler.postDelayed(this, 70)
        }
    }

    private fun findRedTarget(cx: Int, cy: Int, radius: Int): Pair<Int, Int>? {
        val bmp = captureBitmap() ?: return null
        var bestDist = Double.MAX_VALUE
        var bestX = cx; var bestY = cy; var found = false
        val sx = maxOf(cx - radius, 0); val ex = minOf(cx + radius, bmp.width - 1)
        val sy = maxOf(cy - radius, 0); val ey = minOf(cy + radius, bmp.height - 1)
        for (y in sy..ey step 2) {
            for (x in sx..ex step 2) {
                val p = bmp.getPixel(x, y)
                val r = Color.red(p); val g = Color.green(p); val b = Color.blue(p)
                if (r > 170 && g < 110 && b < 110) {
                    val d = sqrt(((x - cx).toDouble() * (x - cx) + (y - cy).toDouble() * (y - cy)))
                    if (d < bestDist) {
                        bestDist = d; bestX = x; bestY = y; found = true
                    }
                }
            }
        }
        bmp.recycle()
        return if (found) Pair(bestX, bestY) else null
    }

    private fun performDrag(fx: Float, fy: Float, tx: Float, ty: Float) {
        val path = Path().apply {
            moveTo(fx, fy)
            quadTo((fx + tx) / 2, (fy + ty) / 2 - 40, tx, ty)
        }
        val stroke = GestureDescription.StrokeDescription(path, 0, 160)
        val gesture = GestureDescription.Builder().addStroke(stroke).build()
        dispatchGesture(gesture, null, null)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}
    override fun onDestroy() {
        overlay?.let { wm.removeView(it) }
        handler.removeCallbacks(scanLoop)
        virtualDisplay?.release()
        imageReader?.close()
        super.onDestroy()
    }
}
