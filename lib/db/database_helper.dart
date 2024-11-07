import 'package:sqflite/sqflite.dart';
import '../class/Pokemon.dart';

// ESSA CLASSE VAI SER MINHA CLASSE AUXILIAR PARA GUARDAR INFORMAÇÕES EM CACHE, EU TINHA TENTADO FAZER COM AS CLASSES DAO, MAS TAVA DANDO UM PROBLEMA, MUITO MAIS PELOS TIPOS DAS VARIÁVEIS PARA ARMAZENAR, JÁ QUE PEGAVA DIRETAMENTE DA CLASSE, AQUI EU FIZ UMA COISA PRA PEGAR AS INFORMAÇÕES POR MÉTODOS QUE VAI SER MOSTRADO MAIS A FRENTE
class DatabaseHelper {

  // ESSA VARIÁVEL CRIA UMA INSTÂNCIA DA PRÓPRIA CLASSE DO DATABASE
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  // ESSA VARIÁVEL SERVE PARA, QUANDO EU FOR CHAMAR UMA INSTÂNCIA DESSA CLASSE, SEMPRE CHAMAR A QUE JÁ TA CRIADA, INVÉS DE CRIAR OUTRA INSTÂNCIA
  factory DatabaseHelper() => _instance;

  // AQUI É ONDE FICA ARMAZENADA A PRÓPRIA INSTÂNCIA DO BANCO PARA CHAMAR
  static Database? _database;

  // AQUI É O CONSTRUTOR PRIVADO QUE VAI PRIVAR A CRIAÇÃO DE OUTRA INSTÂNCIA FORA DAQUI, PRA IMPEDIR CRIAÇÕES DE VÁRIAS INSTÂNCIAS DO MESMO BANCO SEM NECESSIDADE
  DatabaseHelper._internal();

