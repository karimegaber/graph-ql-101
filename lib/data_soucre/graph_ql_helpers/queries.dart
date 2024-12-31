/// [Singleton Class], we only need one instance of it all over the app.
class GraphQLQueries {
  GraphQLQueries._();

  factory GraphQLQueries() => GraphQLQueries._();

  final String categories = r'''
    mutation ($data: CategoryUpdateInput!, $where: CategoryWhereUniqueInput!) {
      updateCategory(data: $data, where: $where) {
        id
        name
        description
        createdAt
      }
    }
  ''';
}
