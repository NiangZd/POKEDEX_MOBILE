import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'view/lista_pokemons/tela_listagem.dart';
import 'view/lista_pokemons/tela_detalhe.dart';
import 'view/encontro_diario/tela_pokemon_dia.dart';
import 'view/meus_pokemons/tela_detalhes_meus_pokemons.dart';
import 'view/meus_pokemons/tela_listagem_meus_pokemons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/lista-pokemons': (context) => const ListaPokemons(),
        '/detalhes-pokemon': (context) => const TelaDetalhe(),
        '/encontro-diario': (context) => const ExibicaoPokDia(),
        '/meus-pokemons': (context) => const ListaMeusPokemons(),
        '/detalhes-meu-pokemon': (context) => const TelaDetalheMeusPok(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokédex Início",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 226, 0, 0),
      ),
      body: Container(
        // PESQUISEI COMO COLOCAVA IMAGEM DE FUNDO
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              'https://fotoseimagens.net/wp-content/uploads/2018/12/wallpaper-hd-para-celular-pokemon-go-team-mystic-9.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo à Pokédex!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CachedNetworkImage(
                  imageUrl: 'https://occ-0-8407-2219.1.nflxso.net/dnm/api/v6/LmEnxtiAuzezXBjYXPuDgfZ4zZQ/AAAABeks7WmY2ze14bA1tk-_N4x6xUw5ypMvrgFD2boFe7OBqERCFdNHFJO1SsYJhUCXJaiaMtS4X7k7llApuxSdzSU-FeMjNum_mDqXR7xj0ZVN.png?r=f32',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 226, 0, 0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/lista-pokemons');
                },
                child: const Text(
                  'Pokédex',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 226, 0, 0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/encontro-diario');
                },
                child: const Text(
                  'Encontro Diário',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 226, 0, 0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/meus-pokemons');
                },
                child: const Text(
                  'Meus Pokémons',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
