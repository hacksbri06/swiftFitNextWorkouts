import SwiftUI



struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedWorkoutType = "All" // New state for selected workout type
    @State private var workoutPlan: [Exercise] = []
    @State private var totalDuration = 15 // Total duration in minutes
    
    var filteredMoves: [WorkoutMove] {
        if searchText.isEmpty && selectedWorkoutType == "All" {
            return data
        } else {
            return data.filter { move in
                (searchText.isEmpty || move.name.localizedCaseInsensitiveContains(searchText)) &&
                (selectedWorkoutType == "All" || move.workoutType == selectedWorkoutType)
            }
        }
    }
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
        
            TabView(selection: $selectedTab) {
                // First Tab
                WorkoutListView(filteredMoves: filteredMoves, searchText: $searchText, selectedWorkoutType: $selectedWorkoutType)
                    .tabItem {
                        //Image(systemName: "1.circle")
                        Image(systemName: "figure.walk")

                        Text("Workouts")
                    }
                    .tag(0)




                
                // Second Tab
           
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("Tab 2")
                    }
                    .tag(1)
                
                // Third Tab
                ThirdTabView(workoutPlan: $workoutPlan, generateWorkoutPlan: generateWorkoutPlan)
                    .tabItem {
                        //Image(systemName: "3.circle")
                        Image(systemName: "list.bullet")
                        Text("Your Plan")
                    }
                    .tag(2)
            }
            .accentColor(.blue) // Change the color of the selected tab indicator
            .background(Color.white) // Set the background color of the tab bar
        }
    }
    
    // Function to select a random exercise from the provided array
    func generateWorkoutPlan() {
        var plan: [Exercise] = []
        
        let legsExercise = selectRandomExercise(from: createExercises(from: legsExercises, withImagesFrom: legsImages))
        let armsExercise = selectRandomExercise(from: createExercises(from: armsExercises, withImagesFrom: armsImages))
        let coreExercise = selectRandomExercise(from: createExercises(from: coreExercises, withImagesFrom: coreImages))

        
        // Append the selected exercises to the plan
        plan.append(legsExercise)
        plan.append(armsExercise)
        plan.append(coreExercise)
        
        // Update the workout plan
        workoutPlan = plan
    }
    // Sample image URLs for each category
    let legsImages = ["smith-squat-glute", "smith-single-squat-glute", "smith-rdl-angle-copy", "smith-hipthrust-down", "squat-quad-copy", "single-sqaut-quad"]
    let armsImages = ["shoudler-raises-pull-copy", "hammercurl", "bicepcurl-pull", "shoulderpress-push", "lat-pulldown", "https://hacksisombath.com/workouts/chinup-pull.jpg"]
    let coreImages = ["weighted-marches", "hanging-core-crunches", "inverse-crunches"]
    
    // Function to select a random exercise from the provided array and assign a random image
    func selectRandomExercise(from exercises: [Exercise], withImagesFrom images: [String]) -> Exercise {
        let randomIndex = Int.random(in: 0..<exercises.count)
        let randomImageIndex = Int.random(in: 0..<images.count)
        return Exercise(name: exercises[randomIndex].name, imageName: images[randomImageIndex])
    }
    
    // WorkoutListView content
    struct WorkoutListView: View {
        var filteredMoves: [WorkoutMove]
        @Binding var searchText: String
        @Binding var selectedWorkoutType: String
        
        var body: some View {
            List(filteredMoves) { move in
                NavigationLink(destination: DetailView(move: move)) {
                    MoveRow(move: move)
                }
            }
            .searchable(text: $searchText) // Add searchable modifier to enable search
            .navigationTitle("Workout Moves")
            .navigationBarItems(trailing:
                                    Picker("Workout Type", selection: $selectedWorkoutType) {
                Text("All").tag("All")
                Text("Legs").tag("Legs")
                Text("Arms").tag("Arms")
                Text("Core").tag("Core")
            }
                .pickerStyle(SegmentedPickerStyle())
            )
            .background(Color.blue.opacity(0.1)) // Set the background color of the VStack
        }
    }
    
    // MoveRow content
    struct MoveRow: View {
        let move: WorkoutMove
        
        var body: some View {
            HStack {
                // Use conditional statement to check if the imageName is a URL or a local image name
                if let url = URL(string: move.imageName), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                } else {
                    Image(move.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                }
                VStack(alignment: .leading) {
                    Text(move.name)
                        .font(.headline)
                    Text(move.workoutType)
                        .font(.subheadline)
                }
            }
        }
    }
    
    // DetailView content
    struct DetailView: View {
        let move: WorkoutMove
        
        var body: some View {
            VStack {
                // Use conditional statement to check if the imageName is a URL or a local image name
                if let url = URL(string: move.imageName), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                } else {
                    Image(move.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                }
                Text("Workout Type: \(move.workoutType)")
                    .font(.subheadline)
                Text("Description: \(move.description)")
                    .font(.subheadline)
                    .padding(10)
                
            }
            .navigationTitle(move.name)
            
        }
    }
    
    
    // Struct for WorkoutMove
    struct WorkoutMove: Identifiable {
        let id = UUID()
        let name: String
        let workoutType: String
        let imageName: String
        let description: String
        var completed: Bool // Added completed property
    }
    
    // Sample data
    let data = [
        WorkoutMove(name: "Smith Machine Back Squat", workoutType: "Legs", imageName: "smith-squat-glute", description: "This glute focused workout using the smith machine done by placing the bar shoulder height above you. You will set your feet shoulder width apart as your feet are half a step in front of you. Let the bar rest on top of the shoulders as you squat down, engage your glutes as you push the weight up through your heels.", completed: false),
        WorkoutMove(name: "Single-Legged Squat", workoutType: "Legs", imageName: "smith-single-squat-glute", description: "This glute focused workout using the smith machine.", completed: false),
        WorkoutMove(name: "Russian Dead Lift", workoutType: "Legs", imageName: "smith-rdl-angle-copy", description: "This glute focused workout using the smith machine. Have your feet shoulder width apart, chin tucked, hinge your hips backwards while keeping your back straight and let the bar pass slightly below your knees. Engage your glues and core as you pull the bar up, using the glutes to come forward to starting position.", completed: false),
        WorkoutMove(name: "Hip Thrusts", workoutType: "Legs", imageName: "smith-hipthrust-down", description: "With your shoulders set against a bench, align the bar on your hips, feet turned down hip-width apart, tuck your chin in as you push the weight through the back of your heels. Arch your back as you are coming down, keeping the chin tucked.", completed: false),
        WorkoutMove(name: "Dumbbells Squat", workoutType: "Legs", imageName: "squat-quad-copy", description: "This quad focused workout using the smith machine.", completed: false),
        WorkoutMove(name: "Dumbbells Single Legged Squat", workoutType: "Legs", imageName: "single-sqaut-quad", description: "This quad focused workout using the smith machine.", completed: false),
        WorkoutMove(name: "Smith Machine Shoulder Raises", workoutType: "Arms", imageName: "shoudler-raises-pull-copy", description: "Hold the bar with your knuckles facing each other, keeping your elbows boxed out vertically above the bar. Set the bar at waist height and engage your shoulders to pull slightly below your chest, creating a 90-degree angle with your elbows.", completed: false),
        WorkoutMove(name: "Hammer Curl", workoutType: "Arms", imageName: "hammercurl", description: "Box out both arms. Using a dumbbell, hold it to where your thumbs are facing toward you. Motion the dumbbell only moving through past your bicep. As if you are scrubbing your torso, keep your elbow aligned with the side of your body.", completed: false),
        WorkoutMove(name: "Bicep Curls", workoutType: "Arms", imageName: "bicepcurl-pull", description: "Hold the dumbbell horizontally, keep elbow still as you pull the bar towards your bicep and leverage down to a 90 degree.", completed: false),
        WorkoutMove(name: "Overhead Shoulder Press", workoutType: "Arms", imageName: "shoulderpress-push", description: "Straighten your back against the seat and have your arms parallel to each other. Engage your core and shoulder muscles, as you push up and slowly come down.", completed: false),
        WorkoutMove(name: "Lat Pull-Downs", workoutType: "Arms", imageName: "lat-pulldown", description: "Pull your shoulders back to engage your back, arms, and core to pull down while keeping arms boxed out. Keep your back from arching by tucking your tailbone in while tucking your chin down to avoid strain.", completed: false),
        WorkoutMove(name: "Chin-Ups", workoutType: "Arms", imageName: "chinup-pull", description: "Pull your shoulders back to engage your back, arms, and core to pull yourself up without jumping or pushing off from the stand.", completed: false),
        WorkoutMove(name: "Weighted Standing Crunches", workoutType: "Core", imageName: "weighted-marches", description: "Grab a chosen weight, holding it close to your chest, pull one knee at 90 degrees and alternate at a slow pace.", completed: false),
        WorkoutMove(name: "(Hanging) Crunches", workoutType: "Core", imageName: "hanging-core-crunches", description: "Keep tailbone tucked and back against the padding as your bring up either one or both legs.", completed: false),
        WorkoutMove(name: "Weight Incline Sit-Ups", workoutType: "Core", imageName: "inverse-crunches", description: "Keep tailbone and chin tucked as you engage your core to do this weighted sit-up. Choose a weight of your choice, either a dumbbell or plate, and engage your core to pull yourself up the incline.", completed: false)
    ]
    
    //END OF TAB 1
    
    
    
    
    
    
    //TAB 3 YOUR WORKOUTS
    // Define exercise pool
    let legsExercises = ["Smith Machine Back Squat", "Single-Legged Squat", "Hip Thrusts", "Dumbbells Squat", "Dumbbells Single Legged Squat"]
    let armsExercises = ["Smith Machine Shoulder Raises", "Hammer Curl", "Bicep Curls", "Overhead Shoulder Press", "Lat Pull-Downs", "Chin-Ups"]
    let coreExercises = ["Weighted Standing Crunches", "(Hanging) Crunches", "Weight Incline Sit-Ups"]
    
    
    // Function to select a random exercise from the provided array
    // Struct to represent an exercise
    struct Exercise: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String // Add imageName property
    }
    
    // Struct to represent an exercise group
    struct ExerciseGroup {
        let name: String
        let exercises: [Exercise]
    }
    
    // Function to create Exercise instances from an array of exercise names
    func createExercises(from names: [String], withImagesFrom images: [String]) -> [Exercise] {
        return zip(names, images).map { Exercise(name: $0, imageName: $1) }
    }
    
    
    // Function to select a random exercise from the provided array
    func selectRandomExercise(from exercises: [Exercise]) -> Exercise {
        let randomIndex = Int.random(in: 0..<exercises.count)
        return exercises[randomIndex]
    }
    
    struct ThirdTabView: View {
        @Binding var workoutPlan: [Exercise]
        var generateWorkoutPlan: () -> Void
        
        var body: some View {
            VStack {
                // Button to generate workout plan
                Button("Generate Workout Plan") {
                    generateWorkoutPlan()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.pink)
                .cornerRadius(8)
                // List of exercises
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(workoutPlan) { exercise in
                            ExerciseCard(exercise: exercise)
                                .padding(.horizontal)
                        }
                    }
                   
                }
            }
            .navigationTitle("Your Workout Plan")
            .background(Color.blue.opacity(0.1))  // Add background color to the ScrollView
        }
    }

    struct ExerciseCard: View {
        let exercise: Exercise
        
        var body: some View {
            VStack(alignment: .leading) {
                if let uiImage = UIImage(named: exercise.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                Text(exercise.name)
                    .font(.headline)
                    .padding(.top, 5)
                Divider() // Add divider between image and text
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }

    
    
    
    // Preview
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}
