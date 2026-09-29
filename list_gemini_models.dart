import 'dart:io';
import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Load environment variables
  final env = DotEnv()..load();
  final apiKey = env['GEMINI_API_KEY'];
  
  if (apiKey == null || apiKey.isEmpty) {
    print('❌ GEMINI_API_KEY not found in .env file');
    return;
  }
  
  print('Using API Key: ${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 5)}');
  
  try {
    final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
    
    final response = await http.get(uri);
    
    print('Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('✅ Available Models:');
      if (decoded['models'] != null) {
        for (var model in decoded['models']) {
          print('  - ${model['name']}: ${model['displayName']}');
        }
      } else {
        print('No models found in response');
        print('Response: $response.body');
      }
    } else {
      print('❌ Error: ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}