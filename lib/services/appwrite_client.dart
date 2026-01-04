import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteClient {
  static final Client client = Client()
      .setEndpoint(dotenv.env['APPWRITE_ENDPOINT'] ?? '')
      .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '')
      .setSelfSigned(status: true); // remove in production

  static final Account account = Account(client);
}
