/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../class/Pokemon.dart';

class CardPokemon extends StatefulWidget {
  const CardPokemon({super.key});

  @override
  State<CardPokemon> createState() => _CardPokemonState();
}

class _CardPokemonState extends State<CardPokemon> {
  // VARIÁVEL QUE VAI GUARDAR O POKEMON NA CHAMADA ASSÍNCRONA QUE VAI BUSCAR OS DADOS DO POKEMON
  late Future<Pokemon> futurePokemon;

  // É O INITSTATE QUE APRENDEMOS EM SALA, BASICAMENTE AQUI ELE TA TENDO A FUNÇÃO DE INICIAR O ESTADO DO WIDGET JÁ BUSCANDO O POKEMON PELA FUNÇÃO "BUSCARPOKEMON"
  @override
  void initState() {
    super.initState();
    futurePokemon = buscarPokemon();
  }

  //ESSA FUNÇÃO É A MENCIONADA ACIMA, A QUAL FAZ A BUSCA PELO POKEMON
  Future<Pokemon> buscarPokemon() async {
    try {
      //PRIMEIRO FAZ A REQUISIÇÃO COM GET NA URL DA API LOCAL (POR ENQUANTO, POIS VOU TENTAR HOSPEDAR EM UM SEVIÇO QUE DÊ ACESSO)
      final res = await http.get(Uri.parse('https://0fad-187-19-163-43.ngrok-free.app/pokemons'));
      //SE DER ALGUM ERRO DE RESPOSTA DE STATUS, ELE VAI DAR ERRO NO IF
      if (res.statusCode != HttpStatus.ok) {
        throw 'ERRO DE CONEXÃO';
      } else {
        //SE NÃO DER ERRO ALGUM, ELE VAI CRIAR UMA LISTA DO TIPO DYNAMIC PARA RECEBER O CORPO DA RESPOSTA DA REQUISIÇÃO NO FORMATO CORRETO
        final List<dynamic> listaPok = json.decode(res.body);
        return Pokemon.fromJson(listaPok[0]);
      }
    } catch (e) {
      // SOLTA ERRO CASO O TRY DA CONEXÃO FALHE
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
        //ESSE WIDGET BASICAMENTE FUNCIONA PARA CONSTRUIR A INTERFACE USANDO AS FUNÇÕES ASSÍNCRONAS DE FORMA MAIS FÁCIL, NESSE CASO, ELE TA LIDANDO COM A FUTUREPOKEMON, A PARTIR DELA, O FUTUREBUILDER VAI OBSERVAR E DETERMINAR COMO CONSTRUIR/RENDERIZAR O RESTANTE DAS COISAS
    return FutureBuilder(
      //AQUI É LITERALMENTE O QUE EU DISSE ACIMA, A FUTURE QUE O WIDGET FUTUREBUILDER VAI OBSERVAR
      future: futurePokemon,
      //BUILDER VAI CONSTRUIR A APLICAÇÃO SEMPRE QUE A FUTURE MUDAR, E ESSE SNAPSHOT AÍ TEM AS INFORMAÇÕES ATUAIS DA FUTURE, INCLUSIVE, POR ISSO QUE É USADO ESSE PARÂMETRO NOS IF'S PARA DECIDIR COMO A CONSTRUÇÃO DEVE SE COMPORTAR
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('ERRO: ${snapshot.error}'));
        } else {
          // BASICAMENTE É UMA PASSAGEM DE DADOS, OU SEJA, A VARIÁVEL POKEMON VAI RECEBER O "DATA" QUE SÃO OS DADOS, DA VARIÁVEL SNAPSHOT
          final pokemon = snapshot.data!;
          return TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            onPressed: null,
            child: Row(
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHT_6V7i5-f6NYvjVSjGCbGitfE2bLxFHzZg&s',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      'NOME: ${pokemon.nome['english']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'TIPO(s): ${pokemon.tipo.join(', ')}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      'HP: ${pokemon.atributos['HP']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'ATAQUE: ${pokemon.atributos['Attack']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'DEFESA: ${pokemon.atributos['Defense']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      'SP. ATAQUE: ${pokemon.atributos['Sp. Attack']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'SP: DEFESA: ${pokemon.atributos['Sp. Defense']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'VELOCIDADE: ${pokemon.atributos['Speed']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
*/

// O CÓDIGO ACIMA ERA USADO APENAS PARA TESTAR COMO RECEBER OS POKEMONS DE FORMA INDIVIDUAL

import 'package:flutter/material.dart';
import '../class/Pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../class/cores.dart';

class CardPokemon extends StatelessWidget {
  
  final Pokemon pokemon; 

  const CardPokemon({super.key, required this.pokemon});

  // FIZ ESSA FUNÇÃO PRA BRINCAR UM POUCO COM AS CORES DOS CARDS
  // ESSA FUNÇÃO EU ALTEREI PRA CONSEGUIR COLOCAR UMA FLAG, SE ESCURA TIVER ATIVO, AÍ ELE PEGA A COR DARK, SE NÃO, PEGA A COR NORMAL, PRA EU PODER DIFERENCIAR NA HORA DE INSERIR
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

    // AQUI EU VERIFICO QUANTOS TIPOS TEM O POKEMON E PEGO QUANTAS CORES SÃO NECESSÁRIAS
    if (pokemon.tipo.length == 1) {
      // SE FOR 1 TIPO SÓ, VOU ADICIONAR A MESMA COR NO GRADIENTE, OU SEJA, A MESMA COR PRO GRADIENTE
      Color tipoCor = pegarCor(pokemon.tipo[0]);
      gradientColors = [tipoCor, tipoCor]; 
    } else if (pokemon.tipo.length >= 2) {
      // MESMA COISA AQUI
      Color primeiraCor = pegarCor(pokemon.tipo[0]);
      Color segundaCor = pegarCor(pokemon.tipo[1]);
      gradientColors = [primeiraCor, segundaCor];
    } else {
      // DEFINI ESSA COR PADRÃO CASO EU TENHA ESQUECIDO ALGUM TIPO NA MINHA LISTAGEM...
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
            '/detalhes-pokemon',
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
                  // ESSE WRAP ORGANIZA SEUS FILHOS DE FORMA QUE FIQUEM FLEXÍVEIS A MUDANÇA
                  Wrap(
                    spacing: 8,
                    children: pokemon.tipo.map((tipo) {
                      // ESSE CHIP ORGANIZA PEQUENAS INFORMAÇÕES, AQUI EU DEI UMA PESQUISADA BRABA PRA APRENDER A FAZER
                      return Chip(
                        label: Text(tipo),
                        // AQUI É ONDE PEGO A COR ESCURA
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
