package com.example.front

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngine.EngineLifecycleListener
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.view.FlutterCallbackInformation
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext

class UploadWorker(appContext: Context, workerParams: WorkerParameters):
    CoroutineWorker(appContext, workerParams) {
    private val CHANNEL = "secat.jhl.dev/alert"

    override suspend fun doWork(): Result {


        withContext(Dispatchers.Main) {

            val flutterEngine = ServiceLocator.flutterEngine
            val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()

            ServiceLocator.flutterCallback?.run {
                flutterEngine.dartExecutor.executeDartCallback(this)
            }

            flutterEngine.addEngineLifecycleListener(object : EngineLifecycleListener {
                override fun onPreEngineRestart() {
                    Log.d("caz tst","flutter engin restart")
                }

                override fun onEngineWillDestroy() {
                    Log.d("caz tst","flutter engin lost")
                }
            })


            repeat(300) {
                Log.d("caz tst","maintain Method channel")
                delay(timeMillis = 3000L)
            }
            // Do the work here--in this case, upload the images.
        }
        // Indicate whether the work finished successfully with the Result
        return Result.success()
    }


}
