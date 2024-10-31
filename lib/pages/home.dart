import 'package:app_wheater/components/InputBusca.dart';
import 'package:app_wheater/models/previsao_tempo.dart';
import 'package:app_wheater/services/servico_previsao.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final _servicoPrevisao = ServicoPrevisao();
  PrevisaoTempo? _previsaoTempo;
  final TextEditingController _controladorDeBusca = TextEditingController();

  _inicial() async {
    try {
      String cidadeAtual =
        await _servicoPrevisao.buscarCidadeAtual();
      final previsao = await _servicoPrevisao.getPrevisao(cidadeAtual);

      setState(() {
        _previsaoTempo = previsao;
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
        });
      } catch (e) {
        print('Erro ao buscar a cidade pelo nome: $e');
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
             ),
           ),
          Container(
            child: Text('Temperatura: ${_previsaoTempo?.temperatura.toStringAsFixed(1)}°C'),
          ),
        ],
      ),
    );
  }

}