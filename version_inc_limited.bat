set /p var= <..\AquariumStory\version_cnt_limited.txt
set /a var= %var%+1 
echo %var% >..\AquariumStory\version_cnt_limited.txt
echo #define APP_VERSION %var% >..\AquariumStory\c++\version.h
echo %var%
set /a v1= %var%/1000000
set /a v2= %var%/1000
set /a v2= v2%%1000
set /a v3= %var%
set /a v3= v3%%1000
powershell -Command "(gc ../aquariumstory/android/androidmanifestlimited.template) -replace '#VERAPP', '%v1%.%v2%.%v3%' | Out-File -encoding UTF8 ../aquariumstory/android/androidmanifest.xmltmp";
ping -n 1 127.0.0.1
powershell -Command "(gc ../aquariumstory/android/androidmanifest.xmltmp) -replace '#VERCODE', '%var%' | Out-File -encoding UTF8 ../aquariumstory/android/androidmanifest.xml";