import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:testing/data_soucre/graph_ql_helpers/queries.dart';
import 'package:testing/data_soucre/graph_ql_helpers/mutations.dart';
import 'package:testing/model/category_model.dart';
import 'package:testing/data_soucre/remote/graph_ql_handler.dart';

class HomeScreenViewModel extends ChangeNotifier {
  // Get Instances from Queries and Mutations Singleton classes.
  final GraphQLQueries _graphQLQueries = GraphQLQueries();
  final GraphQLMutations _graphQLMutations = GraphQLMutations();

  // Will be used to call queries or mutations.
  GraphQLClient get _client => GraphQLHandler.graphQLClient;

  // Check if updating the description is still in progress.
  bool isLoading = false;

  ///  [indexOfCurrentCategory] will be used for immediately update the description locally,
  ///                           Because the update process is not working in this GraphQL,
  ///                           Also, instead of sending another request to get the data again.
  int indexOfCurrentCategory = -1;

  // Will be used to update category description.
  // Also coloring the selected category.
  String currentCategoryId = "";

  // List of categories in the screen.
  List<CategoryModel>? categories;

  // Holds the description text for the category we want to update.
  final TextEditingController descriptionController = TextEditingController();

  /*
   Enable the TextField when: - There is no update description call is in progress.
                              - Categories is not still loading (Data is already here).
                              - There is a selected category.
  
  */
  bool get descriptionFieldIsEnabled => !isLoading && categories != null && currentCategoryId.isNotEmpty;

  // When the Add Description button is enabled.
  bool get addDescriptionButtonIsEnabled => currentCategoryId.isNotEmpty || indexOfCurrentCategory != -1 || descriptionController.text.isNotEmpty;

  // Check if the category is selected or not [ For UI purpose ].
  bool isCategorySelected(index) {
    return currentCategoryId == categories![index].id;
  }

  // Resetting all the data
  void clearAllData() {
    isLoading = false;
    categories = null;
    indexOfCurrentCategory = -1;
    currentCategoryId = "";
    descriptionController.clear();

    notifyListeners();
  }

  // Getting the data and store it in [categories] list.
  Future<void> getCategoriesData({bool refresh = false}) async {
    if (refresh) {
      clearAllData();
    }

    categories = await getCategories();

    notifyListeners();
  }

  // Setting the current selected category data [ Index and ID ]
  void setCurrentCategoryId(index) {
    indexOfCurrentCategory = index;
    currentCategoryId = categories![index].id!;

    notifyListeners();
  }

  /// [Queries]
  Future<List<CategoryModel>> getCategories() async {
    try {
      final document = gql(_graphQLQueries.categories);

      final result = await _client.query(
        QueryOptions(
          document: document,
        ),
      );

      _logger('getCategories() Response => ${result.data}');

      if (result.hasException || result.data == null) {
        return [];
      }

      List<CategoryModel> categories = [];

      for (var item in (result.data?['categories'] ?? {})) {
        categories.add(CategoryModel.fromJson(item));
      }

      return categories;
    } catch (error) {
      _logger("Error in getCategories is => ${error.toString()}");
      return [];
    }
  }

  /// [Mutations]
  Future<void> setCategoryDescription() async {
    try {
      isLoading = true;
      notifyListeners();

      final document = gql(_graphQLMutations.updateCategory);

      final result = await _client.mutate(
        MutationOptions(
          document: document,
          variables: {
            "data": {
              "description": descriptionController.text,
            },
            "where": {
              "id": currentCategoryId,
            },
            "stage": "PUBLISHED",
          },
        ),
      );

      _logger("Update Category Response => ${result.data}");

      if (result.hasException || result.data == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      categories![indexOfCurrentCategory] = CategoryModel.fromJson(
        result.data?['updateCategory'],
      );

      isLoading = false;
      indexOfCurrentCategory = -1;
      currentCategoryId = "";
      descriptionController.clear();
      isLoading = false;
      notifyListeners();
    } catch (error) {
      _logger("Error in setCategoryDescription is => ${error.toString()}");

      isLoading = false;
      notifyListeners();
    }
  }

  // Log
  void _logger(String text) {
    if (kDebugMode) {
      log(text);
    }
  }
}
