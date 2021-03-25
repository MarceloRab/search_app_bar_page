//import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'AppExample',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      ///Here is the injection that you only dispose of with the app.
      // initialBinding: SharingBindings(),
    ),
  );
}

class SharingBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SharingController());
  }
}

abstract class Routes {
  static const HOME = '/home';
  static const EXAMPLE_ONE = '/example_one';
  static const EXAMPLE_TWO = '/example_two';
}

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),

      ///Here you do the injection in a modular way.
      ///As it is the first page, I don't need bindings on the others.
      /// It has the same controller.
      binding: SharingBindings(),
    ),
    GetPage(
      name: Routes.EXAMPLE_ONE,
      page: () => HomePageExample1(),
    ),
    GetPage(
      name: Routes.EXAMPLE_TWO,
      page: () {
        ///Collect the injection performed on the SharingBindings of HomePage.
        Get.find<SharingController>().getRxList(TypeList.expired);

        6.delay(() {
          Get.find<SharingController>().getRxList(TypeList.consumed);
          Get.snackbar('LIsta consumed', 'Changed');
        });
        12.delay(() {
          Get.find<SharingController>().getRxList(TypeList.active);
          Get.snackbar('LIsta active', 'Changed');
        });
        return HomePageExample2();
      },
    ),
  ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.EXAMPLE_ONE);
                },
                child: const Text(
                  'Page Example One',
                  style: TextStyle(fontSize: 20),
                )),
            MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.EXAMPLE_TWO);
                },
                child: const Text(
                  'Page Example Two',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}

class HomePageExample1 extends StatefulWidget {
  @override
  _HomePageExample1State createState() => _HomePageExample1State();
}

class _HomePageExample1State extends State<HomePageExample1> {
  late SharingController controller;

  @override
  void initState() {
    controller = Get.find<SharingController>();
    controller.getRxList(TypeList.expired);

    6.delay(() {
      controller.getRxList(TypeList.consumed);
      Get.snackbar('LIsta consumed', 'Changed');
    });
    12.delay(() {
      controller.getRxList(TypeList.active);
      Get.snackbar('LIsta active', 'Changed');
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Obx(() {
        ///Advantage. Just insert the get inside and any changes
        ///redo this function
        if (controller.isLoading) {
        return  const Center(child: CircularProgressIndicator());
        }

        return ListView(
          shrinkWrap: true,
          children: controller.listCchoice
              .map((Person person) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  // color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Name: ${person.name}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Age: ${person.age!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  )))
              .toList(),
        );
      }),
    );
  }
}

/// GetView = > You already do the find to collect the injection automatically.
class HomePageExample2 extends GetView<SharingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: controller.isLoadingRxList.getStreamWidget(
          obxWidgetBuilder: (context, isloading) {
        return ListView(
          shrinkWrap: true,
          children: controller.listCchoice
              .map((Person person) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  // color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Name: ${person.name}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Age: ${person.age!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  )))
              .toList(),
        );
      }),
    );
  }
}

class SharingController extends GetxController {
  /*final RxList<Person> consumed = <Person>[].obs;
  final RxList<Person> expired = <Person>[].obs;
  final RxList<Person> active = <Person>[].obs;*/

  final timeDelay = 3.0;

  List<Person> consumed = <Person>[];
  List<Person> expired = <Person>[];
  List<Person> active = <Person>[];
  List<Person> listCchoice = <Person>[];

  ///This will make the list reactive.
  final isLoadingRxList = true.obs;

  set isLoading(bool? value) => isLoadingRxList.value = value;

  bool get isLoading => isLoadingRxList.value!;

  Future<List> getRxList(TypeList typeList) async {
    isLoading = true;
    switch (typeList) {
      case TypeList.consumed:
        await loadMyConsumedSharings();
        isLoading = false;
        break;
      case TypeList.expired:
        await loadMyExpiredSharings();
        isLoading = false;
        break;
      case TypeList.active:
        await loadMyActiveSharings();
        isLoading = false;
        break;
    }
    return expired;
  }

