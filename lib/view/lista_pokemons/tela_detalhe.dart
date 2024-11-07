import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../class/Pokemon.dart';
import '../../class/cores.dart';

class TelaDetalhe extends StatelessWidget {
  const TelaDetalhe({super.key});

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
    final Pokemon pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;

    List<Color> coresGradient = pokemon.tipo.map((tipo) {
      return pegarCor(tipo);
    }).toList();

    if (coresGradient.length == 1) {
      coresGradient.add(coresGradient.first);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pegarCor(pokemon.tipo.first),
        title: Text(
          '${pokemon.nome['english']}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://w0.peakpx.com/wallpaper/757/308/HD-wallpaper-pikachu-art-pokemon-black-dark-illustration-anime-pokemon-species-thumbnail.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: coresGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: pokemon.pegarImagemGrande(),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: coresGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // AQUI É SÓ VERIFICAÇÃO PRA ERRO, VAI TENTAR COLOCAR O NOME DO POKEMON, SE DER ERRADO COLOCA POKEMON APENAS
                                  pokemon.nome['english'] ?? 'Pokémon',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...pokemon.tipo.map((tipo) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: pegarCor(tipo, escura: true),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          tipo,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2), 
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'HP: ${pokemon.atributos['HP']} | ATAQUE: ${pokemon.atributos['Attack']} | DEFESA: ${pokemon.atributos['Defense']} | VELOCIDADE: ${pokemon.atributos['Speed']}',
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'SP. ATAQUE: ${pokemon.atributos['Sp. Attack']} | SP. DEFESA: ${pokemon.atributos['Sp. Defense']}',
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}