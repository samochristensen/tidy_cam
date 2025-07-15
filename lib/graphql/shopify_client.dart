import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

GraphQLClient getShopifyClient() {
  final httpLink = HttpLink(
    'https://${dotenv.env['SHOPIFY_DOMAIN']}/api/2025-07/graphql.json',
    defaultHeaders: {
      'X-Shopify-Storefront-Access-Token': dotenv.env['SHOPIFY_TOKEN']!,
    },
  );

  return GraphQLClient(link: httpLink, cache: GraphQLCache());
}
