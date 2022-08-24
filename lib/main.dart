import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController etanolController = TextEditingController();
  TextEditingController gasolinaController = TextEditingController();
  String _resultado = "Informe os valores";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //a lógica que usaremos é:
  //se a proporção for maior do que 0.7, então deve-se abastecer com gasolina
  void _calculaCombustivelIdeal() {
    double vEtanol = double.parse(etanolController.text.replaceAll(',', '.'));
    double vGasolina =
        double.parse(gasolinaController.text.replaceAll(',', '.'));

    double proporcao = vEtanol / vGasolina;

    // if(proporcao <= 0.7) {
    //   _resultado = "Abasteça com Etanol";
    // } else {
    //   _resultado = "Abasteça com Gasolina";
    // }

    //é um if ternário:
    setState(() {
      _resultado = (proporcao <= 0.7)
        ? "Abasteça com Etanol (Proporção: ${proporcao.toStringAsFixed(2).replaceAll('.', ',')})"
        : "Abasteça com Gasolina (Proporção: ${proporcao.toStringAsFixed(2).replaceAll('.', ',')})";
    }); 
  }

  void _reset() {
    etanolController.text = "";
    gasolinaController.text = "";
    setState(() {
      _resultado = "Informe os valores";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Etanol ou Gasolina?",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 89, 45, 220),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _reset();
            }, 
          )
        ],
      ),
      body: SingleChildScrollView(
          //um pequeno afastamento das laterias do body
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Form(
            key: _formKey,
            child: Column(
              //alinhamento cruzado da coluna (vertical):
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.local_gas_station_outlined,
                  size: 130,
                  color: Colors.deepPurple[800],
                ),
                TextFormField(
                  controller: etanolController,
                  //alinhamento do texto ao centro
                  textAlign: TextAlign.center,
                  //tipo de teclado que será exibido no smartphone
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  //Decoração do campo:
                  decoration: InputDecoration(
                      labelText: "Valor do Etanol",
                      labelStyle: TextStyle(color: Colors.deepPurple[800])),
                  //estilo da fonte interna do TextFormField
                  style: TextStyle(color: Colors.deepPurple[800], fontSize: 26),
                  validator: (value) {
                    // if(value == null || value.isEmpty) {
                    //   return "Informe o valor do Etanol";
                    // } else {
                    //   return null;
                    // }
                    //é o mesmo que...

                    return (value == null || value.isEmpty) ? "Informe o valor do Etanol!" : null;

                  },
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: gasolinaController,
                  //alinhamento do texto ao centro
                  textAlign: TextAlign.center,
                  //tipo de teclado que será exibido no smartphone
                  keyboardType: 
                      const TextInputType.numberWithOptions(decimal: true),
                  //Decoração do campo:
                  decoration: InputDecoration(
                      labelText: "Valor da Gasolina",
                      labelStyle: TextStyle(color: Colors.deepPurple[800])),
                  //estilo da fonte interna do TextFormField
                  style: TextStyle(color: Colors.deepPurple[800], fontSize: 26),
                  validator: (value) {
                    return (value == null || value.isEmpty) ? "Informe o valor da gasolina!" : null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        child: const Text(
                          "Verificar",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple[800]),
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            _calculaCombustivelIdeal();
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Resultado", style: TextStyle(fontWeight: FontWeight.bold),),
                                content: Text(_resultado),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "Ok"), 
                                    child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold), )
                                  )
                                ],
                              )
                            );
                          }
                        },
                      )),
                ),
                Text(
                  _resultado,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple[800], fontSize: 24),
                )
              ],
            ),
          )),
    );
  }
}
