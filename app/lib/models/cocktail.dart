class Cocktail{
  const Cocktail({required this.imageUrl, required this.name, required this.instructions, required this.ingredients});
  
  final String name;
  final String instructions;
  final String imageUrl;
  final List<String>ingredients;
}