import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<dynamic> repositories = [];
  String readRepositories = r'''
 query {
  characters() {
    results {
      name
      image
      gender 
    }
  }
  
}
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: ListView.builder(
        itemCount: repositories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(repositories[index]['image'].toString()),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repositories[index]['name'].toString()),
                    Text(repositories[index]['gender'].toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  fetchData() async {
    final httpLink = HttpLink(
      'https://rickandmortyapi.com/graphql',
    );

    final GraphQLClient client = GraphQLClient(
      /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: httpLink,
    );

    int nRepositories = 50;

    final QueryOptions options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'nRepositories': nRepositories,
      },
    );
    // ...

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
    }

    setState(() {
      repositories = result.data!['characters']['results'] as List<dynamic>;
    });

// ...
  }
}
