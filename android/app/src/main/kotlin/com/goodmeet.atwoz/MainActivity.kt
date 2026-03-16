package com.goodmeet.deepple

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private companion object {
        const val photoPermissionChannel = "com.goodmeet.deepple/photo_permission"
        const val photoPermissionRequestCode = 4001
    }

    private var pendingPhotoPermissionResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel() // 채널 생성 호출
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            photoPermissionChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestFullGalleryAccess" -> requestFullGalleryAccess(result)
                else -> result.notImplemented()
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        if (requestCode == photoPermissionRequestCode) {
            pendingPhotoPermissionResult?.success(hasFullGalleryAccess())
            pendingPhotoPermissionResult = null
            return
        }

        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = getString(R.string.default_notification_channel_id)
            val channelName = "Urgent Notifications"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(channelId, channelName, importance)
            channel.description = "Default channel for FCM push"

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun requestFullGalleryAccess(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            result.success(false)
            return
        }

        if (hasFullGalleryAccess()) {
            result.success(true)
            return
        }

        if (hasLimitedGalleryAccess()) {
            result.success(false)
            return
        }

        if (pendingPhotoPermissionResult != null) {
            result.error(
                "permission_request_in_progress",
                "Photo permission request already in progress.",
                null,
            )
            return
        }

        pendingPhotoPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.READ_MEDIA_IMAGES,
                Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED,
            ),
            photoPermissionRequestCode,
        )
    }

    private fun hasFullGalleryAccess(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            return false
        }

        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_MEDIA_IMAGES,
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun hasLimitedGalleryAccess(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return false
        }

        val hasSelectedPhotosPermission =
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED,
            ) == PackageManager.PERMISSION_GRANTED
        return hasSelectedPhotosPermission && !hasFullGalleryAccess()
    }
}
