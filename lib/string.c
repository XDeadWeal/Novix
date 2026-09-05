void* memcpy(void* dest, const void* src, size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    for (size_t i = 0; i < n; i++) d[i] = s[i];
    return dest;
}

void* memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    for (size_t i = 0; i < n; i++) p[i] = (char)c;
    return s;
}

char* strcpy(char* dest, const char* src) {
    int i = 0;
    while (src[i] != 0) { dest[i] = src[i]; i++; }
    dest[i] = 0;
    return dest;
}

char* strcat(char* dest, const char* src) {
    int i = 0, j = 0;
    while (dest[i] != 0) i++;
    while (src[j] != 0) { dest[i + j] = src[j]; j++; }
    dest[i + j] = 0;
    return dest;
}

int strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) { s1++; s2++; }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

size_t strlen(const char* s) {
    size_t len = 0;
    while (s[len] != 0) len++;
    return len;
}

char* strchr(const char* s, int c) {
    while (*s != (char)c) { if (*s == 0) return 0; s++; }
    return (char*)s;
}