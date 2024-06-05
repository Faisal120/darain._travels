import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class DateTextField extends StatelessWidget {
  final String htext;
  final bool isValidate;
  final IconData icon;
  final TextEditingController tController;
  final void Function()? ontap;
  bool isEditable=false;

  DateTextField(
      {Key? key,
      required this.tController,
      required this.htext,
      required this.isValidate,
      required this.ontap,
      required this.icon,
      required this.isEditable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {},
        child: Container(
          width: double.infinity,
          color: isEditable? Colors.white:Colors.transparent,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tController,
              onTap: ontap,
              decoration: InputDecoration(
                hintText: htext,
                enabled: isEditable? true: false,
                prefixIcon: Icon(icon),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mainTheme, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                enabledBorder: isEditable? OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1)):OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.green, width: 1)),
                disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1)),
              ),
            ),
          ),
        ));
  }
}
