package com.example.schedule

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

class HomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_today_plan)

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            // 日期
            val date = prefs.getString("date", "") ?: ""
            views.setTextViewText(R.id.widget_date, date)

            // 进度
            val completed = prefs.getInt("completedMinutes", 0)
            val target = prefs.getInt("targetMinutes", 0)
            val progressText = if (target > 0) {
                val pct = (completed * 100 / target).coerceIn(0, 100)
                "今日已完成 ${fmtMinutes(completed)} / ${fmtMinutes(target)}  $pct%"
            } else {
                "今日已完成 ${fmtMinutes(completed)}"
            }
            views.setTextViewText(R.id.widget_progress_text, progressText)
            val progress = if (target > 0) (completed * 100 / target).coerceIn(0, 100) else 0
            views.setProgressBar(R.id.widget_progress_bar, 100, progress, false)

            // 下一项提示
            val nextTitle = prefs.getString("nextTitle", "") ?: ""
            val nextTime = prefs.getString("nextTime", "") ?: ""
            if (nextTitle.isNotEmpty()) {
                views.setViewVisibility(R.id.widget_next_item, View.VISIBLE)
                views.setTextViewText(R.id.widget_next_item, "下一项: $nextTitle @ $nextTime")
            } else {
                views.setViewVisibility(R.id.widget_next_item, View.GONE)
            }

            // 绑定 ListView 到 RemoteViewsService
            val intent = Intent(context, WidgetRemoteViewsService::class.java)
            views.setRemoteAdapter(R.id.widget_list, intent)

            // 点击整个小组件打开 App
            val appIntent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, appIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_title, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            // 通知 ListView 刷新
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.widget_list)
        }

        private fun fmtMinutes(minutes: Int): String {
            if (minutes < 60) return "${minutes}分钟"
            val h = minutes / 60
            val m = minutes % 60
            return if (m > 0) "${h}h${m}m" else "${h}h"
        }
    }
}
