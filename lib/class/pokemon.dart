import 'dart:convert';

class Pokemon {
  // DECLARANDO OS ATRIBUTOS DA CLASSE
  
  final int id;
  final Map<String, String> nome;
  final List<String> tipo;
  final Map<String, dynamic> atributos;

  // CONSTRUTOR CRIADO COM REQUIRED PARA GARANTIR QUE TODOS OS PARÂMETROS SEJAM INICIALIZADOS
  Pokemon({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.atributos,
  });

  // CRIEI ESSE MÉTODO DEPOIS, PQ PERCEBI QUE AS URL DAS IMAGENS SÃO TODAS IGUAIS, ENTÃO DAVA PRA CRIAR UM MÉTODO PRA PEGAR VIA URL E ID (OS IDS DAS IMAGENS CORRESPONDEM AO POKEMON PELO ID)
  String pegarImagem(){
    String idcomzeros = id.toString().padLeft(3, '0');
    return 'https://raw.githubusercontent.com/fanzeyi/pokemon.json/refs/heads/master/sprites/${idcomzeros}MS.png';
  }

  String pegarImagemGrande(){
    String idcomzeros = id.toString().padLeft(3, '0');
    return 'https://raw.githubusercontent.com/fanzeyi/pokemon.json/refs/heads/master/images/${idcomzeros}.png';
  }

  // O MÉTODO DO FROMJSON SERVE PARA CRIAR A INSTÂNCIA DO POKÉMON A PARTIR DO MAPA PASSADO ALI NO PARÂMETRO, QUE VAI CONTER OS DADOS DOS POKEMONS PARA QUE POSSAM SER ATRIBUÍDOS AOS ATRIBUTOS DA CLASSE
  factory Pokemon.fromJson(Map<String, dynamic> json){
    return Pokemon(
      id: int.parse(json['id']),
      nome: Map<String, String>.from(json['name']),
      tipo: List<String>.from(json['type']),
      atributos: Map<String, dynamic>.from(json['base'])
    );
  }

  //ESSE MÉTODO MAP EU CRIEI PARA PODER ARMAZENAR OS DADOS NO FORMATO CORRETO NO BANCO DE DADOS
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': json.encode(nome), // Armazenar como JSON
      'tipo': json.encode(tipo), // Armazenar como JSON
      'atributos': json.encode(atributos), // Armazenar como JSON
    };
  }

  //TRANSFORMA DE VOLTA PARA UM OBJETO
  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      nome: Map<String, String>.from(json.decode(map['nome'])),
      tipo: List<String>.from(json.decode(map['tipo'])),
      atributos: Map<String, dynamic>.from(json.decode(map['atributos'])),
    );
  }

}