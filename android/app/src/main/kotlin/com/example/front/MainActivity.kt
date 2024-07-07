package com.example.front

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequest
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class MainActivity: FlutterActivity() {
    private val REQUEST_OVERLAY_PERMISSION = 1

    private var tempTitle = ""

    private var tempMessage = ""

    private var tempNumber = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(PluginForMethodChannel())
//        ServiceLocator.flutterEngine = flutterEngine
//        val uploadWorkRequest: PeriodicWorkRequest =
//            PeriodicWorkRequestBuilder<UploadWorker>(15, TimeUnit.MINUTES)
//                .build()
//
//        WorkManager.getInstance(this).run {
//            cancelAllWork()
//            enqueueUniquePeriodicWork("uploadWorkRequest", ExistingPeriodicWorkPolicy.CANCEL_AND_REENQUEUE, uploadWorkRequest)
//        }
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

object ServiceLocator {
    lateinit var flutterEngine: FlutterEngine

    var flutterCallback : DartExecutor.DartCallback? = null
}