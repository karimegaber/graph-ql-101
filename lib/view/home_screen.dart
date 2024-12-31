import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/model/category_model.dart';
import 'package:testing/view_model/home_screen_view_model.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing GraphQL"),
      ),
      body: Consumer<HomeScreenViewModel>(
        builder: (context, viewModel, child) => RefreshIndicator(
          onRefresh: () => viewModel.getCategoriesData(refresh: true),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            // Enable refresh when the widgets doesn't cover the whole screen.
            // Comment it and try to refresh the screen, it won't refresh.
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                if (viewModel.categories == null) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.categories!.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      CategoryModel category = viewModel.categories![index];

                      return GestureDetector(
                        onTap: () {
                          viewModel.setCurrentCategoryId(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: viewModel.isCategorySelected(index) ? Colors.green.shade100 : Colors.grey.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Name
                                  Expanded(
                                    child: Text(
                                      category.name!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Date
                                  Text(
                                    intl.DateFormat.yMMMd().format(DateTime.parse(category.createdAt!)).toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              // Description
                              Text(
                                category.description!,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 25),

                // Add Description
                const Text(
                  "Instructions:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text("Click on a category and then add the description you want."),
                const SizedBox(height: 5),

                // Description Text Field
                TextField(
                  enabled: viewModel.descriptionFieldIsEnabled,
                  controller: viewModel.descriptionController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                // Hint to select a category
                if (!viewModel.descriptionFieldIsEnabled) ...[
                  const SizedBox(height: 5),
                  const Text(
                    "Select a category first...",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Add Description Button
                if (viewModel.isLoading) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: viewModel.addDescriptionButtonIsEnabled
                          ? () {
                              viewModel.setCategoryDescription();
                            }
                          : null,
                      child: const Text(
                        "Add Description",
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
