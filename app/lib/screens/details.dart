import 'package:flutter/material.dart';

import 'package:app/models/cocktail.dart';

class DetailsScreen extends StatelessWidget{
  const DetailsScreen({required this.cocktail, super.key});
  final Cocktail cocktail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name),
        backgroundColor: const Color.fromARGB(255, 120, 183, 167),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                cocktail.imageUrl,
                loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress!=null){
                      return const CircularProgressIndicator();
                    }
                    return child;
                  },
                width: double.infinity,  
                fit: BoxFit.cover,
                height: 300,
                ),
                const SizedBox(height: 20,),
                    Text('Ingredients', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold
                    )),
               const SizedBox(height: 5,),
                ...cocktail.ingredients.map((item) => 
                Row(
                  children: [
                   const Icon(Icons.check_box, color: Color.fromARGB(255, 120, 183, 167),), 
                  Text(item, style: Theme.of(context).textTheme.headlineSmall,),
                ],)),
                const SizedBox(height: 20,),
                    Text('Instructions', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold
                    )),
               const SizedBox(height: 5,),
                  Text(cocktail.instructions, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}