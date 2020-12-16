#ifndef MD7_H
#define MD7_H

#include <cstring>
#include <iostream>

class MD7
{
public:
    MD7();
    MD7(const std::string& text);

    enum { blockSize = 64 };

public:
    void update(const unsigned char *buf, unsigned int length);
    void update(const char *buf, unsigned int length);

    MD7& finalize();
    std::string hexdigest() const;
    friend std::ostream& operator<<(std::ostream&, MD7 md7);

private:
    void init();

    void transform(const unsigned char block[blockSize]);

    static void decode(unsigned int output[], const unsigned char input[], unsigned int len);
    static void encode(unsigned char output[], const unsigned int input[], unsigned int len);
    static inline unsigned int F(unsigned int x, unsigned int y, unsigned int z);
    static inline unsigned int G(unsigned int x, unsigned int y, unsigned int z);
    static inline unsigned int H(unsigned int x, unsigned int y, unsigned int z);
    static inline unsigned int I(unsigned int x, unsigned int y, unsigned int z);
    static inline unsigned int rotate_left(unsigned int x, int n);
    static inline void FF(unsigned int &a, unsigned int b, unsigned int c, unsigned int d, unsigned int x, unsigned int s, unsigned int ac);
    static inline void GG(unsigned int &a, unsigned int b, unsigned int c, unsigned int d, unsigned int x, unsigned int s, unsigned int ac);
    static inline void HH(unsigned int &a, unsigned int b, unsigned int c, unsigned int d, unsigned int x, unsigned int s, unsigned int ac);
    static inline void II(unsigned int &a, unsigned int b, unsigned int c, unsigned int d, unsigned int x, unsigned int s, unsigned int ac);

    bool finalized;
    unsigned char buffer[blockSize];
    unsigned int count[2];
    unsigned int state[4];
    unsigned char digest[16];
};

std::string md7(const std::string str);

#endif
