import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/utils/text.dart';

showCustomDialog(
  BuildContext context,
  String title,
  String content,
  Widget titleIcon,
  Function? onPressed,
  String mainButtonName,
  String secondaryButtonName,
) async {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleIcon,
                const SizedBox(
                  width: 10,
                ),
                ModifiedText(
                  text: title,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
            ModifiedText(text: content, color: Colors.white, size: 15),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: ModifiedText(
                        text: secondaryButtonName,
                        color: secondaryColor,
                        size: 15)),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {},
                    child: ModifiedText(
                        text: mainButtonName, color: secondaryColor, size: 15))
              ],
            ),
          ],
        ),
      );
    },
  );
}
