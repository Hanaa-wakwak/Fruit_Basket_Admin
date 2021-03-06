
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/models/add_category_model.dart';
import 'package:grocery_admin/models/category.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';
class AddCategory extends StatefulWidget {


  final AddCategoryModel model;
  final Category category;

  const AddCategory._({@required this.model, this.category});


  static Future<bool>  create(BuildContext context,{Category category}){
    final database=Provider.of<Database>(context,listen: false);
     return showModalBottomSheet(context: context,

         isScrollControlled: true,

         builder: (context){

       return Padding(
         padding: MediaQuery.of(context).viewInsets,
         child:     ChangeNotifierProvider<AddCategoryModel>(create: (context)=> AddCategoryModel(database: database),

           child: Consumer<AddCategoryModel>(

             builder: (context,model,_){
               return AddCategory._(model: model,
                 category: category,
               );
             },
           ),



         ),

       );




     });



  }

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> with TickerProviderStateMixin{

  TextEditingController titleController=TextEditingController();

  FocusNode titleFocus=FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.category!=null){
      titleController=TextEditingController(text: widget.category.title);


      widget.model.image=widget.category.image;
      widget.model.networkImage=true;
    }

  }



  @override
  Widget build(BuildContext context) {

    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    bool isPortrait=MediaQuery.of(context).orientation==Orientation.portrait;
    final themeModel=Provider.of<ThemeModel>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(
            topLeft:
            Radius.circular(15),
            topRight:
            Radius.circular(15),
          ),
          color: themeModel
              .secondBackgroundColor),
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Align(
            alignment:
            Alignment.center,
            child: Texts.headline2(
                ((widget.category==null)? "Add" : "Edit") + " Shop Name",
                themeModel.textColor),
          ),

          Padding(padding: EdgeInsets.only(
            top: 20
          ),

          child: TextFields.defaultTextField(

            changeBackColor: true,
              themeModel: themeModel,
              controller: titleController,
              focusNode: titleFocus,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
              labelText: "title",
              onSubmitted: (value){

              },
              error: !widget.model.validTitle,
              isLoading: widget.model.isLoading),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validTitle) ? FadeIn(
              child: Texts.helperText('Please enter a valid title', Colors.red),
            ) : SizedBox(),
          ),


          Padding(
            padding: EdgeInsets.only(top:10,left: 10,right: 10),
            child: Center(
              child: GestureDetector(
                onTap:  !widget.model.isLoading ?() {
                  widget.model.chooseImage(context);
                } :(){},
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2,color:(!widget.model.validImage)? Colors.red :Colors.transparent )
                    ),

                    child: ClipRRect(

                      borderRadius: BorderRadius.circular(15),
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:(!widget.model.networkImage) ?  FadeInImage(
                          placeholder: AssetImage(''),
                          image: (widget.model.image=='images/upload_image.png')? AssetImage(widget.model.image) :  FileImage(File(widget.model.image)),

                          width:(isPortrait)? width / 3 :height/4,
                          fit: BoxFit.cover,
                        ) :FadeInImage(
                          placeholder: AssetImage(''),
                          image:   NetworkImage(widget.model.image),

                          width:(isPortrait)? width / 3 :height/5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validImage) ? FadeIn(
              child: Center(
                child: Texts.helperText('Please choose an image', Colors.red),
              ),
            ) : SizedBox(),
          ),

          Align(
            alignment:
            Alignment.center,
            child: (widget.model.isLoading)? Center(
              child: CircularProgressIndicator(),
            ) : Buttons
                .button(
                //margin: EdgeInsets.all(0),
                widget: Texts.headline3(
                    (widget.category==null)? "Add" : "Update",
                    Colors
                        .white),
                function:()async{
                  await widget.model.submit(context, titleController.text, widget.category);
                },
                color: themeModel.accentColor),
          )
        ],
      ),
    );
  }
}
