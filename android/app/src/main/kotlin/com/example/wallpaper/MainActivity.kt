package com.example.wallpaper

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.wallpaper/wallpaper"

    override fun configureFlutterEngine(@NonNull flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val imagePath = call.argument<String>("imagePath")
                val type = call.argument<String>("type")

                if (imagePath != null && type != null) {
                    // Use coroutine to set wallpaper in a background thread
                    CoroutineScope(Dispatchers.IO).launch {
                        val success = setWallpaper(imagePath, type)
                        runOnUiThread {
                            if (success) {
                                result.success(1)
                            } else {
                                result.error("UNAVAILABLE", "Setting wallpaper failed.", null)
                            }
                        }
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Arguments missing.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

   private fun setWallpaper(imagePath: String, type: String): Boolean {
    return try {
        val wallpaperManager = WallpaperManager.getInstance(applicationContext)

        // Load the image efficiently
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = true
        BitmapFactory.decodeFile(imagePath, options)

        // Calculate an appropriate sample size to reduce memory usage
        options.inSampleSize = calculateInSampleSize(options, 1080, 1920)
        options.inJustDecodeBounds = false
        val bitmap = BitmapFactory.decodeFile(imagePath, options)

        when (type) {
            "home" -> wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
            "lock" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                }
            }
            "both" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK)
                } else {
                    wallpaperManager.setBitmap(bitmap)
                }
            }
            else -> return false
        }
        true
    } catch (e: IOException) {
        e.printStackTrace()
        false
    }
}

private fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
    // Raw height and width of image
    val height = options.outHeight
    val width = options.outWidth
    var inSampleSize = 1

    if (height > reqHeight || width > reqWidth) {
        val halfHeight = height / 2
        val halfWidth = width / 2

        // Calculate the largest inSampleSize value that is a power of 2 and keeps both
        // height and width larger than the requested height and width.
        while (halfHeight / inSampleSize >= reqHeight && halfWidth / inSampleSize >= reqWidth) {
            inSampleSize *= 2
        }
    }
    return inSampleSize
}

}