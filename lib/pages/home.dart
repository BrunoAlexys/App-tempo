import 'package:app_wheater/components/InputBusca.dart';
import 'package:app_wheater/models/previsao_tempo.dart';
import 'package:app_wheater/services/servico_previsao.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final _servicoPrevisao = ServicoPrevisao();
  PrevisaoTempo? _previsaoTempo;
  final TextEditingController _controladorDeBusca = TextEditingController();
  String? nomeCidadeApi;
  bool ehNoite = false;

  _inicial() async {
    try {
      String cidadeAtual = await _servicoPrevisao.buscarCidadeAtual();
      final previsao = await _servicoPrevisao.getPrevisao(cidadeAtual);

      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = previsao.nomeCidade;
        _atualizarEhNoite();
      });
      _controladorDeBusca.text = cidadeAtual;
    } catch (e) {
      print('Erro ao buscar a cidade atual: $e');
    }
  }
  _atualizarEhNoite() {
    int horaAtual = DateTime.now().hour;
    ehNoite = horaAtual >= 18 || horaAtual < 6;
  }

  _buscarPrevisaoTempo(String cidade) async {
    try {
      final previsao = await _servicoPrevisao.getPrevisao(cidade);
      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = previsao.nomeCidade;
        _atualizarEhNoite();
      });
    } catch (e) {
      print('Erro ao buscar a cidade pelo nome: $e');
    }
  }

  String escolherAnimacao(String? condicaoClimatica) {
    _atualizarEhNoite();


    if (condicaoClimatica == null) {
      return ehNoite ? 'assets/noite.json' : 'assets/sol.json';
    }
    switch (condicaoClimatica.toLowerCase()) {
      case 'clouds':
        return ehNoite ? 'assets/nublado-noite.json' : 'assets/nuvem.json';
      case 'mist':
        return ehNoite ? 'assets/neblina-noite.json': 'assets/neblina.json';
      case 'smoke':
        return ehNoite ? 'assets/neblina-noite.json': 'assets/neblina.json';
      case 'haze':
        return  ehNoite ? 'assets/neblina-noite.json': 'assets/neblina.json';
      case 'fog':
        return ehNoite ? 'assets/neblina-noite.json': 'assets/neblina.json';
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
  void initState() {
    super.initState();
    _inicial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ehNoite ?  Color(0xFF181717) : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 60.0),
              child: InputBusca(
                controlador: _controladorDeBusca,
                cidadeSelecionada: _buscarPrevisaoTempo,
                nomeCidade: nomeCidadeApi,
              ),
            ),
            Container(
              child: Lottie.asset(
                  escolherAnimacao('${_previsaoTempo?.condicaoClimatica}')),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${_previsaoTempo?.temperatura.toStringAsFixed(0)}°',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: ehNoite ? Colors.white : Color(0xFF181717)
                      ),
                    ),
                    Text(
                      '${_previsaoTempo?.diaSemana}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ehNoite ? Colors.white : Color(0xFF181717)
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
