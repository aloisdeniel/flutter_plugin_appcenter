package com.aloisdeniel.flutter.appcenter_analytics;

import androidx.annotation.NonNull;

import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AppcenterAnalyticsPlugin
 */
public class AppcenterAnalyticsPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_analytics");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {

    switch (call.method) {
      case "isEnabled":
        Analytics.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {
          @Override
          public void accept(Boolean enabled) {
            result.success(enabled.booleanValue());
          }
        });

        break;
      case "setEnabled":
        Boolean isEnabled = call.argument("isEnabled");
        Analytics.setEnabled(isEnabled).thenAccept(new AppCenterConsumer<Void>() {
          @Override
          public void accept(Void v) {
            result.success(null);
          }
        });
        break;
      case "trackEvent":
        String name = call.argument("name");
        Map<String, String> properties = call.argument("properties");
        Analytics.trackEvent(name, properties);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
