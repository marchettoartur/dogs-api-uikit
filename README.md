
# Code walk-through

I have created a simple application using MVVM-C in UIKit.
The app has a main home view of HomeListVC which shows a list of breed names fetched using DogsService.

DogsService is a Combine service class which fetches the JSON data and parses it using Codable structs.

When you tap on a breed name, the DetailViewVC is presented by the MainCoordinator.
This class then fetches 10 random images of that breed (sometimes the API returns less than 10).
Inside is a collection view which shows the dog images.
Each collection view cell is responsible for fetching and showing its own image.

Note that the breed names and the breed images are shown in a table view / collection view using a simple array of [String] however this would usually be a ViewModel in MVVM.

# Code test

Congratulations in making it though to the next stage in our process which will be a short take home test! 

Technical Test

You're going to be creating a simple two-screen app that showcases dogs 🐕. 

You should choose your most preferable code architecture, patterns and any libraries you like to use when developing apps (if any). The main goal would be to show your knowledge of clean code architecture and Android/iOS specific design guidelines. iOS candidates should use UIKit (however tempting this might be to experiment with SwiftUI!).
 

📱Specification

The first screen should request a list of dog breeds from the Dogs API (https://dog.ceo/dog-api/) and present the result in a scrolling list.
Tapping a breed from the first list should present the second screen.
The second screen should show 10 random dog images of the selected breed.
Please zip and send the project when you're done, and include a README containing a brief description of your implementation.
✅ Acceptance Criteria

As a user running the application I can select breed from the list So that I can view pictures of that breed

Scenario: Viewing the breed list When I launch the app Then I see a list of dog breeds

Scenario: Viewing pictures of breed Given I have launched the app When I select a breed from the list Then I see 10 images of the breed 

🎨 Making your mark

We'd love to see you make any nice touches that showcase your creative ability, we haven't provided any designs for this reason. However, please remember that the most important thing is that the application works as outlined above and is structured. 