  Future<void> loadMyActiveSharings() async {
    await timeDelay.delay();
    listCchoice.clear();
    listCchoice.addAll(activePerson);
  }

  Future<void> loadMyConsumedSharings() async {
    await timeDelay.delay();
    listCchoice.clear();
    listCchoice.addAll(consumedPerson);
  }

  Future<void> loadMyExpiredSharings() async {
    await timeDelay.delay();
    listCchoice.clear();
    listCchoice.addAll(expiredPerson);
  }
}

enum TypeList { consumed, expired, active }

final activePerson = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
];

final expiredPerson = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
  Person(name: 'Antonio Rabelo', age: 33),
  Person(name: 'Leticia Maciel', age: 47),
  Person(name: 'Patricia Oliveira', age: 19),
  Person(name: 'Pedro Lima', age: 15),
  Person(name: 'Junior Rabelo', age: 33),
  Person(name: 'Lucia Maciel', age: 47),
  Person(name: 'Ana Oliveira', age: 19),
  Person(name: 'Thiago Silva', age: 33),
  Person(name: 'Charles Ristow', age: 47),
  Person(name: 'Raquel Montenegro', age: 19),
  Person(name: 'Rafael Peireira', age: 15),
  Person(name: 'Nome Comum', age: 33),
];

final consumedPerson = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Ana Pereira', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
  Person(name: 'Antonio Rabelo', age: 33),
  Person(name: 'Leticia Maciel', age: 47),
  Person(name: 'Patricia Oliveira', age: 19),
  Person(name: 'Pedro Lima', age: 15),
  Person(name: 'Fabio Melo', age: 51),
  Person(name: 'Junior Rabelo', age: 33),
  Person(name: 'Lucia Maciel', age: 47),
  Person(name: 'Ana Oliveira', age: 19),
  Person(name: 'Thiago Silva', age: 33),
  Person(name: 'Charles Ristow', age: 47),
  Person(name: 'Raquel Montenegro', age: 19),
  Person(name: 'Rafael Peireira', age: 15),
  Person(name: 'Thiago Ferreira', age: 33),
  Person(name: 'Joaquim Gomes', age: 18),
  Person(name: 'Esther Guerra', age: 23),
  Person(name: 'Pedro Braga', age: 19),
  Person(name: 'Milu Silva', age: 17),
  Person(name: 'William Ristow', age: 47),
  Person(name: 'Elias Tato', age: 22),
  Person(name: 'Dada Istomesmo', age: 44),
  Person(name: 'Nome Incomum', age: 52),
  Person(name: 'Qualquer Nome', age: 9),
  Person(name: 'First Last', age: 11),
  Person(name: 'Bom Dia', age: 23),
  Person(name: 'Bem Mequiz', age: 13),
  Person(name: 'Mal Mequer', age: 71),
  Person(name: 'Quem Sabe', age: 35),
  Person(name: 'Miriam Leitao', age: 33),
  Person(name: 'Gabriel Mentiroso', age: 19),
  Person(name: 'Caio Petro', age: 27),
  Person(name: 'Tanto Nome', age: 66),
  Person(name: 'Nao Diga', age: 33),
  Person(name: 'Fique Queto', age: 11),
  Person(name: 'Cicero Gome', age: 37),
  Person(name: 'Carlos Gome', age: 48),
  Person(name: 'Mae Querida', age: 45),
  Person(name: 'Exausto Nome', age: 81),
];

//class Person extends CacheJson {
class Person {
  final String? name;

  final int? age;
  final String? id;
  final String? avatar;
  final String? username;
  final String? image;

  Person({
    this.name,
    this.age,
    this.id,
    this.avatar,
    this.username,
    this.image,
  });

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String?,
      age: (map['age'] as int?) ?? 0,
      id: map['id'] as String?,
      avatar: map['avatar'] as String?,
      username: map['username'] as String?,
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'id': id,
      'avatar': avatar,
      'username': username,
      'image': image,
    };
  }
}
