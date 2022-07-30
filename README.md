# README #

Cadence Mobile App Details

### How to Release new version? ###

* 1)	One file is there under android directory   Named as  key.properties which is not checked in due to security reasons this file needs to be added for building app for release

* 2)	Update following 4 lines to key.properties. 
		storePassword=Tryman2day123
		keyPassword=man2day123
		keyAlias=upload
		storeFile=D:/Flutterrelease/upload-keystore.jks

* 3)	Update version into pubspec.yaml
		version: 1.0.1+3

* 4)	Command to release (ABB format File)
        flutter build appbundle

Built build     \app\outputs\bundle\release\app-release.aab (22.4MB).

F:\codebase\50 cadence\cadence-flutter-app\build\app\outputs\bundle\release



### Notes ###

---Not Needed – as key is already generated. 

To sign in App
    keytool -genkey -v -keystore F:/codebase/50 cadence/cadence-flutter-app/release/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
