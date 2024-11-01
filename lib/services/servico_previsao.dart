import 'dart:convert';

import 'package:app_wheater/models/previsao_tempo.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ServicoPrevisao {
  static const URL = 'https://api.openweathermap.org/data/2.5/weather';
  static const API_KEY = 'b7ccd6900ec20af015dc3beeb6220ace';

  Future<PrevisaoTempo> getPrevisao(String nomeCidade) async {
    final resposta = await http
        .get(Uri.parse('$URL?q=$nomeCidade&appid=$API_KEY&units=metric&lang=pt_br'));

    if(resposta.statusCode == 200) {
      print('Dados: ${resposta.body}');
      return PrevisaoTempo.fromJson(jsonDecode(resposta.body));
    } else {
      throw Exception('Não foi possivel encontrar os dados da previsão');
    }
  }

  Future<String> buscarCidadeAtual() async {
    LocationPermission permicao = await Geolocator.checkPermission();
    if(permicao == LocationPermission.denied) {
      permicao = await Geolocator.requestPermission();
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemarks =
          await placemarkFromCoordinates(posicao.latitude, posicao.longitude);
    print('Place: $placemarks');
    String? cidade = placemarks[0].subAdministrativeArea;
    print('Cidade atual: $cidade');
    return cidade ?? 'Cidade não encontrada';
  }
}