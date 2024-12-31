import 'package:graphql/client.dart';

class GraphQLHandler {
  // This is the URL you will use all over the app (No more End-Points!).
  static const String _graphQlUrl = "https://us-west-2.cdn.hygraph.com/content/cm4ynr1va05z507w6by5j83l0/master";

  // HttpLink will be used to call and customize your GraphQL
  static final HttpLink _httpLink = HttpLink(
    _graphQlUrl, // the GraphQL link.
    defaultHeaders: {}, // Add your headers here if required.
  );

  // a getter for the GraphQL client, will be used to call queries or mutations.
  static GraphQLClient get graphQLClient => GraphQLClient(
        link: _httpLink,
        cache: GraphQLCache(),
      );
}
