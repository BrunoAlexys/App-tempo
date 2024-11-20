import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PrevisaoTempo {
  final String nomeCidade;
  final double temperatura;
  final String condicaoClimatica;
  final String diaSemana;

  PrevisaoTempo({
    required this.nomeCidade,
    required this.temperatura,
    required this.condicaoClimatica,
    required this.diaSemana
  });


  static Future<List<PrevisaoTempo>> fromJson(Map<String, dynamic> json) async {
    final String nomeCidade = json['city']['name'] ?? 'Cidade desconhecida';
    List<PrevisaoTempo> previsoes = [];
    var previsaoSemana = json['list'];

    for(var i = 0; i < previsaoSemana.length; i++){
      var main = previsaoSemana[i]['main'];
      var condicaoClimaticaList = previsaoSemana[i]['weather'];
      var condicaoClimatica = (condicaoClimaticaList is List && condicaoClimaticaList.isNotEmpty)
          ? condicaoClimaticaList[0]['main'] ?? 'Condição desconhecida'
          : 'Condição desconhecida';
      double temperatura = (main['temp'] is String)
      ? double.parse(main['temp'])
          : (main['temp'] as num).toDouble();
      var previsao = PrevisaoTempo(
          nomeCidade: nomeCidade,
          temperatura: temperatura,
          condicaoClimatica: condicaoClimatica,
          diaSemana: await getDiaSemana(previsaoSemana[i]['dt'])
      );

      previsoes.add(previsao);
      print(
          'Cidade: ${previsao.nomeCidade} - Dia: ${previsao.diaSemana} - Temperatura: ${previsao.temperatura} - Condição: ${previsao.condicaoClimatica}'
      );
    }

    return previsoes;
  }

  static Future<String> getDiaSemana(int? timestamp) async {
    final String diaSemana;
    if (timestamp != null) {
      await initializeDateFormatting('pt_BR', '');
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      diaSemana = toBeginningOfSentenceCase(DateFormat('EEE', 'pt_BR').format(date))!;
    } else {
      diaSemana = 'Data desconhecida';
    }
    return diaSemana;
  }
}
