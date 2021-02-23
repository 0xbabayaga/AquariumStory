set /p var= <..\AquariumStory\version_cnt.txt
set /a var= %var%+1 
set /a var= %var%-1 
cd android-build\build\outputs\bundle\release
copy "android-build-release.aab" "..\..\..\..\..\..\AquariumStory/AquariumStoryPro_v%var%.aab"