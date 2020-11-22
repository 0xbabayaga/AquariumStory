set /p var= <..\AquariumStory\version_cnt.txt
set /a var= %var%+1 
echo %var% >..\AquariumStory\version_cnt.txt
echo #define APP_VERSION %var% >..\AquariumStory\c++\version.h
echo %var%