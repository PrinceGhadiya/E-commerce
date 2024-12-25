import 'package:ecom/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getAllCategories() async {
    allCategories = await ApiHelper.apiHelper.fetchAllCategorieList();
    setState(() {});
  }

  List allCategories = [];

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme kAppTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories",
              style: kAppTextTheme.labelMedium,
            ),
            // Categories List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12,
                children: List.generate(
                  allCategories.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory =
                            selectedCategory == allCategories[index]
                                ? null
                                : allCategories[index];
                      });
                    },
                    child: Chip(
                      backgroundColor: selectedCategory == allCategories[index]
                          ? Colors.grey[200]
                          : null,
                      label: Text(allCategories[index]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Products",
              style: kAppTextTheme.labelMedium,
            ),
            // Products Grid
            Expanded(
              child: FutureBuilder(
                future: selectedCategory != null
                    ? ApiHelper.apiHelper
                        .getProductsByCategory(selectedCategory!)
                    : ApiHelper.apiHelper.getAllProducts(),
                builder: (context, ss) {
                  if (ss.hasError) {
                    return Center(
                      child: Text("ERROR: ${ss.error}"),
                    );
                  } else if (ss.hasData) {
                    List? rowData = ss.data;
                    List data =
                        rowData == null || rowData.isEmpty ? [] : rowData;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                data[index]['thumbnail'],
                                fit: BoxFit.fitWidth,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.black12,
                              ),
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(12),
                              child: Text(
                                data[index]['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kAppTextTheme.titleMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator.adaptive());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
