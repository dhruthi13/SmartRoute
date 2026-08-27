import 'package:flutter/material.dart';

import '../../data/services/favorite_service.dart';

class FavoritesScreen extends StatefulWidget {

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  List<String> routes = [];

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {

    routes =
        await FavoriteService.getRoutes();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Saved Routes',
        ),
      ),

      body: routes.isEmpty

          ? const Center(
              child: Text(
                'No saved routes',
              ),
            )

          : ListView.builder(

              itemCount: routes.length,

              itemBuilder: (context, index) {

                return Card(

                  margin:
                      const EdgeInsets.all(12),

                  child: ListTile(

                    leading:
                        const Icon(Icons.route),

                    title: Text(
                      routes[index],
                    ),
                  ),
                );
              },
            ),
    );
  }
}