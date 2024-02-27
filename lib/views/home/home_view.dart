import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Home View"),
        centerTitle: true,
      ),

      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    print("Navegar al listado de películas");
                  },
                  child: const Text("Ir al listado de películas")
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    print("Navegar al listado de películas vistas");
                  },
                  child: const Text("Ir al listado de películas vistas")
              )
            ],
          )),
    );
  }
}
