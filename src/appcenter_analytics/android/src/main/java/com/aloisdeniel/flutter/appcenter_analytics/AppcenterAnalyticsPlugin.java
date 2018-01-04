package com.aloisdeniel.flutter.appcenter_analytics;

import java.util.UUID;
import java.util.Map;
import android.app.Application;

import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AppcenterAnalyticsPlugin
 */
public class AppcenterAnalyticsPlugin implements MethodCallHandler {
  private Registrar registrar;

  private AppcenterAnalyticsPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_analytics");

    final AppcenterAnalyticsPlugin plugin = new AppcenterAnalyticsPlugin(registrar);
    channel.setMethodCallHandler(plugin);
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
