class PrevisaoTempo {
  final String nomeCidade;
  final double temperatura;
  final String condicaoClimatica;

  PrevisaoTempo({
    required this.nomeCidade,
    required this.temperatura,
    required this.condicaoClimatica
  });

  factory PrevisaoTempo.fromJson(Map<String, dynamic> json) {
    return PrevisaoTempo(
      nomeCidade: json['name'],
      temperatura: json['main']['temp'],
      condicaoClimatica: json['weather'][0]['main']
    );
  }
}