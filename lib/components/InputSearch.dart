import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCitySelected;

  InputSearch({required this.controller, required this.onCitySelected});

  @override
  State<StatefulWidget> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isSearching ? _buildSearchInput() : _buildCityButton();
  }

  Widget _buildCityButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSearching = true;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 30, color: Color(0xFF676767),),
          Text(
            widget.controller.text.isNotEmpty
                ? widget.controller.text
                : 'Cidade não encontrada',
            style: TextStyle(color: Color(0xFF676767), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.close, color: Color(0xFF676767),),
          onPressed: () {
            setState(() {
              isSearching = false;
            });
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Digite o nome da cidade',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: Icon(Icons.search)
            ),
            onSubmitted: (cityName) {
              widget.onCitySelected(cityName);
              setState(() {
                isSearching = false;
                widget.controller.text = cityName;
              });
            },
          ),
        )
      ],
    );
  }
}