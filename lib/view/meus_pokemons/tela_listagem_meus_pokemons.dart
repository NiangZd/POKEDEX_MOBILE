import 'package:flutter/material.dart';
import '../../components/cardmeuspokemons.dart';
import '../../class/Pokemon.dart';
import '../../db/database_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaMeusPokemons extends StatefulWidget {
  const ListaMeusPokemons({super.key});

  @override
  State<ListaMeusPokemons> createState() => _ListaMeusPokemonsState();
}

class _ListaMeusPokemonsState extends State<ListaMeusPokemons> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Pokemon> pokemons = [];
  bool carregado = false;

  // EU INICIO O ESTADO DA TELA CARREGANDO OS POKEMONS NA FUNÇÃO CARREGARPOKEMONS
  @override
  void initState() {
    super.initState();
    carregarPokemons();
  }

  // FUNÇÃO PRA CARREGAR OS POKEMONS DO DIA
  Future<void> carregarPokemons() async {
    setState(() {
      // COMEÇA O CARREGAMENTO
      carregado = true;
    });

    // FAZ A TENTATIVA DE TRAZER OS DADOS DO CACHE DOS MEUS POKEMONS
    try {
      final cachedPokemons = await dbHelper.getMeusPokemons();

      // SE NÃO FOR VAZIO, ADICIONA OS POKEMONS NA LISTA DE POKEMONS PRA EXIBIR
      if (cachedPokemons.isNotEmpty) {
        setState(() {
          pokemons = cachedPokemons;
        });
      } else {
        _showErrorDialog("Nenhum Pokémon encontrado.");
      }
    } catch (e) {
      print("Erro ao carregar os Pokémons: $e");
      _showErrorDialog("Erro ao carregar os Pokémons."); 
    } finally {
      setState(() {
        carregado = false; 
      });
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LISTA DOS MEUS POKÉMONS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), 
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              'https://e0.pxfuel.com/wallpapers/409/392/desktop-wallpaper-pokemon-go-pokeball-black-iphone.jpg'
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: carregado
            ? const CircularProgressIndicator() 
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // AQUI EU USO O LISTVIEW PARA EXIBIR OS POKEMONS EM CONSTRUÇÃO DE LISTA
                    child: ListView.builder(
                      // QUE VAI DEPENDER DO TAMANHO DA LISTA DE POKEMONS
                      itemCount: pokemons.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        // O FILHO VAI SER O CARD POKEMON, PARA O TAMANHO DA LISTA, VAI ADICIONAR OS POKEMONS A LISTVIEW
                        child: CardPokemon(pokemon: pokemons[index]),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
