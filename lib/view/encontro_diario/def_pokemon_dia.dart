import 'dart:io';
import 'dart:math';
import 'dart:convert';
import '../../class/Pokemon.dart';
import 'package:http/http.dart' as http;
import '../../db/database_helper.dart';

class DefPokemonDia {
  //AQUI EU SÓ DEFINI AS VARIÁVEIS QUE IRIA USAR PARA MANIPULAR A FUNÇÃO DE DEFINIR
  late Random numAl;
  late String url;

  //APENAS INICIEI A VARIÁVEL RECEBENDO O RANDOM
  DefPokemonDia() {
    numAl = Random();
  }

  Future<Pokemon?> buscarPokemonAleatorio() async {
    //GEREI UM NÚMERO ENTRE 0 E 808, SOMANDO +1, JÁ Q N TEM POKEMON COM ID 0
    int idDoDia = numAl.nextInt(809) + 1;
    //PASSANDO A URL COM O ID ALEATÓRIO DE QUALQUER POKEMON
    url = 'https://e8ab-177-20-136-182.ngrok-free.app/pokemons/$idDoDia';

    try {
      //AQUI É SOMENTE A CHAMADA DA API COM A URL
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == HttpStatus.ok) {
        //SE DER TUDO OK, MESMO ESQUEMA DE SEMPRE, PEGA OS DADOS DA RESPOSTA DA REQUISIÇÃO, MAPEIA E DEPOIS INSTANCIA UM OBJETO DO TIPO POKEMON COM OS DADOS RECEBIDOS
        final Map<String, dynamic> data = json.decode(res.body);
        Pokemon pokemon = Pokemon.fromJson(data);
        
        // CHAMA O MÉTODO DE SALVAR O POKEMON QUE DEFINI LÁ NO DATABASE
        await DatabaseHelper().savePokemonDoDia(pokemon);
        return pokemon;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
