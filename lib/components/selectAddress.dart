import 'package:flutter/material.dart';

class address extends StatefulWidget {
  final Function(String area, String city, String Country) onChanged;

  const address({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<address> createState() => _HomePageState();
}

class _HomePageState extends State<address> {
  String? _selectedItem;
  String? _selectedcity;
  String? _selectedarea;
  String area = '';
  String city = '';
  String country = '';

  void _onValueChanged() {
    widget.onChanged(area, city, country);
  }

  void _showSingleSelect() async {
    List<String> countries = [
      'فلسطين وعرب 48',
    ];

    final String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleSelect(
          items: countries,
          selectedItem: _selectedItem,
          onItemSelected: (item) {
            setState(() {
              _selectedItem = item;
            });
            Navigator.pop(context, item);
          },
        );
      },
    );

    // Update UI
    if (result != null) {
      setState(() {
        _selectedItem = result;
        // Assuming onChanged expects a String
        country = _selectedItem!;
        _onValueChanged();
      });
    }
  }

  void _showCity() async {
    List<String> cities;

    cities = [
      'بيت لحم',
      'الخليل',
      'جنين',
      'اريحا',
      'نابلس',
      'طولكرم',
      'رام الله',
    ];

    final String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleSelect(
          items: cities,
          selectedItem: _selectedcity,
          onItemSelected: (item) {
            setState(() {
              _selectedarea = null;
              _selectedcity = item;
            });
            Navigator.pop(context, item);
          },
        );
      },
    );

    // Update UI
    if (result != null) {
      setState(() {
        _selectedcity = result;
        city = _selectedcity!;
        _onValueChanged();
      });
    }
  }

  void _showPlace() async {
    List<String> cities;
    if (_selectedcity == 'بيت لحم') {
      cities = [
        '',
        'الخليل',
        'جنين',
        'اريحا',
        'نابلس',
        'طولكرم',
        'رام الله',
      ];
    } else if (_selectedcity == 'الخليل') {
      cities = [];
    } else if (_selectedcity == 'جنين') {
      cities = [];
    } else if (_selectedcity == 'اريحا') {
      cities = [];
    } else if (_selectedcity == 'نابلس') {
      cities = [];
    } else if (_selectedcity == 'طولكرم') {
      cities = [];
    } else if (_selectedcity == 'رام الله') {
      cities = [];
    } else {
      cities = [];
    }

    final String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleSelect(
          items: cities,
          selectedItem: _selectedarea,
          onItemSelected: (item) {
            setState(() {
              _selectedarea = item;
            });
            Navigator.pop(context, item);
          },
        );
      },
    );

    // Update UI
    if (result != null) {
      setState(() {
        _selectedarea = result;
        area = _selectedcity!;
        _onValueChanged();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/palestine.png',
                    width: 30, height: 30),
                Text(
                  // _selectedItem ?? 'الــدولــة',
                  "فــلــسـطـيـن وعـرب 48",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Lateef',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _showCity,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.location_city,
                  color: Colors.black,
                ),
                Text(
                  _selectedcity ?? 'الــمـديـنـة',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Lateef',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _showPlace,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/area.png', width: 20, height: 20),
                Text(
                  _selectedarea ?? 'مــنــطـقـتـك',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Lateef',
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

class SingleSelect extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String>? onItemSelected;

  const SingleSelect({
    Key? key,
    required this.items,
    this.selectedItem,
    this.onItemSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: const Text(
          'الــدولــة',
          style: TextStyle(fontFamily: 'Lateef'),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Lateef',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (widget.onItemSelected != null) {
                            widget.onItemSelected!(item);
                          }
                        },
                        tileColor: item == widget.selectedItem
                            ? Colors.blue.withOpacity(0.1)
                            : null,
                      ),
                      const Divider(),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
