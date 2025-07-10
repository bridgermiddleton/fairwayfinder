FairwayFinder 🏌️‍♂️
A Flutter-based mobile application for discovering and reviewing golf courses. Find courses near you, build your wishlist, and share reviews with the golf community.
Features
🗺️ Course Discovery

Location-based Search: Find golf courses near your current location
City/State Search: Search for courses in specific cities and states
Interactive Map: View courses on Google Maps with custom markers
Course Details: Get comprehensive information about each golf course

👤 User Profiles

Firebase Authentication: Secure user registration and login
Personal Wishlist: Save favorite courses for future visits
Review System: Write and read reviews for golf courses
Profile Pictures: Upload and manage profile photos via Firebase Storage

📱 Cross-Platform Support

iOS, Android, Web, macOS, Windows, and Linux compatibility
Responsive design for various screen sizes

Tech Stack

Framework: Flutter 3.19.4
Backend: Firebase (Authentication, Firestore, Storage)
Maps: Google Maps API with Places API
Location Services: GPS location tracking
State Management: Built-in Flutter state management
Image Handling: Image picker for profile photos

Prerequisites
Before running this application, ensure you have:

Flutter SDK (3.19.4 or later)
Google Cloud API Key with the following APIs enabled:

Google Maps SDK
Google Places API


Firebase Project with:

Authentication enabled
Firestore database
Storage bucket



Installation & Setup
1. Clone the Repository
bashgit clone <repository-url>
cd fairwayfinder
2. Install Dependencies
bashflutter pub get
3. Configure Google Maps API
For Android (android/app/src/main/AndroidManifest.xml):
xml<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
For iOS (ios/Runner/Info.plist):
xml<key>GoogleMapsApiKey</key>
<string>YOUR_API_KEY_HERE</string>
For Dart code (lib/screens/home_page.dart):
Add your API key to the Google Maps API calls in the _searchNearbyGolfCourses method.
4. Configure Firebase

Create a new Firebase project at Firebase Console
Add your app for each platform you plan to support
Download and place configuration files:

google-services.json in android/app/
GoogleService-Info.plist in ios/Runner/


Update the Firebase configuration in lib/firebase_options.dart with your project details

5. Run the Application
bashflutter run
Usage
Getting Started

Launch the app and create an account or sign in
Grant location permissions when prompted for the best experience
Search for courses using either:

"Find Courses Near Me" for location-based discovery
City and state search for specific areas



Discovering Courses

Tap map markers to see course names
Tap course names to view detailed information
Add to wishlist by tapping the star icon
Write reviews to share your experience

Managing Your Profile

Tap the profile icon in the top-right corner
Upload a profile picture by tapping the default avatar
View your wishlist and tap courses to revisit their details
See your review history in the profile section

Project Structure
lib/
├── models/          # Data models (Course, Review, User)
├── screens/         # UI screens (Login, Home, Profile, Course Details)
├── services/        # Business logic (Authentication, API config)
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
API Dependencies
This app integrates with several external services:

Google Maps Platform: For map display and place search
Firebase Auth: User authentication and management
Cloud Firestore: Real-time database for courses and reviews
Firebase Storage: Profile picture storage

Known Limitations

The app requires active internet connection for course discovery and map functionality
Location permissions are required for "Find Courses Near Me" feature
Review system is community-based and not moderated

Contributing

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

Support
For issues and questions:

Check the Issues section
Review the Firebase and Google Maps documentation
Ensure all API keys are properly configured

References

ChatGPT by OpenAI - Development assistance
Firebase Documentation - Backend services
Google Cloud Platform - Maps and Places APIs
Flutter Documentation - Framework guidance


Enjoy discovering your next favorite golf course with FairwayFinder! ⛳
