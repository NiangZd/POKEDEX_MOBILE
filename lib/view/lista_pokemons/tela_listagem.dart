import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/cardpokemon.dart';
import '../../class/Pokemon.dart';
import '../../db/database_helper.dart';

class ListaPokemons extends StatefulWidget {
  const ListaPokemons({super.key});

  @override
  State<ListaPokemons> createState() => _ListaPokemonsState();
}

class _ListaPokemonsState extends State<ListaPokemons> {
  // AQUI EU BASICAMENTE DEFINI UM TOTAL DE POKEMONS POR PÁGINA, ACHEI MELHOR 10, PRINCIPALMENTE PARA FINS DE TESTE
  static const int pokemonsPorPagina = 10;
  // DEFINI O TOTAL DE POKEMONS DA LISTA, APESAR QUE DAVA PRA PEGAR O ÚLTIMO DA LISTA PELA API E USAR TAMBÉM, PORÉM, ACHEI MAIS PRÁTICO USAR ASSIM, PENSANDO EM MUDAR DEPOIS...
  static const int totalPokemons = 809;
  // INSTÂNCIA DO HELPER QUE CRIEI PARA PODER GUARDAR AS COISAS EM UM CACHE DE MEMÓRIA INTERNA
  final DatabaseHelper dbHelper = DatabaseHelper();
  int paginaAtual = 0;
  // LISTA DE POKEMONS PARA USAR POSTERIORMENTE..
  List<Pokemon> pokemons = [];
  // É UMA FLAG PRA VERIFICAR SE OS DADOS TÃO CARREGANDO OU NN
  bool carregado = false;
  // SCROLL CONTROLLER PRA DETECTAR O FIM DA LISTA E CONTROLAR O SCROLL DO USUÁRIO
  late ScrollController controller_scroll;
  // FLAG PARA FECHAR OS DIÁLOGOS EXCESSIVOS
  bool _isDialogShowing = false;

  // INICIA O ESTADO CARREGANDO OS POKEMONS JÁ DA PÁGINA ATUAL, QUE É A PRIMEIRA QUANDO INICIADO, al
  @override
  void initState() {
    super.initState();
    carregarPokemons(paginaAtual);
    controller_scroll = ScrollController()..addListener(funcScroll);
  }

  // AQUI O DISPOSE VAI LIBERAR O CONTROLLER PRA NÃO USAR APÓS O DESUSO DO WIDGET
  @override
  void dispose() {
    controller_scroll.removeListener(funcScroll);
    controller_scroll.dispose();
    super.dispose();
  }

  // DETECTA QUANDO O USUÁRIO ATINGE O FINAL DA LISTA E VERIFICA SE FOI CARREGADO OU NÃO AS COISAS, PARA DESSA FORMA CARREGAR A "PRÓXIMA PÁGINA" ENTRE ASPAS, JÁ QUE AS PÁGINAS SÃO APENAS PARA CONTROLE
  void funcScroll() {
    if (controller_scroll.position.pixels >= controller_scroll.position.maxScrollExtent - 100 && !carregado) {
      proximaPagina();
    }
  }

