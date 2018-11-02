package com.v2ex.flutterv2ex;

import android.os.Bundle;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.v2ex.flutterv2ex.parsehtml.TopicListModel;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.v2ex/android";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if(methodCall.method.equals("parseHtml")){
          if(methodCall.hasArgument("response") && !TextUtils.isEmpty(methodCall.argument("response").toString())){
            TopicListModel topicListModel = new TopicListModel();
            try {
              topicListModel.parse(methodCall.argument("response").toString());
              Gson gson = new Gson();
              String jsonResult = gson.toJson(topicListModel);
              result.success(jsonResult);
            } catch (Exception e) {
              e.printStackTrace();
            }
          }
        }
      }
    });
  }
}
