import 'package:flutter/material.dart';
import 'package:vetconnect/constants.dart';
import 'package:vetconnect/services/openai_handler.dart';

class BusinessAiSearch extends StatefulWidget {
  const BusinessAiSearch({super.key});

  @override
  State<BusinessAiSearch> createState() => _BusinessAiSearchState();
}

class _BusinessAiSearchState extends State<BusinessAiSearch> {
  
  Future<List<Map<String, dynamic>>> getAIRecommendedBusinesses(String input) async {
    List<Map<String, dynamic>> finalResults = [];
    String searchQuery = await OpenaiHandler.getSearchRecommendation(input);

    if (searchQuery.isNotEmpty) {
      List<Map<String, dynamic>?> results = await Constants.firebaseHelper.searchForBusiness(searchQuery);

      for (Map<String, dynamic>? result in results) {
        if (result != null) { finalResults.add(result); }
      }
    }
    return finalResults;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
