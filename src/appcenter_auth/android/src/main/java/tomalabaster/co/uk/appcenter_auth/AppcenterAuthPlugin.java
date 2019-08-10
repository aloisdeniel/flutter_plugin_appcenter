package tomalabaster.co.uk.appcenter_auth;

import android.app.Activity;
import android.support.annotation.NonNull;

import com.microsoft.appcenter.auth.Auth;
import com.microsoft.appcenter.auth.SignInResult;
import com.microsoft.appcenter.utils.async.AppCenterConsumer;
import com.nimbusds.jwt.JWT;
import com.nimbusds.jwt.JWTParser;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AppcenterAuthPlugin */
public class AppcenterAuthPlugin implements MethodCallHandler {

  private final Activity activity;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "uk.co.tomalabaster/flutter_plugin_appcenter/appcenter_auth");
    channel.setMethodCallHandler(new AppcenterAuthPlugin(registrar.activity()));
  }

  private AppcenterAuthPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "signIn":
        this.signIn(call, result);
        break;
      case "signOut":
        this.signOut(call, result);
        break;
      case "isEnabled":
        this.isEnabled(call, result);
        break;
      case "setEnabled":
        this.setEnabled(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void signIn(MethodCall call, final Result result) {
    Auth.getInstance().onActivityResumed(this.activity);
    Auth.signIn().thenAccept(new AppCenterConsumer<SignInResult>() {

      @Override
      public void accept(SignInResult signInResult) {
        Exception exception = signInResult.getException();

        if (exception != null) {
          result.error("Auth error", exception.getLocalizedMessage(), null);
        } else {
          HashMap<String, Object> userInfo = new HashMap<>();

          userInfo.put("idToken", signInResult.getUserInformation().getIdToken());
          userInfo.put("accessToken", signInResult.getUserInformation().getAccessToken());
          userInfo.put("accountId", signInResult.getUserInformation().getAccountId());
          userInfo.put("claims", getClaimsFromIdToken(signInResult.getUserInformation().getIdToken()));

          result.success(userInfo);
        }
      }
    });
  }

  private HashMap<String, Object> getClaimsFromIdToken(String idToken) {
    try {
      JWT parsedToken = JWTParser.parse(idToken);
      return this.traverseMap(new HashMap<>(parsedToken.getJWTClaimsSet().getClaims()));
    } catch (ParseException e) {
      return new HashMap<>();
    }
  }

  private HashMap<String, Object> traverseMap(HashMap<String, Object> map) {
    for (Map.Entry<String, Object> entry : map.entrySet()) {
      if (!isDartType(entry.getValue().getClass())) {
        entry.setValue(entry.getValue().toString());
      }

      if (entry.getValue() instanceof Map) {
        entry.setValue(this.traverseMap((HashMap<String, Object>) entry.getValue()));
      }
    }

    return map;
  }

  private boolean isDartType(Object o) {
    return o == null
            || o instanceof Boolean
            || o instanceof Integer
            || o instanceof Long
            || o instanceof Double
            || o instanceof String
            || o instanceof byte[]
            || o instanceof int[]
            || o instanceof long[]
            || o instanceof double[]
            || o instanceof ArrayList
            || o instanceof HashMap;
  }

  private void signOut(MethodCall call, final Result result) {
      Auth.signOut();
      result.success(null);
  }

  private void isEnabled(MethodCall call, final Result result) {
    Auth.isEnabled().thenAccept(new AppCenterConsumer<Boolean>() {
      @Override
      public void accept(Boolean isEnabled) {
        result.success(isEnabled);
      }
    });
  }

  private void setEnabled(MethodCall call, final Result result) {
    boolean isEnabled = call.argument("isEnabled");

    Auth.setEnabled(isEnabled).thenAccept(new AppCenterConsumer<Void>() {
      @Override
      public void accept(Void aVoid) {
        result.success(null);
      }
    });
  }
}
