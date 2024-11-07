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


  factory PrevisaoTempo.fromJson(Map<String, dynamic> json) {
    // Garantindo que os campos não sejam nulos
    final String nomeCidade = json['name'] ?? 'Cidade desconhecida';
    final double temperatura = json['main']?['temp']?.toDouble() ?? 0.0;
    final String condicaoClimatica = json['weather']?[0]['main'] ?? 'Desconhecido';

    // Validando o campo `dt` para o dia da semana
    final int? timestamp = json['dt'];
    final String diaSemana;
    if (timestamp != null) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      diaSemana = DateFormat.EEEE('pt_BR').format(date);
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