  // ESSE MÉTODO FAZ UM GET DO DATABASE, JÁ QUE É PRIVADO, PRIMEIRO É FEITA UMA VERIFICAÇÃO SE O DATABASE JÁ FOI INICIALIZADO, SE É NULL OU NÃO, SE ELE JÁ FOI INICIADO ELE RETORNA O DATABASE, SE NÃO TIVER SIDO INICIALIZADO, ELE CHAMA O MÉTODO QUE FAZ ISSO
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // AQUI É O MÉTODO PARA INICIAR O BANCO DE DADOS, CASO NÃO TENHA SIDO INICIADO AINDA
  Future<Database> _initDB() async {
    return await openDatabase(
      // ELE É ABERTO NA MEMÓRIA INTERNA DO DISPOSITIVO 
      ':memory:',
      version: 1,
      // MÉTODO PARA A  CRIAÇÃO DA TABELA DOS POKEMONS
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE pokemons(
            id INTEGER PRIMARY KEY,
            nome TEXT,
            tipo TEXT,
            atributos TEXT,
            pagina INTEGER
          )''' );

          //CRIAÇÃO DA TABELA DO POKEMON DIÁRIO PARA GUARDAR EM CACHE
          await db.execute('''CREATE TABLE pokemon_do_dia(
              id INTEGER PRIMARY KEY,
              nome TEXT,
              tipo TEXT,
              atributos TEXT,
              data TEXT
            )
          ''');

          // TABELA PARA DEFINIR MEUS POKEMONS
         await db.execute('''CREATE TABLE meus_pokemons(
              meus_id INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER,
              nome TEXT,
              tipo TEXT,
              atributos TEXT
          )''');
      },
    );
  }

  // MÉTODO PARA INSERIR OS POKEMONS NO BANCO
  Future<void> insertPokemon(Pokemon pokemon, int pagina) async {
    
    // OBTÉM A INSTÂNCIA DO BANCO DE DADOS
    final db = await database;

    // VERIFICAÇÃO SE O POKEMON JÁ EXISTE NO BANCO DE DADOS PARA NÃO DUPLICAR
    final List<Map<String, dynamic>> existing = await db.query(
      'pokemons',
      where: 'id = ? AND pagina = ?',
      whereArgs: [pokemon.id, pagina],
    );

    // SE NÃO EXISTIR, FAZ O INSERT
    if (existing.isEmpty) {
      await db.insert(
        'pokemons',
        {...pokemon.toMap(), 'pagina': pagina},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // RETORNA OS POKEMONS BASEADOS NO RANGE DO ID, DO INÍCIO AO FIM QUE VEM DA CHAMADA DA FUNÇÃO
  Future<List<Pokemon>> getPokemonsByIdRange(int idInicio, int idFim) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pokemons',
      where: 'id >= ? AND id <= ?',
      whereArgs: [idInicio, idFim],
    );

    return List.generate(maps.length, (i) {
      return Pokemon.fromMap(maps[i]);
    });
  }

  //ESSA FUNÇÃO VAI INSERIR O POKEMON DO DIA, BASEADO NO DIA ATUAL
  Future<void> savePokemonDoDia(Pokemon pokemon) async {
    final db = await database;

    // AQUI EU SALVO O DIA DE HOJE, PARA A VERIFICAÇÃO FUNCIONAR QUANDO A FUNÇÃO FOR CHAMADA
    final String hoje = DateTime.now().toIso8601String().split('T')[0];

    // VERIFICO SE EXISTE UM POKEMON DO DIA REGISTRADO COM A DATA CORRETA, OU SEJA, HOJE
    final List<Map<String, dynamic>> pokemonDia = await db.query(
      'pokemon_do_dia',
      where: 'data = ?',
      whereArgs: [hoje],
    );

    // SE NÃO TIVER NENHUM POKEMON SALVO NO DIA, EU INSIRO O POKEMON NO CACHE, OU SEJA, NO BANCO DE DADOS, SALVANDO O OBJETO DE POKEMON E TAMBÉM A DATA PARA PODER FAZER O GET POSTERIORMENTE
    if (pokemonDia.isEmpty) {
      await db.insert(
        'pokemon_do_dia',
        {
          ...pokemon.toMap(),
          'data': hoje,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // AQUI É FUNÇÃO DE GET PARA PODER FAZER A EXIBIÇÃO DO POKEMON DIÁRIO
  Future<Pokemon?> getPokemonDoDia() async {
    final db = await database;

    // PEGAR A DATA ATUAL, IGUALMENTE FIZ NA PARTE DE SALVAR
    String hoje = DateTime.now().toIso8601String().split('T')[0];

    // FAZ A BUSCA DO POKEMON DO DIA, BASEADO NA DATA
    final List<Map<String, dynamic>> maps = await db.query(
      'pokemon_do_dia',
      where: 'data LIKE ?',
      whereArgs: ['$hoje%'],
    );

    // SE EXISTIR UM POKEMON NO DIA DE HOJE, RETORNA ELE PARA USO, SE NÃO, RETORNA NULL
    if (maps.isNotEmpty) {
      return Pokemon.fromMap(maps.first);
    }
    return null;
  }

  // MÉTODO PARA ADICIONAR UM POKEMON NA LISTA DOS MEUS POKEMONS
  Future<bool> insertMeusPokemons(Pokemon pokemon) async {
    // OBTÉM A INSTÂNCIA DO BANCO DE DADOS
    final db = await database;

    // VERIFICA O NÚMERO ATUAL DE POKEMONS NA TABELA
    final List<Map<String, dynamic>> qtpok = await db.query(
      'meus_pokemons',
      columns: ['COUNT(*) AS count'],
    );

    // OBTÉM O CONTADOR BASEADO NA CONTAGEM DA LISTA
    int contadorPok = qtpok.isNotEmpty ? qtpok.first['count'] as int : 0;

    // print("Quantidade atual de Pokémons: $currentCount");

    // SE A QUANTIDADE DE POKEMONS FOR MENOR QUE 6, FAZ O INSERT
    if (contadorPok < 6) {
      try {
        await db.insert(
          'meus_pokemons',
          pokemon.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        //print("Pokémon inserido com sucesso: ${pokemon.nome}");
        
        contadorPok += 1;
        //print("Quantidade total de Pokémons após inserção: $contadorPok");
        return true; 
      } catch (e) {
        //print("Falha ao inserir Pokémon: $e");
        return false;
      }
    } else {
      //print("Falha ao inserir Pokémon: limite de 6 Pokémons atingido.");
      return false;
    }
  }

  // MÉTODO PARA OBTER A LISTA DOS POKEMONS NA TABELA meus_pokemons
  Future<List<Pokemon>> getMeusPokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meus_pokemons');

    // print('Pokémons retornados do banco de dados: ${maps.length}');

    // GERA A LISTA DOS POKEMONS
    return List.generate(maps.length, (i) {
      // VERIFICAÇÕES ANTES DE RETORNAR
      if (maps[i]['id'] != null) {
        return Pokemon.fromMap(maps[i]);
      } else {
        throw Exception("Pokémon ID é nulo no índice $i");
      }
    });
  }


  // MÉTODO PARA LIBERAR O POKEMON
  Future<void> liberarPokemon(int pokemonId) async {
    final db = await database;

    // AQUI EU FIZ UMA BUSCA DOS POKEMONS NA LISTA, LIMITANDO SOMENTE A 1, JÁ QUE OS IDS SÃO TODOS IGUAIS, ENTÃO EU PRECISO PEGAR OS POKEMONS E LIMITAR, PARA NÃO LIBERAR TODOS PELO MESMO ID
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT meus_id FROM meus_pokemons WHERE id = ? LIMIT 1',
      [pokemonId],
    );

    // SE ALGUM POKEMON FOR ENCONTRADO, VAI GUARDAR O ID ESPECÍFICO DELE, COMO FOI DEFINIDO NA TABELA
    if (result.isNotEmpty) {
      final meusId = result.first['meus_id'];

      // AGORA SIM DELETA PELO ID ESPECÍFICO, GARANTINDO QUE OS OUTROS DO MESMO TIPO PERMANEÇAM
      await db.delete(
        'meus_pokemons',
        where: 'meus_id = ?',
        whereArgs: [meusId],
      );
    }
  }
}
