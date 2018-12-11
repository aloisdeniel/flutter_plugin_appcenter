package com.aloisdeniel.flutter.appcenter_crashes;

import java.util.UUID;
import android.app.Application;

import com.microsoft.appcenter.crashes.Crashes;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AppcenterCrashesPlugin
 */
public class AppcenterCrashesPlugin implements MethodCallHandler {
  private Registrar registrar;

  private AppcenterCrashesPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "aloisdeniel.github.com/flutter_plugin_appcenter/appcenter_crashes");

    final AppcenterCrashesPlugin plugin = new AppcenterCrashesPlugin(registrar);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {

    switch (call.method) {
      case "isEnabled":
        Crashes.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {
          @Override
          public void accept(Boolean enabled) {
            result.success(enabled.booleanValue());
          }
        });

        break;
      case "setEnabled":
        Boolean isEnabled = call.argument("isEnabled");
        Crashes.setEnabled(isEnabled).thenAccept(new AppCenterConsumer<Void>() {
          @Override
          public void accept(Void v) {
            result.success(null);
          }
        });
        break;
      case "generateTestCrash":
        Crashes.generateTestCrash();
        result.success(0);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
