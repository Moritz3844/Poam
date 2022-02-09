import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:provider/provider.dart';

class PoamFloatingButton extends StatefulWidget {
  const PoamFloatingButton({Key? key}) : super(key: key);

  @override
  _PoamFloatingButtonState createState() => _PoamFloatingButtonState();
}

class _PoamFloatingButtonState extends State<PoamFloatingButton> {

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton(
      //backgroundColor: primaryColor,
      onPressed: () => {
        setState(() {
          //Add Items to the List
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Zimmer aufräumen", 1, false, Person().setPersonModel("Moritz Platen"), Categories.tasks, "07/02/2022"));
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Gurken holen", 1, false, Person(), Categories.shopping, "07/02/2022"));
        })
      },
      child: Container(
        width: 60,
        height: 60,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            radius: 0.8,
            center: const Alignment(0.7, -0.6),
            colors: [primaryColor, primaryColor.withRed(180).withBlue(140)],
            stops: const [0.0, 0.9],
          ),
        ),
      ),
    );
  }
}
