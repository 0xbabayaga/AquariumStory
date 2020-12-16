#include "security.h"
#include <sys/time.h>
#include "md7.h"

string Security::getRandomId()
{
    unsigned int i = 0;
    string randId = "";
    struct timeval tp = {};
    long int ms = 0;
    int index = 0;
    char nextChar = 0;

    for(i = 0; i < randomIdLength; ++i)
    {
        gettimeofday(&tp, NULL);
        ms = tp.tv_sec * 1000 + tp.tv_usec / 1000;
        index = rand() * ms;
        index = index % possibleCharacters.length();
        nextChar = possibleCharacters.at(index);
        randId.append(&nextChar, 1);
    }

    return randId;
}

bool Security::isKeyValid(char *key, string manId)
{
    string tmp = "";
    int i = 0;
    string id = manId;

    while (tmp.length() < keyLength)
    {
        tmp += md7(id.c_str()).c_str();
        id += to_string(i);
        i += seed;
    }

    return (tmp == key);
}
