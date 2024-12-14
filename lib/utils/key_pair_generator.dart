import 'package:fast_rsa/fast_rsa.dart';

Future<Map<String, String>> generateRSAKeyPair() async {
  try {
    // Generate RSA keys
    final keys = await RSA.generate(2048);

    // Return the keys as a map
    return {
      'publicKey': keys.publicKey,
      'privateKey': keys.privateKey,
    };
  } catch (e) {
    print('Error generating keys: $e');
    return {};
  }
}
