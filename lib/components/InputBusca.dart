import 'package:flutter/material.dart';

class InputBusca extends StatefulWidget {
  final TextEditingController controlador;
  final Function(String) cidadeSelecionada;

  InputBusca({required this.controlador, required this.cidadeSelecionada});

  @override
  State<StatefulWidget> createState() => _InputBuscaState();
}

class _InputBuscaState extends State<InputBusca> {
  bool estaBuscando = false;
  final TextEditingController controladorBusca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return estaBuscando ? _buildInputBusca() : _buildBotaoCidade();
  }

  Widget _buildBotaoCidade() {
    return GestureDetector(
      onTap: () {
        setState(() {
          estaBuscando = true;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 30, color: Color(0xFF676767)),
          Text(
            widget.controlador.text.isNotEmpty
                ? widget.controlador.text
                : 'Cidade não encontrada',
            style: TextStyle(color: Color(0xFF676767), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBusca() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.close, color: Color(0xFF676767)),
          onPressed: () {
            setState(() {
              estaBuscando = false;
            });
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controladorBusca,
            decoration: InputDecoration(
              hintText: 'Digite o nome da cidade',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (nomeCidade) {
              widget.cidadeSelecionada(nomeCidade);
              setState(() {
                estaBuscando = false;
                widget.controlador.text = nomeCidade;
              });
            },
          ),
        ),
      ],
    );
  }
}
