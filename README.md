Here is my first messenger iChat!
 The original idea belongs to Alexey Parhomenko from SwiftBook,
 but my implementation is different. I'm going to make it better and better!
 You can check up my personal aproaches, features and bug fixes at the end of README 

 Core features:
 - email\google authentication
 - user profile setup 
 - global user search
 - chat requests
 - waiting/active chats
 - real-time chat
 - possibility to send images
 - store user data with Firestore
 - store images with Cloud Storage

 Coming soon:
 - Dark mode
 - PlusButton to input bar
 - Emoji

 ![Auth Screens](https://user-images.githubusercontent.com/102429266/185823056-4731fa18-3065-43db-93c4-943bf4441588.jpg)
 ![setupProfile and userslist](https://user-images.githubusercontent.com/102429266/185823063-63a32473-0ec2-46a4-968f-180a1bfbacf6.jpg)
 ![screen3](https://user-images.githubusercontent.com/102429266/185823070-13935ac4-3cec-45ef-80bf-48ba6b0415cf.jpg)

 Layout:
  - NSLayoutAnchors
  - StackViews
  - CompositionalLayout
  - DiffableDataSource
  - MessageKit layout

 Frameworks and libraries I used:
 - UIKit
 - SwiftUI (Just to use canvas)
 - FirebaseCore
 - FirebaseFirestore
 - FirebaseStorage
 - FirebaseAuth
 - GoogleSignIn
 - MessageKit
 - PhotosUI
 - SDWebImage
 - IQKeyboardManagerSwift

 My fixes:
 - Firebase services works with the new API
 - Fixed to proper collection names in Firebase storage (friendName + currentUserName)
 - Fixed bug with registration via google service (now it checks up if the user is already registered, and he can continue with existing account)
 - TextFields works much better (with IQKeyboardManager and some delegate's methods)
 - Image picking from gallery works with PHPickerViewController instead of deprecated UIImagePickerController
 - Users can have default avatar
 - In chat messages sent date is shown only if the date was changed after previous message
 
 and others...
