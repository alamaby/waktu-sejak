package com.alamaby.waktu_sejak

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class WaktuSejakWidgetProvider : HomeWidgetProvider() {

    private data class RowIds(
        val container: Int,
        val emoji: Int,
        val title: Int,
        val subtitle: Int,
    )

    private val rows = listOf(
        RowIds(R.id.row_0, R.id.emoji_0, R.id.title_0, R.id.subtitle_0),
        RowIds(R.id.row_1, R.id.emoji_1, R.id.title_1, R.id.subtitle_1),
        RowIds(R.id.row_2, R.id.emoji_2, R.id.title_2, R.id.subtitle_2),
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.waktu_sejak_widget)

            views.setTextViewText(
                R.id.widget_title,
                widgetData.getString("title_label", "Waktu Sejak")
            )

            val all = widgetData.all
            val count = (all["count"] as? Number)?.toInt() ?: 0

            if (count == 0) {
                views.setViewVisibility(R.id.empty_label, View.VISIBLE)
                views.setTextViewText(
                    R.id.empty_label,
                    widgetData.getString("empty_label", "No events")
                )
                rows.forEach { views.setViewVisibility(it.container, View.GONE) }
            } else {
                views.setViewVisibility(R.id.empty_label, View.GONE)
                rows.forEachIndexed { i, r ->
                    if (i < count) {
                        views.setViewVisibility(r.container, View.VISIBLE)
                        views.setTextViewText(r.emoji, widgetData.getString("event_${i}_emoji", ""))
                        views.setTextViewText(r.title, widgetData.getString("event_${i}_title", ""))
                        views.setTextViewText(r.subtitle, widgetData.getString("event_${i}_subtitle", ""))
                        val colorInt = (all["event_${i}_color"] as? Number)?.toInt() ?: Color.DKGRAY
                        views.setInt(r.container, "setBackgroundColor", colorInt)

                        val eventId = widgetData.getString("event_${i}_id", null)
                        if (eventId != null) {
                            val intent = HomeWidgetLaunchIntent.getActivity(
                                context,
                                MainActivity::class.java,
                                Uri.parse("waktusejak://event/$eventId")
                            )
                            views.setOnClickPendingIntent(r.container, intent)
                        }
                    } else {
                        views.setViewVisibility(r.container, View.GONE)
                    }
                }
            }

            val openApp = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("waktusejak://open")
            )
            views.setOnClickPendingIntent(R.id.widget_root, openApp)

            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
