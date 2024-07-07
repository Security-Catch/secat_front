package com.example.front
import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView


class OverlayService : Service() {
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.run {
            val messageTitle = getStringExtra("message_title_content")
            val messageContent =  getStringExtra("message")
            val phoneNumber =  getStringExtra("phone_number")

            messageTitle?.let{ title ->
                messageContent?.let{ content ->
                    phoneNumber?.let { num ->
                        addOverlayView(title, content, num)
                    }
                }
            }
        }
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onCreate() {
        super.onCreate()
    }

    private fun addOverlayView(title : String, content : String, num : String) {
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager?
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater?
        overlayView = inflater?.inflate(R.layout.overlay_layout, null)

        val layoutFlag: Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            layoutFlag,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
//        params.gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
        windowManager!!.addView(overlayView, params)
        //
        overlayView!!.run {
            Log.d("caz tst" ,"setsetstest me info of intent124124 $title / $content / $num")

            val closeButton = findViewById<Button>(R.id.btn_close)

            closeButton.setOnClickListener {
                stopSelf()
            }

            val warningText = findViewById<TextView>(R.id.tv_warning_content)
            warningText.text = title

            val messageContentTv = findViewById<TextView>(R.id.tv_message_content)
            messageContentTv.text = content

            val moveToMessage = findViewById<Button>(R.id.btn_message)
            moveToMessage.setOnClickListener {
                stopSelf()
                context.startActivity(
                    Intent(Intent.ACTION_VIEW, Uri.parse("smsto:$num")).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    },
                )
            }
        }


    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("caz tst","overlat service destroy")
        if (overlayView != null) windowManager!!.removeView(overlayView)
    }
}

