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
  int id;
  String name;

  Project({required this.id, required this.name});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Project(id: parsedJson['id'], name: parsedJson['name']);
  }
}
