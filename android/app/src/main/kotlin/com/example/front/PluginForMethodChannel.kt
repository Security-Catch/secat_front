package com.example.front

import android.content.Context
import android.content.Intent
import android.util.Log
import com.shounakmulay.telephony.sms.ContextHolder.applicationContext
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.StandardMethodCodec

class PluginForMethodChannel : FlutterPlugin, MethodCallHandler {
    private val CHANNEL = "secat.jhl.dev/alert"

    var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("caz tst","engine!")
        context = binding.applicationContext
        MethodChannel(
            binding.binaryMessenger,
            CHANNEL,
            StandardMethodCodec.INSTANCE,
        ).setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("caz tst","engine T^T")

        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        Log.d("caz tst","deeeee ${call.method}")
        if(call.method != "initialize") {
            Log.d("caz tst","deeeeeeeeeeeeteeeeeeeeectttttttionoinonoß")
            val messageTitleContent = call.argument<String>("message_title_content")
            val message = call.argument<String>("message")
            val phoneNumber = call.argument<String>("phone_number")

            messageTitleContent?.let { title ->
                message?.let { content ->
                    phoneNumber?.let { number ->
                        context?.let {
                            startOverlayService(
                                it,
                                title,
                                content,
                                number
                            )
                        }
                    }
                }
            }
        }
    }

    private fun startOverlayService(
        context: Context,
        messageTitleContent: String,
        message : String,
        phoneNumber: String
    ) {
        Log.d("caz tst" ,"gve me info of intent")

        val intent = Intent(context, OverlayService::class.java)
        intent.putExtra("message_title_content",messageTitleContent)
        intent.putExtra("message",message)
        intent.putExtra("phone_number",phoneNumber)
        context.startService(intent)
    }

}