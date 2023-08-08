import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:http/http.dart' as http;

import 'package:app/models/cocktail.dart';
import 'package:app/screens/details.dart';
import 'package:app/constant.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Cocktail> _cocktails=[];
  var _isLoading=true;
  var _error='';

  void _loadData({String searchData = 'a'}) async{
    if(searchData.trim().isEmpty){
    setState(() {
      _isLoading=false;
    });
    return;
    }
    var url=Uri.https(Constant.url, '/api/json/v1/1/search.php', {'s':searchData.toLowerCase()});
    try{
      final response=await http.get(url);
      final Map<String, dynamic>data=json.decode(response.body);
      const ingredientCount=15;
      _cocktails=[];
      if(data['drinks']!=null){
              for(var item in data['drinks']){
        List<String>ingredients=[];
        for(var i=1;i<=ingredientCount;i++){
          if(item['strIngredient$i']==null){
            break;
          }
          ingredients.add(item['strIngredient$i']);
        }
        _cocktails.add(Cocktail(imageUrl: item['strDrinkThumb'] , name: item['strDrink'].toString().toUpperCase(), instructions: item['strInstructions'], ingredients: ingredients));
      }
      }

    setState(() {
      _isLoading=false;
    });
    }
    catch(error){
      setState(() {
        _isLoading=false;
        _error='Something went wrong!';  
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  
  @override
  Widget build(BuildContext context) {
    Widget content=const Center(child: CircularProgressIndicator());
    if(!_isLoading){
      if(_error.isEmpty){
        if(_cocktails.isEmpty){
          content=Center(child: Text('Nothing found!', style: Theme.of(context).textTheme.titleLarge,));
        }
        else{
          content=ListView.builder(itemCount: _cocktails.length, itemBuilder: (ctx, index)=>Container(
        decoration: BoxDecoration(
          boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 120, 183, 167).withOpacity(0.25),
        spreadRadius: 1,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
          border: Border.all(color: const Color.fromARGB(255, 6, 87, 67), width: 1.1),
          borderRadius: BorderRadius.circular(5)
        ),
        margin: const EdgeInsets.all(6),
        
        child: ListTile(
          title: Text(_cocktails[index].name, style: Theme.of(context).textTheme.titleLarge,),
          leading: Image.network(
            _cocktails[index].imageUrl,
            loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress!=null){
                  return const CircularProgressIndicator();
                }
                return child;
              },
            fit: BoxFit.fill,
            width: 95,
            ),
            onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: 
              (con)=>DetailsScreen(cocktail:
               _cocktails[index])));
            }
        ),
      ),
      );
        }
      }
      else{
        content= Center(
          child: Text(_error, style: Theme.of(context).textTheme.titleLarge),
        );
      }
    }

    return Scaffold(
      appBar: EasySearchBar(
        foregroundColor: Colors.white,
        title: const Text('Cocktails'),
        backgroundColor: const Color.fromARGB(255, 120, 183, 167),
        onSearch: (text){
          setState(() {
            _isLoading=true;
          });
          _loadData(searchData: text);
        },
      ),
      body: content,
    );
  }
}