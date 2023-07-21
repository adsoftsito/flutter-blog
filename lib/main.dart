import 'blog_row.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

final HttpLink httpLink = HttpLink(
    "https://api-us-west-2.hygraph.com/v2/clkd777q355uq01t56s7h6f6c/master");
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

const String query = """
query Content{
  posts{
    id
    title
    excerpt
    coverImage {
      url
    }
  }
}
""";

const String updatePostMutation = """
mutation {
  updatePost(
    where: { id: "ckadrcx4g00pw01525c5d2e56" }
    data: { author: "Elijah Asaolu" }
  ) {
    id
    name
    price
  }
}
""";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          title: 'GraphQL Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Hygraph Blog",
              ),
            ),
            body: Query(
                options: QueryOptions(
                    document: gql(query),
                    variables: const <String, dynamic>{
                      "variableName": "value"
                    }),
                builder: (result, {fetchMore, refetch}) {
                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (result.data == null) {
                    return const Center(
                      child: Text("No article found!"),
                    );
                  }
                  final posts = result.data!['posts'];
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final title = post['title'];
                      final excerpt = post['excerpt'];
                      final coverImageURL = post!['coverImage']['url'];
                      return BlogRow(
                        title: title,
                        excerpt: excerpt,
                        coverURL: coverImageURL,
                      );
                    },
                  );
                }),
          )),
    );
  }
}
