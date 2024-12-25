import 'package:flutter/material.dart';

import '../../utils/helper/api_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? searchText;
  @override
  Widget build(BuildContext context) {
    TextTheme kAppTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          spacing: 16,
          children: [
            TextField(
              onChanged: (value) {
                searchText = value;
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search Here...",
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: ApiHelper.apiHelper
                    .searchProducts(searchText == null ? "all" : searchText!),
                builder: (context, ss) {
                  if (ss.hasError) {
                    return Center(
                      child: Text("ERROR: ${ss.error}"),
                    );
                  } else if (ss.hasData) {
                    List? rowData = ss.data;
                    List data =
                        rowData == null || rowData.isEmpty ? [] : rowData;
                    return data.isEmpty
                        ? Center(
                            child: Text("No Products Found..."),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red));
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
