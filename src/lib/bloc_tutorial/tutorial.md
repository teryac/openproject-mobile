# Create new feature with Cubit.

### A. Create feature layers:
Each feature has 1 primary layer & 3 additional layers:
#### 1. **Presentation Layer (Primary Layer)**:
- This layer hold all the UI componenets and state management.
- This layer separates the UI from state management into two folders:
    - UI (Can also be divided into `screens` & `widgets` to make widgets smaller and avoid complex widget trees).
    - Cubits.

#### 2. Models Layer:
- This layer contains all model classes.

#### 3. Data Layer:
- This layer gets raw data from external data sources (like an API), and returns a model from the models layer.

#### 4. Application Layer:
- This is an optional layer used to manage cubits functioning with each other and handle stateless logic which can't be put directly in the widget tree to avoid mixing UI and logic.


### B. Add files:

#### 1. Presentation Layer:
- **Cubits:** For each stateful variable, you create a new cubit, a stateful variable is any variable that can change and is related to how the UI looks, some examples may include:
    - isFavorite: favorite product tiles usually have a heart icon next to them, this heart is filled when isFavorite is true, and becomes unfilled (outlined) when isFavorite is false.
    - Projects List: In this app, the list of projects is fetched from an external API -which takes time to get data from-, therefore, while waiting for the projects to arrive from the API, the projects list is `null`, which means the UI should show some form of loading view, and once the data arrives, the UI views the project in response to the projects list variable becomming not null, and having actual data.

The cubit class for an isFavorite boolean might look like this:
```dart
class FavoiteCubit extends Cubit<bool> {
  // Default value is `false`
  FavoiteCubit() : super(false);

  void toggleFavorite() {
    // `emit` means: send a message to all UI components that are
    // waiting for a change in this cubit to update themselves
    // based on the new value they recieved from this cubit

    // state: it's the value that the cubit currently holds, in
    // this case a boolean which indicates if the product is favorite
    // or not.

    // Note: The exclamation mark is a way to reverse a boolean

    // Result:
    // `emit(state);` ------> Send a new value with the opposite
    // of whate the current favorite state is.
    // Example:
    // `state` is currently `true` (The product is favorite),
    // When toggleFavorite() is run, `state` becomes `false` and
    // The UI listeners recieve the change which updates the UI.
    emit(!state);
  }
}
```

- **UI:** As for the UI, it's basically how every Flutter widget is created, this architecture doesn't force any changes to the widgets.

  However, using the bloc/cubit inside the widget tree needs some instructions:
  - Since the cubit is injected into the `BuildContext` (refer to topic "D. How to use with GoRouter"), you can use the cubit directly from the `BuildContext` like this:

    ```dart
    context.read<ExampleCubit>();
    ```
  This returns the instance of ExampleCubit, so you can run it's functions or access its state like this:
  ```dart
    context.read<ExampleCubit>().runExampleFunction();
    context.read<ExampleCubit>().state;
    ```
  - To Build UI based on the changes of some cubit value, you can use the BlocBuilder widget like this:
  ```dart
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExampleCubit, ExampleCubitValueType>(
      builder: (context, state) {
        // `state` is of type ExampleCubitValueType
        // that's the type of value you specify in 
        // the cubit class, it could be an integer
        // for a counter, a list of projects, etc.
        return ExampleWidget(data: state, ...);
      },
    );
  }
  ```

  This is a counter app example:
  ```dart
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, int>(
      builder: (context, state) {
        return Text('Value: $state');
      },
    );
  }
  ```

#### 2. Models Layer:
No additional changes needed, here's a basic example:
```dart
class Project {
  final String id;
  final String name;
  final int tasksCount;

  Project({
    required this.id,
    required this.name,
    required this.tasksCount,
  });
}
```

#### 3. Data Layer:
Files in the data layer are usually called "Repos" (the plural form of "Repo", referring to "Repository"), and these files hold the feature name (e.g. `HomeRepo`, if placed inside a `Home` feature),and it looks something like this:
```dart
class ProjectsRepo {
  List<Project> getProjects() {
    // Get data from external sources here...

    final projects = [
      Project(id: 'ds4mds94ms', name: 'Scrum Project', tasksCount: 3),
      Project(id: 'a0ffmw0axi', name: 'Basic Project', tasksCount: 6),
      Project(id: '0axomapdsk', name: 'Final Project', tasksCount: 2),
    ];

    return projects;
  }
}
```

