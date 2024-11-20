import 'package:app_wheater/components/InputBusca.dart';
import 'package:app_wheater/components/card_previsoes.dart';
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
  List<PrevisaoTempo>? _previsaoTempo;
  final TextEditingController _controladorDeBusca = TextEditingController();
  String? nomeCidadeApi;
  bool ehNoite = false;
  bool _carregando = true;

  _inicial() async {
    try {
      setState(() {
        _carregando = true;
      });
      String cidadeAtual = await _servicoPrevisao.buscarCidadeAtual();
      final previsao = await _servicoPrevisao.getPrevisao(cidadeAtual);

      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = cidadeAtual;
        atualizarEhNoite();
        _carregando = false;
      });
      _controladorDeBusca.text = cidadeAtual;
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      throw Exception('Erro ao buscar cidade atual $e');
    }
  }

  atualizarEhNoite() {
    int horaAtual = DateTime.now().hour;
    ehNoite = horaAtual >= 18 || horaAtual < 6;
  }

  _buscarPrevisaoTempo(String cidade) async {
    try {
      setState(() {
        _carregando = true;
      });
      final previsao = await _servicoPrevisao.getPrevisao(cidade);
      setState(() {
        _previsaoTempo = previsao;
        nomeCidadeApi = cidade;
        atualizarEhNoite();
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      throw Exception('Erro ao buscar previsões $e');
    }
  }

  String escolherAnimacao(String? condicaoClimatica) {
    atualizarEhNoite();
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
  void initState() {
    super.initState();
    _inicial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: ehNoite ? Color(0xFF181717) : Colors.white,
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
                        nomeCidade: _previsaoTempo != null
                            ? _previsaoTempo!.first.nomeCidade
                            : nomeCidadeApi,
                        ehNoite: ehNoite,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_previsaoTempo != null &&
                            _previsaoTempo!.isNotEmpty)
                          Lottie.asset(escolherAnimacao(
                              _previsaoTempo!.first.condicaoClimatica)),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_previsaoTempo != null &&
                                  _previsaoTempo!.isNotEmpty)
                                Text(
                                  '${_previsaoTempo!.first.temperatura.toStringAsFixed(0)}°',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: ehNoite
                                          ? Colors.white
                                          : Color(0xFF181717)),
                                ),
                              if (_previsaoTempo != null &&
                                  _previsaoTempo!.isNotEmpty)
                                Text(
                                  '${_previsaoTempo!.first.diaSemana}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: ehNoite
                                          ? Colors.white
                                          : Color(0xFF181717)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_previsaoTempo != null && _previsaoTempo!.isNotEmpty)
                      CardPrevisoes(
                        previsoes: _previsaoTempo!,
                        ehNoite: ehNoite,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
