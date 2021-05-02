package de.hskl.swtp_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
