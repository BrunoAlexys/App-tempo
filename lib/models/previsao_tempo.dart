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


  static Future<PrevisaoTempo> fromJson(Map<String, dynamic> json) async {
    final String nomeCidade = json['name'] ?? 'Cidade desconhecida';
    final double temperatura = json['main']?['temp']?.toDouble() ?? 0.0;
    final String condicaoClimatica = json['weather']?[0]['main'] ?? 'Desconhecido';

    // Validando o campo `dt` para o dia da semana
    final int? timestamp = json['dt'];
    print('DT-API: $timestamp');
    final String diaSemana;
    if (timestamp != null) {
      await initializeDateFormatting('pt_BR', '');
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      diaSemana = DateFormat.EEEE('pt_BR').format(date);
      print('Dia da semana: $diaSemana');
    } else {
      diaSemana = 'Data desconhecida';
    }

    return PrevisaoTempo(
      nomeCidade: nomeCidade,
      temperatura: temperatura,
      condicaoClimatica: condicaoClimatica,
      diaSemana: diaSemana,
    );
  }
}
