#ifndef SECURITY_H
#define SECURITY_H

#include <string>

using namespace std;

class Security
{
public:
    Security(unsigned int r, unsigned int s, unsigned int l)
    {
        randomIdLength = r;
        seed = s;
        keyLength = l;
    };

    ~Security() {};

public:
    string getRandomId();
    bool isKeyValid(char *key, string manId);

private:
    const string possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";;
    unsigned int randomIdLength;
    unsigned int seed;
    unsigned int keyLength;
};

#endif // SECURITY_H