But `getProjects()` is a synchronous function, and that's not usually the case in real projects because data is usually fetched from an API, so a more realistic example is something like this:
```dart
class ProjectsRepo {
  Future<List<Project>> getProjects() async {

    final projects = await http.get('example API');

    return projects;
  }
}
```

#### 4. Application Layer:
This contains one file that holds the feature name (e.g. `HomeController`), and they manage logic in unrestricted way, use the controller whenever there is a need to put some logic that has no other place to be put in (Don't place logic inside Presentation layer under the UI sub-layer).
This is an example from the current project:
```dart
class BlocTutorialController {
  const BlocTutorialController();

  DateTime? getProjectDeadline(List<WorkPackage> projectWorkPackages) {
    // TODO: Retrieve all work package deadlines as `DateTime` objects
    // TODO: Find the latest date
    // TODO: If no date is found, return null
    // TODO: Otherwise, return the last date
  }
}
```

There is another case, where two cubits need to be linked to each other, here's an example:
```dart
class HomeController {
  final CubitA cubitA;
  final CubitB cubitB;
  BlocTutorialController({
    required this.cubitA,
    required this.cubitB,
  }) {
    cubitA.stream.listen(
      (event) {
        // Example
        if (event == 'connected') {
          cubitB.performSomeFunction();
        }
      },
    );
  }
}
```

To access the controller from the UI, you can use `BuildContext` since it's injected into the the `BuildContext` -you can also get the feature repo but typically you only use it inside the cubit- (refer to topic "D. How to use with GoRouter"), this is an example:
```dart
context.read<ExampleController>();
```

### C. Connecting Layers:
It all starts from the UI layer, a user makes an interaction, a button is pressed to get products from an API, the button press toggles a function in the cubit to get the products, the cubit emits a loading state while it forwards the request to the data layer to get the data from the datasources (API), the data layer returns a model from the models layer, and passes it back to the cubit, finally, the cubit emits a state indicating the success of the request with the data provided in the cubit state object.
<br><br>
Here's a summary of what happens:

UI ⇄ Cubit ⇄ Data Layer ⇄ Models<br>
⬑ Response & State Emission ⬏


### D. How to use with GoRouter:
Here's a full example of how to connect to GoRouter and inject everything needed into the `BuildContext`:
```dart
GoRoute(
  path: ...,
  name: ...,
  builder: (context, state) => MultiBlocProvider(
    providers: [
      // For cubits, use `BlocProvider`.
      // For anything else, use `RepositoryProvider`.

      RepositoryProvider(
        create: (_) => ExampleRepo(),
      ),
      BlocProvider(
        create: (context) => ExampleCubit(repo: context.read<ExampleRepo>()),
      ),
      RepositoryProvider(
        create: (context) => ExampleController(
          cubit: context.read<ExampleCubit>(),
          ...
        ),
      ),
    ],
    child: const ExampleScreen(),
  ),
),
```

### E. Final overview:
The final folder structure should look like this:  
```
lib/
└── features/
    └── example_feature/
        ├── presentation/              # 🟡 Presentation Layer (Primary)
        │   ├── ui/
        │   │   ├── screens/
        │   │   │   └── example_screen.dart
        │   │   └── widgets/
        │   │       └── example_widget.dart
        │   └── cubits/
        │       └── example_cubit.dart
        │
        ├── models/                    # 🟢 Models Layer
        │   └── example_model.dart
        │
        ├── data/                      # 🔵 Data Layer
        │   └── example_repo.dart
        │
        └── application/               # 🟠 Application Layer (Optional)
            └── example_controller.dart
```

<br>

**Legend**:
- 🟡 Presentation Layer → UI & Cubits

- 🟢 Models Layer → Data models

- 🔵 Data Layer → Repositories (API/Data sources)

- 🟠 Application Layer → Controllers & shared logic