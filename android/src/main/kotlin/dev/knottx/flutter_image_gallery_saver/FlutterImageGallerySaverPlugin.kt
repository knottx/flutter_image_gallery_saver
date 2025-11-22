package dev.knottx.flutter_image_gallery_saver

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
 
import dev.knottx.flutter_image_gallery_saver.ImageGallerySaverApi

class FlutterImageGallerySaverPlugin : FlutterPlugin {
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        ImageGallerySaverApi.setUp(
            binding.binaryMessenger,
            ImageGallerySaverApiImpl(applicationContext),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) { 
        ImageGallerySaverApi.setUp(binding.binaryMessenger, null)
    }
}