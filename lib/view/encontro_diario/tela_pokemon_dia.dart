import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../class/Pokemon.dart';
import '../../db/database_helper.dart';
import 'def_pokemon_dia.dart';
import '../../class/cores.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExibicaoPokDia extends StatefulWidget {
  const ExibicaoPokDia({super.key});

  @override
  State<ExibicaoPokDia> createState() => _ExibicaoPokDiaState();
}

class _ExibicaoPokDiaState extends State<ExibicaoPokDia> {
  // VARIÁVEL DE CONTROLE PARA VERIFICAR SE JÁ FOI CAPTURADO
  bool verifCapturado = false;

  // GUARDAR O POKEMON DO DIA PRA QUANDO FOR USAR
  Pokemon? _pokemonDoDia;

  // VOU INICIAR O ESTADO CARREGANDO OU GERANDO UM POKEMON, A DEPENDER DO QUE FOR NECESSÁRIO
  @override
  void initState() {
    super.initState();
    _carregarOuGerarPokemonDoDia();
  }

  // FUNÇÃO QUE VAI CARREGAR O POKEMON DO DIA, CASO ELE JA TENHA SIDO DEFINIDO
  Future<void> _carregarOuGerarPokemonDoDia() async {
    // VOU RECEBER UM POKEMON DO DIA DA FUNÇÃO DE CARREGAR POKEMON DO DIA, SE O POKEMON DO DIA FOR NULL, VOU GERAR UM POKEMON PARA AQUELE DIA
    _pokemonDoDia = await _carregarPokemonDoDia();
    if (_pokemonDoDia == null) {
      _pokemonDoDia = await _gerarPokemonDoDia();
    }

    // AQUI VOU DEFINIR SE O POKEMON FOI CAPTURADO OU NÃO
    verifCapturado = await pokemonCapturadoHoje();
    // E SETAR O ESTADO DAS VARIÁVEIS AO FINAL
    setState(() {});
  }

  // CARREGAR O POKEMON DO DIA, SE EXISTIR
  Future<Pokemon?> _carregarPokemonDoDia() async {
    return await DatabaseHelper().getPokemonDoDia();
  }

  // GERAR UM NOVO POKEMON DO DIA E SALVAR NO BANCO DE DADOS
  Future<Pokemon?> _gerarPokemonDoDia() async {
    DefPokemonDia defPokemonDia = DefPokemonDia();
    Pokemon? pokemon = await defPokemonDia.buscarPokemonAleatorio();
    if (pokemon != null) {
      await DatabaseHelper().savePokemonDoDia(pokemon);
    }
    return pokemon;
  }

  // FUNÇÃO PARA FAZER A CAPTURA DO POKEMON
  Future<bool> capturarPokemon(Pokemon pokemon) async {
    // ASSIM QUE O POKEMON FOR CAPTURADO E INSERIDO NO BANCO, EU CHAMO A FUNÇÃO DO MARCARCAPTURA PRA SALVAR QUE JÁ FOI CAPTURADO HOJE
    bool capturado = await DatabaseHelper().insertMeusPokemons(pokemon);
    if (capturado) {
      await marcarCaptura();
      setState(() {
        verifCapturado = true;
      });
    }
    return capturado;
  }

  // MARCAR O POKEMON COMO CAPTURADO NO DIA
  Future<void> marcarCaptura() async {
    // AQUI EU SALVO NAS PREFERENCIAS A DATA QUE FOI CAPTURADO, PRA PODER COMPARAR SE POKEMON FOI CAPTURADO OU NÃO
    final prefs = await SharedPreferences.getInstance();
    String dataAtual = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString('dataCapturaPokemon', dataAtual);
  }

  // VERIFICAR SE O POKEMON JÁ FOI CAPTURADO HOJE
  Future<bool> pokemonCapturadoHoje() async {
    // USANDO AS PREFERÊNCIAS EU VERIFICO SE A CAPTURADATA É IGUAL A DATA ATUAL, SE FOR IGUAL, SIGNIFICA QUE JÁ FOI CAPTURADO HOJE, ENTÃO NÃO PODE MAIS CAPTURAR
    final prefs = await SharedPreferences.getInstance();
    String? capturaData = prefs.getString('dataCapturaPokemon');
    String dataAtual = DateTime.now().toIso8601String().split('T')[0];
    return capturaData == dataAtual;
  }

  // FUNÇÃO PARA PEGAR A COR BASEADA NO TIPO DO POKEMON
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
  @override
  Widget build(BuildContext context) {
    if (_pokemonDoDia == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Color> coresGradient = _pokemonDoDia!.tipo.map((tipo) => pegarCor(tipo)).toList();

    if (coresGradient.length == 1) {
      coresGradient.add(coresGradient.first);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pegarCor(_pokemonDoDia!.tipo.first),
        title: Text(
          'POKEMON DO DIA: ${_pokemonDoDia!.nome['english']}',
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
            Container(
              margin: const EdgeInsets.all(16),
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
                        imageUrl: _pokemonDoDia!.pegarImagemGrande(),
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
                                _pokemonDoDia!.nome['english'] ?? 'Pokémon',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _pokemonDoDia!.tipo.map((tipo) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: pegarCor(tipo),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tipo,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: verifCapturado
                                      ? Colors.grey
                                      : pegarCor(_pokemonDoDia!.tipo.first),
                                ),
                                onPressed: verifCapturado
                                    ? null
                                    : () async {
                                        bool capturado = await capturarPokemon(_pokemonDoDia!);
                                        if (capturado) {
                                          setState(() {
                                            verifCapturado = true;
                                          });
                                        }
                                      },
                                child: Text(
                                  verifCapturado ? 'Pokémon já capturado' : 'Capturar Pokémon',
                                  style: const TextStyle(color: Colors.white),
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
          ],
        ),
      ),
    );
  }
}
