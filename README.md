/**\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***\*\*\***\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***

- REFERENCES
- Title: ChatGPT
- Author: OpenAI
- Date: 2021
- URL: https://chat.openai.com/

- Title: Firebase
- Author: Google
- URL: https://firebase.google.com/
-
-
- Title: Google Cloud Platform
- Author: Google
- URL: https://console.cloud.google.com/welcome?project=perfect-spanner-418521
- **\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***?\*/

```

```

// KEY NOTES ABOUT THE APP
//First, you need to have an API for Google Cloud. I use Google Maps and the Places API. I also use Firebase for the database and authentication. I wasn't sure if you needed my specific API for the Firestore database and Firebase authentication, so I left it in there just in case. However, the Google Cloud API must be hard-coded where it says to place it.  This should only be in the AndroidManifest.xml file, the GoogleService-Info.plist file, the Info.plist file, and the home_page.dart file where specified. I attempted at making it dynamic but had trouble getting it to work properly.  Please ignore the config.json file, as I could not get it to work as needed. I understand there may be a penalty for this, apologies. So yes, Google Cloud, Firestore, Firebase, and Cloud Storage all are used in this app. Once you login, it is self-explanatory. You can search a city and state, and it will put pins on all of the golf courses in the area, or you can click Find Courses Near Me and it will show all courses near you (if you allowed location permissions). If you click a pin, it will show the course's name. If you click the name, it will send you to a Course Details page. Here, you can add the course to your wish list by clicking the star icon, or you can write / see people's reviews. If you click the profile picture icon in the App Bar, you will be directed to your profile. It has your email, your wishlist, your reviews, and then initially an empty profile picture. If you click the profile picture, you can add one.  You can click a course in your wishlist and it will also take you to that course's CourseDetails page.  That is pretty much it! I hope you enjoy, I really liked making this app and I hope you find it enjoyable.
