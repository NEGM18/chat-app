import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
   CustomTextField({this.labelText,this.onChangedd});

String? labelText;
Function(String)? onChangedd;
  @override
  Widget build(BuildContext context) {
    return 
       TextFormField(
        validator: (data){
          if(data!.isEmpty){
            return 'field is required';
          }
          return null;
        },
        onChanged:onChangedd ,
        strutStyle:const StrutStyle(
          fontSize:15
        ),
        style: TextStyle(color: Colors.white),
        autocorrect: true,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 20,color: Colors.red ),
           
            hintStyle:const TextStyle(
              color: Colors.white,
            ),
            enabledBorder:const OutlineInputBorder(
            borderSide: BorderSide(
              color:  Colors.red,
            ),
            ),
            focusedBorder:const OutlineInputBorder(
             borderSide: BorderSide(
              color: Colors.green
             )
            ),
          
            border: const OutlineInputBorder(
            )
          ),
         );
  }
}