  // MÉTODO DO CARREGAMENTO DE POKEMONS (RECEBENDO A PÁGINA ATUAL)
  Future<bool> carregarPokemons(int pagina) async {
    // DEFINO CARREGADO COMO TRUE ASSIM QUE INICIO A FUNÇÃO
    setState(() {
      carregado = true;
    });

    // AQUI FAÇO APENAS UM CÁLCULO BÁSICO PRA SABER ONDE COMEÇA E ONDE TERMINA A LISTA BASEADA NA PÁGINA, DE 10 EM 10
    int idInicio = pagina * pokemonsPorPagina + 1;
    int idFim = idInicio + pokemonsPorPagina - 1;

    // PRIMEIRA TENTATIVA DO TRY É VER SE EXISTE POKEMONS EM CACHE COM O RANGE ESPECÍFICO QUE ESTOU TENTANDO ACESSAR, SE TIVER EM CACHE, EU TRAGO DO CACHE PARA AGILIZAR O PROCESSO DE EXIBIÇÃO
    try {
      final cachedPokemons = await dbHelper.getPokemonsByIdRange(idInicio, idFim);
      if (cachedPokemons.isNotEmpty) {
        setState(() {
          // AQUI EU INSIRO OS POKEMONS DO CACHE NA LISTA DE POKEMONS PRA EXIBIR, ISSO, SE EXISTIR NO CACHE
          pokemons.addAll(cachedPokemons);
        });
        return true;
      } else {
        // SE NÃO EXISTIR NO CACHE, EU CRIO UMA LISTA VAZIA PRA RECEBER OS NOVOS POKEMONS BASEADO NA BUSCA DA API E BASEADO NO RANGE, INICIO E FIM
        final List<Pokemon> novosPokemons = [];
        for (int id = idInicio; id <= idFim; id++) {
          final res = await http.get(Uri.parse('https://e8ab-177-20-136-182.ngrok-free.app/pokemons/$id'));

          // SE A RESPOSTA FOR OK, A LISTA DE POKEMONS NOVOS VAI RECEBER OS POKEMONS QUE VIEREM DA REQUISIÇÃO HTTP
          if (res.statusCode == HttpStatus.ok) {
            final pokemonJson = json.decode(res.body);
            novosPokemons.add(Pokemon.fromJson(pokemonJson));
          }
        }

        // SE DER TUDO CERTO E OS NOVOS POKEMONS NÃO ESTIVEREM VAZIOS, VOU ADICIONAR ELES NA LISTA DA EXIBIÇÃO
        if (novosPokemons.isNotEmpty) {
          setState(() {
            pokemons.addAll(novosPokemons);
          });
          // E TAMBÉM INSERIR NO CACHE PARA PREPARAR PRA PRÓXIMA EXIBIÇÃO E TAMBÉM FUNCIONAR OFFLINE
          for (var pokemon in novosPokemons) {
            await dbHelper.insertPokemon(pokemon, pagina);
          }
          return true;
        } else {
          _showErrorDialog("Nenhum Pokémon encontrado para esta página.");
          return false;
        }
      }
    } catch (e) {
      //_showErrorDialog("Não há mais Pokémon disponíveis, pois a conexão foi cortada.");
      return false;
    } finally {
      setState(() {
        carregado = false;
      });
    }
  }

  // FUNÇÃO QUE FAZ A PRÓXIMA PÁGINA APARECER AUTOMATICAMENTE AO FINAL DO SCROLL
  void proximaPagina() async {
    if ((paginaAtual + 1) * pokemonsPorPagina < totalPokemons) {
      bool carregado = await carregarPokemons(paginaAtual + 1);
      if (carregado) {
        setState(() {
          paginaAtual += 1;
        });
      } else {
        //_showErrorDialog("Não há mais Pokémon disponíveis.");
      }
    } else {
      //_showErrorDialog("Não há mais Pokémon disponíveis.");
    }
  }

  // EU PESQUISEI UM POUCO AQUI PARA CRIAR UM MÉTODO DE EXIBIÇÃO DO ALERTA PARA CADA ERRO, TANTO PRA DEIXAR BONITO NA EXIBIÇÃO QUANTO PRA ANALISAR O QUE TAVA DANDO ERRADO A CADA VEZ QUE EU EXECUTAVA
  void _showErrorDialog(String message) {
    if (!_isDialogShowing) {
      _isDialogShowing = true; // DEFINE A FLAG COMO TRUE ANTES DE EXIBIR O DIÁLOGO
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                _isDialogShowing = false; // DEFINE COMO FALSE QUANDO O DIÁLOGO É FECHADO
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LISTA DE POKÉMONS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 226, 0, 0),
      ),
      body: Center(
        child: carregado && pokemons.isEmpty
            ? const CircularProgressIndicator()
            : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://e0.pxfuel.com/wallpapers/409/392/desktop-wallpaper-pokemon-go-pokeball-black-iphone.jpg'
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: controller_scroll,
                      itemCount: pokemons.length + (carregado ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < pokemons.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CardPokemon(pokemon: pokemons[index]),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
