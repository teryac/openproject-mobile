/* class ProjectCollection {
  Embedded embedded;

  ProjectCollection({required this.embedded});

  //factory ProjectCollection.fromJson(Map<String, dynamic> parsedJson){
  //       return ProjectCollection(
   //      embedded: Embedded.fromJson(parsedJson["_embedded"])
   //      );
   //    }
}

class Embedded {
  List<Project> elements;

  Embedded({required this.elements});
  
  //static fromJson(Map<String, dynamic> parsedJson) {
  //  return Embedded(elements: List<Project>.from();
 // }
} */

class Project {
  var description;
  String name;
  int id;

  Project({required this.description, required this.name, required this.id});

  static fromJson(Map<String, dynamic> parsedJson) {
    var description = parsedJson['description'];
    var raw = description['raw'];
    return Project(
        description: raw, name: parsedJson['name'], id: parsedJson['id']);
  }
}
