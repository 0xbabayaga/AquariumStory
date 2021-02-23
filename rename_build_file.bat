set /p var= <..\AquariumStory\version_cnt.txt
set /a var= %var%+1 
set /a var= %var%-1 
cd android-build\build\outputs\apk\release
copy "android-build-release-signed.apk" "..\..\..\..\..\..\AquariumStory/AquariumStoryPro_v%var%.apk"