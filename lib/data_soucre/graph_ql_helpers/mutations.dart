/// [Singleton Class], we only need one instance of it all over the app.
class GraphQLMutations {
  GraphQLMutations._();

  factory GraphQLMutations() => GraphQLMutations._();

  final String updateCategory = r'''
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
