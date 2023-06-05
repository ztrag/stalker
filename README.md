# stalker

Find someone.

## Getting Started

## TODO
FirebaseStorage.instance.ref('z1.png').getDownloadURL().then((value) => print('url [$value]'));

Profile Settings
1. ProfileSettingsPage.
2. Set/Change Profile Picture button.
3. Set/Change Name button.

### Name
1. UI -> query name.
2. Store in DB.
3. Upload to firebase. `token.hashcode-name`
4. Fetch and cache after adding stalk target.

### Profile Picture
1. ImagePicker -> Select from gallery.
2. Compress image -> Scale to 1024x1024.
3. Process background to transparent.
4. Compress image -> Scale to 256x256.
5. Upload to firebase. `token.hashCode-icon`
6. Fetch and cache link after adding stalk target.

### Chat
. Chat Model / db.
. Chat Protocol -> Send/receive and store in db.
. ChatPage -> Launch from home.
. ChatPage appBar -> Go to MagPage.
. ChatPage chats -> Show chat history
. HomePage -> Show last message.

### MapPage
. Stalk button.

###TODO Background/Notification
. Test background fcm.
