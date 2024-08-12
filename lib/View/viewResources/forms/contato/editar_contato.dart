import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:recipes/Model/contato_model.dart';
import 'package:recipes/Services/contato_service.dart';
import 'package:recipes/View/viewResources/layout/menu.dart';
import 'package:recipes/View/viewResources/pages/busca.dart';
import 'package:recipes/View/viewResources/layout/barra_superior.dart';
import 'package:recipes/View/viewResources/form_widgets/text_form.dart';

class EditarContato extends StatefulWidget {
  final String id;
  const EditarContato({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => EditarContatoState();
}

class EditarContatoState extends State<EditarContato> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final numero = TextEditingController();
  final RadioGroupController genero = RadioGroupController();
  final List<String> paises = ["Brasil", "Colombia", "Mexico"]; //substituir
  late String pais = '';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: Barrasuperior(nome: "Editar Contato"),
      drawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            minRadius: 90,
                            child: const Icon(
                              Icons.person_rounded,
                              size: 130,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              minRadius: 25,
                              backgroundColor:
                                  Color.fromARGB(255, 237, 241, 248),
                              child: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  secret: false,
                  controller: nome,
                  validatorMessage: "Insira um nome válido",
                  type: TextFormType.text,
                  labelText: "Nome Completo",
                ),
                CustomTextFormField(
                  secret: false,
                  controller: email,
                  validatorMessage: "Insira um email válido",
                  type: TextFormType.email,
                  labelText: "Email",
                ),
                CustomTextFormField(
                  secret: false,
                  controller: numero,
                  validatorMessage: "Insira um numero válido",
                  type: TextFormType.numero,
                  labelText: "Telefone / Celular",
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    labelText: "País de Origem",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 98, 160, 190),
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                  value: pais.isEmpty ? null : pais,
                  validator: (pais) {
                    if (pais == null || pais.isEmpty) {
                      return "Selecione seu país atual!";
                    }
                    return null;
                  },
                  onChanged: (pais2) {
                    setState(() {
                      pais = pais2!;
                    });
                  },
                  items: paises.map<DropdownMenuItem<String>>((String pais) {
                    return DropdownMenuItem<String>(
                      value: pais,
                      child: Text(
                        pais,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                RadioGroup(
                  indexOfDefault: 2,
                  controller: genero,
                  values: const [
                    "Feminino",
                    "Masculino",
                    "Prefiro não responder"
                  ],
                  orientation: RadioGroupOrientation.horizontal,
                  decoration: RadioGroupDecoration(
                    fillColor: WidgetStateColor.resolveWith((states) {
                      return const Color.fromARGB(255, 98, 160, 190);
                    }),
                    spacing: 10.0,
                    labelStyle: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                    activeColor: Colors.amber,
                  ),
                ),
                Builder(builder: (BuildContext context) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () => {
                            // cadastrarContato(),
                            if (formKey.currentState!.validate())
                              {
                                editar(),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Busca())),
                              }
                          },
                      child: const SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Cadastrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editar() {
    ContatoService service = ContatoService();

    Timestamp momento = Timestamp.fromDate(DateTime.now());

    Contato contato = Contato(
        nome: nome.text,
        email: email.text,
        pais: pais,
        genero: genero.value,
        numero: numero.text,
        ultimaIteracao: momento);

    service.editarContato(contato, widget.id);
  }
}
