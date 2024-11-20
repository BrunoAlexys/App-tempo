import 'package:flutter/material.dart';

class InputBusca extends StatefulWidget {
  final TextEditingController controlador;
  final Function(String) cidadeSelecionada;
  final String? nomeCidade;
  final bool ehNoite;

  InputBusca({required this.controlador, required this.cidadeSelecionada, required this.nomeCidade, required this.ehNoite});

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
          Icon(Icons.location_on, size: 30, color: widget.ehNoite ? Colors.white : Color(0xFF676767)),
          Text(
            widget.nomeCidade?.isNotEmpty == true
                ? widget.nomeCidade!
                : 'Cidade não encontrada',
            style: TextStyle(color: widget.ehNoite ? Colors.white : Color(0xFF676767), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBusca() {
    controladorBusca.clear();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.close, color: widget.ehNoite ? Colors.white : Color(0xFF676767)),
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
            style: TextStyle(
              color: widget.ehNoite ? Colors.white : Color(0xFF676767),
            ),
            decoration: InputDecoration(
              hintText: 'Digite o nome da cidade',
              hintStyle: TextStyle(
                color: widget.ehNoite ? Colors.white : Color(0xFF676767),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: Icon(Icons.search, color: widget.ehNoite ? Colors.white :  Color(0xFF676767),),
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
