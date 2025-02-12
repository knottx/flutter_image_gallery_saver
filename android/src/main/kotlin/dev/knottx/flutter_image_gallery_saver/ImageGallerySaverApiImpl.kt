package dev.knottx.flutter_image_gallery_saver

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.io.OutputStream

import dev.knottx.flutter_image_gallery_saver.ImageGallerySaverApi

class ImageGallerySaverApiImpl(
    private val applicationContext: Context
) : ImageGallerySaverApi {

    override fun saveImage(
        imageBytes: ByteArray,
        completion: (Result<Unit>) -> Unit
    ) {
        val bmp = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
        if (bmp == null) {
            completion(Result.failure(IllegalArgumentException("Failed to decode image bytes")))
            return
        }

        try {
            saveImageInternal(bmp)
            completion(Result.success(Unit))
        } catch (e: Exception) {
            completion(Result.failure(e))
        }
    }

    override fun saveFile(
        filePath: String,
        completion: (Result<Unit>) -> Unit
    ) {
        try {
            saveFileInternal(filePath)
            completion(Result.success(Unit))
        } catch (e: Exception) {
            completion(Result.failure(e))
        }
    }

    private fun saveImageInternal(bmp: Bitmap) {
        val fileUri: Uri = generateUri("jpg")
            ?: throw Exception("Failed to generate file URI")

        val fos: OutputStream = applicationContext.contentResolver
            .openOutputStream(fileUri)
            ?: throw Exception("Failed to open output stream")

        try {
            if (!bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos)) {
                throw Exception("Bitmap compression failed")
            }
            fos.flush()
            sendBroadcast(applicationContext, fileUri)
        } catch (e: IOException) {
            throw e
        } finally {
            fos.close()
            bmp.recycle()
        }
    }

    private fun saveFileInternal(filePath: String) {
        val originalFile = File(filePath)
        if (!originalFile.exists()) throw Exception("$filePath does not exist")

        val fileUri = generateUri(originalFile.extension)
            ?: throw Exception("Failed to generate file URI")

        FileInputStream(originalFile).use { fileInputStream ->
            applicationContext.contentResolver.openOutputStream(fileUri)?.use { outputStream ->
                val buffer = ByteArray(10240)
                var count: Int
                while (fileInputStream.read(buffer).also { count = it } > 0) {
                    outputStream.write(buffer, 0, count)
                }
                outputStream.flush()
            } ?: throw Exception("Failed to open output stream")
        }
    }

    private fun generateUri(extension: String = ""): Uri? {
        val fileName = "${System.currentTimeMillis()}"
        val mimeType = getMIMEType(extension)
        val isVideo = mimeType?.startsWith("video") == true

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val collectionUri = if (isVideo) {
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            } else {
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            }
            val relativePath =
                if (isVideo) Environment.DIRECTORY_MOVIES else Environment.DIRECTORY_PICTURES

            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                mimeType?.let {
                    val mimeKey =
                        if (isVideo) MediaStore.Video.Media.MIME_TYPE else MediaStore.Images.Media.MIME_TYPE
                    put(mimeKey, it)
                }
            }
            applicationContext.contentResolver.insert(collectionUri, values)
        } else {
            val publicDir = if (isVideo) {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)
            } else {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
            }
            val storePath = publicDir.absolutePath
            val appDir = File(storePath).apply {
                if (!exists()) mkdirs()
            }
            val file = if (extension.isNotBlank()) {
                File(appDir, "$fileName.${extension.lowercase()}")
            } else {
                File(appDir, fileName)
            }
            Uri.fromFile(file)
        }
    }

    private fun getMIMEType(extension: String): String? {
        return extension.takeIf { it.isNotBlank() }
            ?.lowercase()
            ?.let { MimeTypeMap.getSingleton().getMimeTypeFromExtension(it) }
    }

    private fun sendBroadcast(context: Context, uri: Uri) {
        val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE).apply {
            data = uri
        }
        context.sendBroadcast(intent)
    }
}