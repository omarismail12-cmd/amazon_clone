import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final picker = ImagePicker();

/// Phone number of the currently signed-in user, or null if nobody is
/// signed in or the account has no phone number attached. Firestore doc
/// IDs are keyed off this, so callers must check for null instead of
/// force-unwrapping `auth.currentUser!.phoneNumber`.
String? get currentUserPhone => auth.currentUser?.phoneNumber;
// Only the Razorpay key ID belongs in the client. The key secret must never
// ship in the app; order creation and payment signature verification have
// to happen on a backend (e.g. a Cloud Function) that holds the secret and
// is called from here instead of building the Razorpay `options` map
// directly on-device. No such backend exists yet — this needs to be added
// before going live.
const String keyID = 'rzp_test_TZvU4eurVLhnvu';

List<String> categories = [
  'Prime',
  'Electronics',
  'Business',
  'Home',
  'Grocery',
  'Mobiles',
  'Fashion',
  'Deals',
  'Travel',
  'Beauty',
  'Furniture',
  'Pharmacy',
  'Movies',
  'Books',
  'Appliances',
  'More',
];

List<String> productCategories = [
  'Select Category',
  'Electronics',
  'Home',
  'Mobiles',
  "Men's Fashion",
  "Women's Fashion",
  'Sports & Shoes',
  'Travel',
  'Beauty',
  'Furniture',
  'Pharmacy',
  'Movies',
  'Grocery',
  'Books',
  'More'
];
