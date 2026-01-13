import 'package:flutter/material.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("DoseUp"),
        
        ),
        actions: [
         Row(
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Home"),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("About"),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Contact Us"),
             ),
           ],
         )
        ],
      ),
      body: Container(
        color: Colors.blue,
        height: 400,
        
      ),
    );
  }
}