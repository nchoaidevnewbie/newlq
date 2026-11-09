#include <stdio.h>
#include <stdint.h>
#include <string>

//-------------------------------------------------------------//
// "Các thủ thuật mã độc liên quan đến thời gian biên dịch với C++11" bởi LeFF //
// Bạn có thể sử dụng mã này tùy ý, tôi thực sự không quan tâm, nhưng nếu bạn cảm thấy
// một chút tôn trọng đối với tôi, xin đừng cắt bỏ bình luận này khi sao chép-dán... ;-) //
//-------------------------------------------------------------//

#if defined(_MSC_VER)
#define ALWAYS_INLINE __forceinline
#else 
#define ALWAYS_INLINE __attribute__((always_inline))
#endif
 
// Ví dụ sử dụng:
void setup()    __attribute__((noinline));
void startAuthentication()  __attribute__((noinline));

#ifndef seed
    // Tôi sử dụng thời gian hiện tại (thời gian biên dịch) làm hạt giống
    // Chuyển đổi chuỗi thời gian (hh:mm:ss) thành một số
    constexpr int seedToInt(char c) { return c - '0'; }
    const int seed = seedToInt(__TIME__[7]) +
                     seedToInt(__TIME__[6]) * 10 +
                     seedToInt(__TIME__[4]) * 60 +
                     seedToInt(__TIME__[3]) * 600 +
                     seedToInt(__TIME__[1]) * 3600 +
                     seedToInt(__TIME__[0]) * 36000;
#endif

// Mẫu constantify được sử dụng để đảm bảo rằng kết quả của hàm constexpr
// sẽ được tính toán tại thời gian biên dịch thay vì thời gian chạy
template <uintptr_t Const> struct 
vxCplConstantify { enum { Value = Const }; };

// Mod thời gian biên dịch của bộ tạo số ngẫu nhiên giả tuyến tính, 
// thuật toán thực tế được lấy từ cuốn sách "Numerical Recipes"
constexpr uintptr_t vxCplRandom(uintptr_t Id)
{ return (1013904223 + 1664525 * ((Id > 0) ? (vxCplRandom(Id - 1)) : (/*vxCPLSEED*/seed))) & 0xFFFFFFFF; }

// Macros ngẫu nhiên thời gian biên dịch, có thể được sử dụng để ngẫu nhiên hóa đường dẫn thực thi
// cho các bản build riêng biệt, hoặc tạo mã rác thời gian biên dịch
#define vxRANDOM(Min, Max) (Min + (vxRAND() % (Max - Min + 1)))
#define vxRAND()           (vxCplConstantify<vxCplRandom(__COUNTER__ + 1)>::Value)

// Mod đệ quy thời gian biên dịch của thuật toán băm chuỗi, 
// thuật toán thực tế được lấy từ thư viện Qt (hàm này không phân biệt chữ hoa chữ thường do vxCplTolower)
constexpr char   vxCplTolower(char Ch)                { return (Ch >= 'A' && Ch <= 'Z') ? (Ch - 'A' + 'a') : (Ch); }
constexpr uintptr_t vxCplHashPart3(char Ch, uintptr_t Hash) { return ((Hash << 4) + vxCplTolower(Ch)); }
constexpr uintptr_t vxCplHashPart2(char Ch, uintptr_t Hash) { return (vxCplHashPart3(Ch, Hash) ^ ((vxCplHashPart3(Ch, Hash) & 0xF0000000) >> 23)); }
constexpr uintptr_t vxCplHashPart1(char Ch, uintptr_t Hash) { return (vxCplHashPart2(Ch, Hash) & 0x0FFFFFFF); }
constexpr uintptr_t vxCplHash(const char* Str)           { return (*Str) ? (vxCplHashPart1(*Str, vxCplHash(Str + 1))) : (0); }

// Macro băm thời gian biên dịch, giá trị băm thay đổi sử dụng số ngẫu nhiên đầu tiên trong dãy
#define HASH(Str) (uintptr_t)(vxCplConstantify<vxCplHash(Str)>::Value ^ vxCplConstantify<vxCplRandom(1)>::Value)

// Trình tạo danh sách chỉ số thời gian biên dịch (0, 1, 2, ...)
template <uintptr_t...> struct vxCplIndexList {};
template <typename  IndexList, uintptr_t Right> struct vxCplAppend;
template <uintptr_t... Left,      uintptr_t Right> struct vxCplAppend<vxCplIndexList<Left...>, Right> { typedef vxCplIndexList<Left..., Right> Result; };
template <uintptr_t N> struct vxCplIndexes { typedef typename vxCplAppend<typename vxCplIndexes<N - 1>::Result, N - 1>::Result Result; };
template <> struct vxCplIndexes<0> { typedef vxCplIndexList<> Result; };

// Mã hóa chuỗi thời gian biên dịch của một ký tự đơn
constexpr char vxCplEncryptCharKey = (const char)vxRANDOM(0, 0xFF);

constexpr char ALWAYS_INLINE vxCplEncryptChar(const char Ch, uintptr_t Idx) { return Ch ^ (vxCplEncryptCharKey + Idx); }

constexpr char multiLayerEncryptChar(const char Ch, uintptr_t Idx) {
    return Ch ^ (vxCplEncryptCharKey + Idx) ^ (vxCplEncryptCharKey * 3 - Idx) ^ (vxCplEncryptCharKey * Idx);
}

// Lớp mã hóa chuỗi thời gian biên dịch
template <typename IndexList> struct vxCplEncryptedString;
template <uintptr_t... Idx> struct vxCplEncryptedString<vxCplIndexList<Idx...> >
{
    char Value[sizeof...(Idx) + 1]; // Bộ đệm cho chuỗi

    // Constructor thời gian biên dịch
    constexpr ALWAYS_INLINE vxCplEncryptedString(const char* const Str)  
    : Value{ multiLayerEncryptChar(Str[Idx], Idx)... } {}

    // Giải mã thời gian chạy
    inline const char* decrypt()
    {
        for(uintptr_t t = 0; t < sizeof...(Idx); t++)
        { this->Value[t] = multiLayerEncryptChar(this->Value[t], t); }
        this->Value[sizeof...(Idx)] = '\0'; return this->Value;
    }
};

// Macro mã hóa chuỗi thời gian biên dịch
#define ENCRYPT(Str) (vxCplEncryptedString<vxCplIndexes<sizeof(Str) - 1>::Result>(Str).decrypt())

#ifdef __APPLE__
// Macro mã hóa chuỗi Objective-C thời gian biên dịch
#define NSSENCRYPT(Str) @(ENCRYPT(Str))
#endif

// Macro mã hóa chuỗi bù thời gian biên dịch, chuyển đổi lại thành uint64_t.
#define ENCRYPTOFFSET(Str) strtoull(ENCRYPT(Str), NULL, 0)

// Macro mã hóa chuỗi hex thời gian biên dịch, thực hiện tương tự như ENCRYPT, nhưng tên rõ ràng hơn.
#define ENCRYPTHEX(Str) ENCRYPT(Str)