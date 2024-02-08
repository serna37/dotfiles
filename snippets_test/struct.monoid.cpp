#include <bits/stdc++.h>
using namespace std;
template <class T> constexpr T inf = 0;
template <> constexpr int inf<int> = 1001001001;
template <> constexpr long long inf<long long> = 1001001001001001001ll;
template <typename T> struct Mmin {
    using value_type = T;
    static constexpr T e = inf<T>;
    static constexpr T op(const T &x, const T &y) noexcept {
        return min(x, y);
    }
};
// template <class T> constexpr T inf = 0;
// template <> constexpr int inf<int> = 1001001001;
// template <> constexpr long long inf<long long> = 1001001001001001001ll;
template <typename T> struct Mmax {
    using value_type = T;
    static constexpr T e = -inf<T>;
    static constexpr T op(const T &x, const T &y) noexcept {
        return max(x, y);
    }
};
template <typename T> struct Madd {
    using value_type = T;
    static constexpr T e = 0;
    static constexpr T op(const T &x, const T &y) noexcept {
        return x + y;
    }
};
template <typename T> struct Mprod {
    using value_type = T;
    static constexpr T e = 1;
    static constexpr T op(const T &x, const T &y) noexcept {
        return x * y;
    }
};
template <typename T> struct Mgcd {
    using value_type = T;
    static constexpr T e = 1;
    static constexpr T op(const T &x, const T &y) noexcept {
        return gcd(x, y);
    }
};
template <typename T> struct MAsumadd {
    using M_m = Madd<T>;
    using M_a = Madd<T>;
    using M = typename M_m::value_type;
    using A = typename M_a::value_type;
    static constexpr M act(const M &m, const A &a, const long long &size) {
        return m + a * T(size);
    }
};
template <typename T> struct MAminadd {
    using M_m = Mmin<T>;
    using M_a = Madd<T>;
    using M = typename M_m::value_type;
    using A = typename M_a::value_type;
    static constexpr M act(const M &m, const A &a, const long long &size) {
        (void)size; // unused
        return m == inf<T> ? m : m + a;
    }
};
int main() {
    Mmin<int> a;
    Mmax<int> b;
    Madd<int> c;
    Mprod<int> d;
    Mgcd<int> e;
    MAsumadd<int> f;
    MAminadd<int> g;
}
