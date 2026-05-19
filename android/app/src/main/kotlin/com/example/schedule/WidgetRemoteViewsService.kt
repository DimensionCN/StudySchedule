package com.example.schedule

import android.content.Context
import android.content.Intent
import android.graphics.Paint
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray

class WidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return WidgetRemoteViewsFactory(applicationContext)
    }
}

class WidgetRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private var items = mutableListOf<WidgetItem>()
    private var activeIndex = -1

    override fun onCreate() {}

    override fun onDataSetChanged() {
        items.clear()
        activeIndex = -1

        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val jsonStr = prefs.getString("items", "[]") ?: "[]"

        try {
            val arr = JSONArray(jsonStr)
            if (arr.length() == 0) {
                // 空状态
                items.add(WidgetItem.empty())
                return
            }

            val allItems = mutableListOf<WidgetItem>()

            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                val item = WidgetItem(
                    time = obj.getString("time"),
                    name = obj.getString("name"),
                    done = obj.getBoolean("done"),
                    active = obj.getBoolean("active"),
                    start = obj.getInt("start"),
                    duration = obj.optString("duration", "")
                )
                allItems.add(item)
            }

            // 按 start 排序
            allItems.sortBy { it.start }

            // 找 active 在排序后的位置
            activeIndex = allItems.indexOfFirst { it.active }

            if (activeIndex >= 0) {
                val centerPos = allItems.size / 2
                val offset = centerPos - activeIndex

                // 顶部空行填充
                val paddingCount = if (offset > 0) offset else 0
                for (i in 0 until paddingCount) {
                    items.add(WidgetItem.empty())
                }

                items.addAll(allItems)

                // 底部对称空行
                for (i in 0 until paddingCount) {
                    items.add(WidgetItem.empty())
                }
            } else {
                items.addAll(allItems)
            }
        } catch (e: Exception) {
            items.add(WidgetItem.empty())
        }
    }

    override fun onDestroy() { items.clear() }
    override fun getCount(): Int = items.size

    override fun getViewAt(position: Int): RemoteViews {
        val item = items[position]

        // 空行
        if (item.isEmpty) {
            return RemoteViews(context.packageName, R.layout.widget_list_item).apply {
                setViewVisibility(R.id.item_icon, View.INVISIBLE)
                setTextViewText(R.id.item_time, "")
                setTextViewText(R.id.item_name, "")
                setViewVisibility(R.id.item_duration, View.GONE)
                setViewVisibility(R.id.item_status, View.GONE)
            }
        }

        return RemoteViews(context.packageName, R.layout.widget_list_item).apply {
            // 图标
            if (item.active) {
                setImageViewResource(R.id.item_icon, android.R.drawable.ic_media_play)
            } else if (item.done) {
                setImageViewResource(R.id.item_icon, android.R.drawable.checkbox_on_background)
            } else {
                setImageViewResource(R.id.item_icon, android.R.drawable.checkbox_off_background)
            }

            setTextViewText(R.id.item_time, item.time)
            setTextViewText(R.id.item_name, item.name)

            // 时长
            if (item.duration.isNotEmpty()) {
                setViewVisibility(R.id.item_duration, View.VISIBLE)
                setTextViewText(R.id.item_duration, item.duration)
            } else {
                setViewVisibility(R.id.item_duration, View.GONE)
            }

            // 样式
            if (item.active) {
                // 进行中：蓝色高亮
                setInt(R.id.item_name, "setTextColor", 0xFF2196F3.toInt())
                setTextViewText(R.id.item_name, "▶ ${item.name}")
                setInt(R.id.item_time, "setTextColor", 0xFF2196F3.toInt())
                setInt(R.id.item_duration, "setTextColor", 0xFF2196F3.toInt())
            } else if (item.done) {
                // 已完成：灰色 + 删除线
                setInt(R.id.item_name, "setTextColor", 0xFFAAAAAA.toInt())
                setInt(R.id.item_time, "setTextColor", 0xFFAAAAAA.toInt())
                setInt(R.id.item_duration, "setTextColor", 0xFFAAAAAA.toInt())
                // 通过 flags 设置删除线
                setInt(R.id.item_name, "setPaintFlags", Paint.STRIKE_THRU_TEXT_FLAG)
            } else {
                // 未完成：正常颜色
                setInt(R.id.item_name, "setTextColor", 0xFF333333.toInt())
                setInt(R.id.item_time, "setTextColor", 0xFF999999.toInt())
                setInt(R.id.item_duration, "setTextColor", 0xFF999999.toInt())
                setInt(R.id.item_name, "setPaintFlags", 0)
            }
        }
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}

data class WidgetItem(
    val time: String = "",
    val name: String = "",
    val done: Boolean = false,
    val active: Boolean = false,
    val start: Int = 0,
    val duration: String = "",
    val isEmpty: Boolean = false
) {
    companion object {
        fun empty() = WidgetItem(isEmpty = true)
    }
}
