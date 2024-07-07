package com.example.front

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val REQUEST_OVERLAY_PERMISSION = 1

    private val CHANNEL = "secat.jhl.dev/alert"

    private var tempTitle = ""

    private var tempMessage = ""

    private var tempNumber = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            val messageTitleContent = call.argument<String>("message_title_content")
            val message = call.argument<String>("message")
            val phoneNumber = call.argument<String>("phone_number")

            messageTitleContent?.let { title ->
                message?.let { content ->
                    phoneNumber?.let { number ->
                        checkPermissionOfOverlayServiceAndLaunchService(
                            title,
                            content,
                            number
                        )
                    }
                }
            }
        }
    }


    private fun checkPermissionOfOverlayServiceAndLaunchService(
        messageTitleContent : String,
        message: String,
        phoneNumber : String
    ) {
        //권한 체크
        if (!Settings.canDrawOverlays(this)) {
            //권한이 없어?
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            //권한 요청
            startActivityForResult(intent, REQUEST_OVERLAY_PERMISSION)
        } else {
            //권한이 있을때
            Log.d("caz tst" ,"active with per $messageTitleContent / $message  $phoneNumber")
            startOverlayService(
                messageTitleContent, message, phoneNumber
            )
        }
    }

    private fun startOverlayService(
        messageTitleContent: String,
        message : String,
        phoneNumber: String
    ) {
        Log.d("caz tst" ,"gve me info of intent")

        val intent = Intent(this, OverlayService::class.java)
        intent.putExtra("message_title_content",messageTitleContent)
        intent.putExtra("message",message)
        intent.putExtra("phone_number",phoneNumber)
        startService(intent)
    }
    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_OVERLAY_PERMISSION) {
            if (Settings.canDrawOverlays(this)) {
                Log.d("caz tst" ,"active with callback")
                startOverlayService(tempTitle,tempMessage,tempNumber)
            } else {
                // Permission not granted
            }
        }
    }
}
