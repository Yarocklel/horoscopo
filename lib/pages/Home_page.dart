import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:horoscopo/models/astros_model.dart';
import 'package:horoscopo/providers/astros_provider.dart';

final signo = new AstrosProvider();
// Future signozod = signo.getastros();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pag = 0;
  List<String> _zodiaco = [
    'ARIES',
    'TAURO',
    'GÉMINIS',
    'CÁNCER',
    'LEO',
    'VIRGO',
    'LIBRA',
    'ESCORPIÓN',
    'SAGITARIO',
    'CAPRICORNIO',
    'ACUARIO',
    'PISCIS'
  ];
  @override
  Widget build(BuildContext context) {
    final tampant = MediaQuery.of(context).size;
    return Scaffold(
      // // extendBody: true,
      body: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (BuildContext context, index) {
            return _horozcopoPage(index, tampant);
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: pag,
          onTap: (index) {
            setState(() {
              pag = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.firstAid), label: 'Salud'),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.heart), label: 'Amor'),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.moneyBill), label: 'Dinero')
          ]),
    );
  }

  Widget _horozcopoPage(int pagina, Size size) {
    int a = 0;
    String texto;
    return Column(children: [
      Expanded(
        child: Container(
          color: Colors.amber,
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image(
                      image: AssetImage('assets/${_zodiaco[pagina]}.png'),
                      width: size.width * .22,
                      height: size.width * .22),
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      _zodiaco[pagina],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'AmaticSC', fontSize: size.width * .17),
                    )),
              ],
            ),
          ),
        ),
        flex: 1,
      ),
      Expanded(
        child: FutureBuilder(
            future: signo.getAstros(),
            builder: (BuildContext context, AsyncSnapshot<Astros> snapshot) {
              if (snapshot.hasData) {
                print(snapshot);
                for (var x in snapshot.data.horoscopo.values) {
                  if (a == pagina) {
                    switch (pag) {
                      case 0:
                        texto = x.salud;
                        break;
                      case 1:
                        texto = x.amor;
                        break;
                      case 2:
                        texto = x.dinero;
                        break;
                    }

                    a = 0;
                  }
                  print(x.salud);
                  a = a + 1;
                }
                return SingleChildScrollView(
                  child: FadeInUp(
                    child: Container(
                        child: Text(
                      texto ?? 'default value',
                      style: TextStyle(
                          fontFamily: 'AmaticSC', fontSize: size.width * .17),
                    )),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        flex: 3,
      ),
    ]);
  }
}
