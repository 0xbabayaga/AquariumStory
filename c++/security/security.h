#ifndef SECURITY_H
#define SECURITY_H

#include <string>

#define MAN_ID_CUT_MD5  7
#define APP_KEY_SEED    77
#define APP_KEY_LENGTH  256

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
    string getCloudKey(string manId, string tm);

private:
    const string possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";;
    unsigned int randomIdLength;
    unsigned int seed;
    unsigned int keyLength;
};

#endif // SECURITY_H
