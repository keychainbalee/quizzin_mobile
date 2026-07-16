# Keep Firebase classes
-keep class com.google.firebase.** { *; }
# Keep Flutter classes
-keep class io.flutter.** { *; }
# Keep your package's classes
-keep class com.example.quizzin.** { *; }
# Keep native methods
-keepclassmembers class com.example.quizzin.** { native <methods>; }

# Keep app package classes
-keep class com.hn.quizzin.** { *; }
-keepclassmembers class com.hn.quizzin.** { native <methods>; }

# TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Google ML Kit & Play Services
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# Play Core Split Install (Deferred Components)
-dontwarn com.google.android.play.core.**