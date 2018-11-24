package com.aloisdeniel.flutter.appcenter;

import java.util.UUID;
import java.util.List;
import java.util.ArrayList;
import android.app.Application;

import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AppcenterPlugin
 */
public class AppcenterPlugin implements MethodCallHandler {

  private Registrar registrar;

  private AppcenterPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "aloisdeniel.github.com/flutter_plugin_appcenter/appcenter");

    final AppcenterPlugin plugin = new AppcenterPlugin(registrar);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {

    Application app = this.registrar.activity().getApplication();

    switch (call.method) {
      case "installId":
        AppCenter.getInstallId().thenAccept(new AppCenterConsumer<UUID>() {
          @Override
          public void accept(UUID uuid) {
            result.success(uuid.toString());
          }
        });

        break;
      case "isEnabled":
        AppCenter.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {
          @Override
          public void accept(Boolean enabled) {
            result.success(enabled.booleanValue());
          }
        });

        break;
      case "setEnabled":
        Boolean isEnabled = call.argument("isEnabled");
        AppCenter.setEnabled(isEnabled).thenAccept(new AppCenterConsumer<Void>() {
          @Override
          public void accept(Void v) {
            result.success(null);
          }
        });
        break;
      case "configure":
        String secret = call.argument("app_secret");
        AppCenter.configure(app, secret);
        result.success(null);
        break;
      case "start":
        String start_secret = call.argument("app_secret");
        List<String> services = call.argument("services");
        List<Class> servicesClasses = new ArrayList<Class>();
        for (String name : services) {
          try {
            Class c = Class.forName(name);
            servicesClasses.add(c);
          }
          catch(ClassNotFoundException notFound) {
            System.out.print(notFound.getException().toString());
          }
        }

        Class[] servicesClassesArray = new Class[servicesClasses.size()];
        servicesClassesArray = servicesClasses.toArray(servicesClassesArray);
        AppCenter.start(app, start_secret, servicesClassesArray);
        result.success(null);
        break;

      default:
        result.notImplemented();
        break;
    }
  }
}
