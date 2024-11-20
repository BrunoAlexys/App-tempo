import 'package:app_wheater/models/previsao_tempo.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CardPrevisoes extends StatelessWidget {
  final List<PrevisaoTempo> previsoes;
  final bool ehNoite;

  const CardPrevisoes({
    Key? key,
    required this.previsoes,
    required this.ehNoite,
  }) : super(key: key);

  String escolherAnimacao(String? condicaoClimatica, bool ehNoite) {
    if (condicaoClimatica == null) {
      return ehNoite ? 'assets/noite.json' : 'assets/sol.json';
    }
    switch (condicaoClimatica.toLowerCase()) {
      case 'clouds':
        return ehNoite ? 'assets/nublado-noite.json' : 'assets/nuvem.json';
      case 'mist':
        return ehNoite ? 'assets/neblina-noite.json' : 'assets/neblina.json';
      case 'smoke':
        return ehNoite ? 'assets/neblina-noite.json' : 'assets/neblina.json';
      case 'haze':
        return ehNoite ? 'assets/neblina-noite.json' : 'assets/neblina.json';
      case 'fog':
        return ehNoite ? 'assets/neblina-noite.json' : 'assets/neblina.json';
      case 'rain':
        return ehNoite ? 'assets/chuva-noite.json' : 'assets/chuva.json';
      case 'drizzle':
        return ehNoite ? 'assets/chuva-noite.json' : 'assets/chuva.json';
      case 'shower rain':
        return ehNoite ? 'assets/chuva-noite.json' : 'assets/chuva.json';
      case 'thunderstorm':
        return ehNoite ? 'assets/trovao-noite.json' : 'assets/tempestade.json';
      case 'clear':
        return ehNoite ? 'assets/noite.json' : 'assets/sol.json';
      default:
        return ehNoite ? 'assets/noite.json' : 'assets/sol.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PrevisaoTempo> previsoesFiltradas = {};
    for (var previsao in previsoes) {
      if (!previsoesFiltradas.containsKey(previsao.diaSemana)) {
        previsoesFiltradas[previsao.diaSemana] = previsao;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: previsoesFiltradas.values.map((previsao) {
          return Column(
            children: [
              Lottie.asset(
                escolherAnimacao(previsao.condicaoClimatica, ehNoite),
                width: 40,
                height: 40,
              ),
              SizedBox(height: 2),
              Text(
                previsao.diaSemana,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
