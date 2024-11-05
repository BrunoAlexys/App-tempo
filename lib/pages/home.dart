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

  _inicial() async {
    try {
      String cidadeAtual = await _servicoPrevisao.buscarCidadeAtual();
      final previsao = await _servicoPrevisao.getPrevisao(cidadeAtual);

      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = previsao.nomeCidade;
      });
      _controladorDeBusca.text = cidadeAtual;
    } catch (e) {
      print('Erro ao buscar a cidade atual: $e');
    }
  }

  _buscarPrevisaoTempo(String cidade) async {
    try {
      final previsao = await _servicoPrevisao.getPrevisao(cidade);
      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = previsao.nomeCidade;
      });
    } catch (e) {
      print('Erro ao buscar a cidade pelo nome: $e');
    }
  }

  String escolherAnimacao(String? condicaoClimatica) {
    if (condicaoClimatica == null) return 'assets/sol.json'; // Default
    print('Cindição Climatica: $condicaoClimatica');
    switch (condicaoClimatica.toLowerCase()) {
      case 'clouds':
        return 'assets/nuvem.json';
      case 'mist':
        return 'assets/neblina.json';
      case 'smoke':
        return 'assets/neblina.json';
      case 'haze':
        return 'assets/neblina.json';
      case 'fog':
        return 'assets/neblina.json';
      case 'rain':
        return 'assets/chuva.json';
      case 'drizzle':
        return 'assets/chuva.json';
      case 'shower rain':
        return 'assets/chuva.json';
      case 'thunderstorm':
        return 'assets/tempestade.json';
      case 'clear':
        return 'assets/sol.json';
      default:
        return 'assets/sol.json';
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
      body: Column(
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
            child: Column(
              children: [
                Lottie.asset(escolherAnimacao('${_previsaoTempo?.condicaoClimatica}')),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_previsaoTempo?.temperatura.toStringAsFixed(0)}°',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('Dom', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
