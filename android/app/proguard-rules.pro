-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# Firebase Auth
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.auth.internal.** { *; }

# Prevent R8 from stripping Flutter classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }

# Prevent warnings
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Retain annotations and generics
-keepattributes Signature
-keepattributes *Annotation*

# Keep Google Play Core split install and compatibility classes
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**