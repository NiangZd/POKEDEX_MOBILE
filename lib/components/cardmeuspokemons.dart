import 'package:flutter/material.dart';
import '../class/Pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../class/cores.dart';

class CardPokemon extends StatelessWidget {
  
  final Pokemon pokemon; 

  const CardPokemon({super.key, required this.pokemon});

  Color pegarCor(String tipo, {bool escura = false}) {
    switch (tipo) {
      case 'Fighting':
        return escura ? Cores.lutador_dark : Cores.lutador;
      case 'Psychic':
        return escura ? Cores.psiquico_dark : Cores.psiquico;
      case 'Poison':
        return escura ? Cores.venenoso_dark : Cores.venenoso;
      case 'Dragon':
        return escura ? Cores.dragao_dark : Cores.dragao;
      case 'Ghost':
        return escura ? Cores.fantasma_dark : Cores.fantasma;
      case 'Dark':
        return escura ? Cores.escuridao_dark : Cores.escuridao;
      case 'Ground':
        return escura ? Cores.terrestre_dark : Cores.terrestre;
      case 'Fire':
        return escura ? Cores.fogo_dark : Cores.fogo;
      case 'Fairy':
        return escura ? Cores.fada_dark : Cores.fada;
      case 'Water':
        return escura ? Cores.agua_dark : Cores.agua;
      case 'Flying':
        return escura ? Cores.voador_dark : Cores.voador;
      case 'Normal':
        return escura ? Cores.normal_dark : Cores.normal;
      case 'Rock':
        return escura ? Cores.pedra_dark : Cores.pedra;
      case 'Electric':
        return escura ? Cores.eletrico_dark : Cores.eletrico;
      case 'Bug':
        return escura ? Cores.besouro_dark : Cores.besouro;
      case 'Grass':
        return escura ? Cores.grama_dark : Cores.grama;
      case 'Ice':
        return escura ? Cores.gelo_dark : Cores.gelo;
      case 'Steel':
        return escura ? Cores.ferro_dark : Cores.ferro;
      default:
        return Cores.defaultColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;

    if (pokemon.tipo.length == 1) {
      Color tipoCor = pegarCor(pokemon.tipo[0]);
      gradientColors = [tipoCor, tipoCor]; 
    } else if (pokemon.tipo.length >= 2) {
      Color primeiraCor = pegarCor(pokemon.tipo[0]);
      Color segundaCor = pegarCor(pokemon.tipo[1]);
      gradientColors = [primeiraCor, segundaCor];
    } else {
      gradientColors = [Cores.defaultColor, Cores.defaultColor];
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(40.0), 
          bottomLeft: Radius.circular(40.0), 
          bottomRight: Radius.circular(10.0),
        ),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.3, 0.9], 
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context, 
            '/detalhes-meu-pokemon',
            arguments: pokemon
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: pokemon.pegarImagem(),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pokemon.nome['english']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: pokemon.tipo.map((tipo) {
                      return Chip(
                        label: Text(tipo),
                        backgroundColor: pegarCor(tipo, escura: true), 
                        labelStyle: const TextStyle(color: Colors.white),
                        elevation: 4, 
                        shadowColor: Colors.black.withOpacity(0.3),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'HP: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${pokemon.atributos['HP']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ATAQUE: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${pokemon.atributos['Attack']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'DEFESA: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${pokemon.atributos['Defense']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
