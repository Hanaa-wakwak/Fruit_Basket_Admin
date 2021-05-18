import 'package:flutter/material.dart';
import 'package:grocery_admin/models/theme_model.dart';


///All textFields used in the app
class TextFields {
  static Widget emailTextField({
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required TextInputAction textInputAction,
    @required TextInputType textInputType,
    @required String labelText,
    @required IconData iconData,
    @required Function onSubmitted,
    @required bool error,
    @required bool isLoading,
    @required ThemeModel themeModel,
    bool obscureText = false,
    @required TextEditingController textEditingController,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: themeModel.secondBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            width: 2, color: error ? Colors.red : Colors.transparent),
        /* boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0,5),
                color: themeModel.shadowColor
            )
          ]*/
      ),
      child: TextField(
        enabled: !isLoading,
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        onSubmitted: (value) {
          onSubmitted();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelText: labelText,
          icon: Icon(iconData),
        ),
      ),
    );
  }

  static Widget defaultTextField({
    @required ThemeModel themeModel,
    @required TextEditingController controller,
    @required FocusNode focusNode,
    @required TextInputType textInputType,
    @required TextInputAction textInputAction,
    @required String labelText,
    @required Function(String) onSubmitted,
    bool enabled = true,
    @required bool error,
    @required bool isLoading,
    int minLines = 1,
    int maxLines = 1,
    EdgeInsets padding= const EdgeInsets.all(10),
    EdgeInsets margin= const EdgeInsets.all(0),
    bool changeBackColor=false
  }) {
    Color backColor=(changeBackColor)? themeModel.backgroundColor:themeModel.secondBackgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: enabled
            ? backColor
            : backColor.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            width: 2, color: error ? Colors.red : Colors.transparent),
      ),
      padding: padding,
      margin: margin,
      child: TextField(
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled && !isLoading,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onChanged: (value) {},
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: labelText,
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }
}
