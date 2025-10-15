package com.example.flutter_multiecommerce_riverpod_fix

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

// MainActivity يجب أن ترث FlutterFragmentActivity ليتوافق مع flutter_stripe
class MainActivity : FlutterFragmentActivity() {
    // لا حاجة لتعريف onCreate إلا إذا عندك تخصيصات أخرى
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // إذا تحتاج أي تهيئة خاصة ضعها هنا
    }
}
