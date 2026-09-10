# Amazon Clone (Flutter)

A full-stack e-commerce app built with Flutter and Firebase, modeled after Amazon's
shopping experience — built as a learning/portfolio project, not affiliated with
or endorsed by Amazon.com, Inc.

**Live demo:** https://amazon-clone-topaz-pi.vercel.app

## What it does

Buyer side:
- Phone-number sign-in (Firebase Auth OTP)
- Browse by category, search with debounced live filtering, voice search
- Product detail pages with image carousel, ratings & reviews
- Cart, checkout (Razorpay), order history, wishlist, browsing history
- Address management

Seller side:
- Toggle between buyer/seller account type at signup
- Add products (multi-image upload or manual image URLs), inventory list
- Sales monitoring dashboard

## Tech stack

- **Flutter** (Android, iOS, Web)
- **Firebase**: Auth (phone/OTP), Cloud Firestore, hosted rules in `firestore.rules`
- **Razorpay** for payment checkout
- **ImgBB** for product image hosting
- **Provider** for state management

## Known limitations on the live web demo

The web build is convenient for a quick look, but a couple of things behave
differently there than on Android/iOS:

- **Checkout doesn't work on web.** The Razorpay Flutter plugin only ships
  Android and iOS implementations — tapping "Buy Now" / "Proceed to Buy" in a
  browser will fail. Cart and Add to Cart still work; try checkout on a mobile
  build.
- **Phone sign-in may behave differently on web** than on a native app —
  Firebase's web phone-auth flow depends on reCAPTCHA and the domain being
  authorized in the Firebase console, and can be flakier than the native SDK
  flow.

## Running locally

```bash
flutter pub get
flutter run
```

Firebase config for all platforms lives in `lib/firebase_options.dart`
(generated via `flutterfire configure`); Android/iOS also need
`android/app/google-services.json` / `ios/Runner/GoogleService-Info.plist`,
already included in this repo since they only contain public client
identifiers, not secrets.

## Status

This is an active portfolio project — expect rough edges. The Android build
still uses the default `com.example.amazon` application ID and debug signing,
so it's not yet configured for a real Play Store release.
