#include <bits/stdc++.h>
using namespace std;
const long long MOD = 998244353;
int main() {
    auto digitsum = []<class T>(T a, int N = 10) -> T {
        T ans = 0;
        while (a != 0) {
            ans += a % N;
            a /= N;
        }
        return ans;
    };
    auto divisors = []<class T>(T a) -> vector<T> {
        vector<T> ans;
        for (int i = 1; i * i <= a; i++) {
            if (a % i != 0) continue;
            ans.push_back(i);
            if (a / i != i) ans.push_back(a / i);
        }
        return ans;
    };
    auto is_p = []<class T>(T num) -> bool {
        if (num == 2) return true;
        if (num < 2 || num % 2 == 0) return false;
        double sqrtNum = sqrt(num);
        for (T i = 3; i <= sqrtNum; i += 2) {
            if (num % i == 0) return false;
        }
        return true;
    };
    auto p_fact = []<class T>(T N) -> map<T, int> {
        map<T, int> P;
        for (T i = 2; i * i <= N; i++) {
            while (N % i == 0) {
                P[i]++;
                N /= i;
            }
        }
        if (N > 1) P[N]++;
        return P;
    };
    auto eratosthenes = []<class T>(T N) -> vector<bool> {
        vector<bool> is_P(N + 1, true);
        is_P[0] = is_P[1] = false;
        for (T i = 2; i * i <= N; i++) {
            if (!is_P[i]) continue;
            for (T j = i * i; j <= N; j += i) is_P[j] = false;
        }
        return is_P;
    };
    auto mod_pow = [&]<class T>(T a, T n) -> T {
        T ans = 1;
        while (n > 0) {
            if (n & 1) ans = ans * a % MOD;
            a = a * a % MOD;
            n >>= 1ll;
        }
        return ans;
    };
    auto modinv_fermat = [&](long long a) -> long long {
        return mod_pow(a, MOD - 2);
    };
    vector<long long> mf;
    auto modfact = [&](int x) -> long long {
        if ((int)mf.size() > x) return mf[x];
        if (mf.empty()) mf.push_back(1);
        for (int i = mf.size(); i <= x; i++) mf.push_back(mf.back() * i % MOD);
        return mf[x];
    };
    auto factorial = []<class T>(T N) -> T {
        T ans = 1;
        while (N > 0) ans *= N--;
        return ans;
    };
    auto mod_combination = [&](int n, int k) -> long long {
        return modfact(n) * modinv_fermat(modfact(k)) % MOD *
               modinv_fermat(modfact(n - k)) % MOD;
    };
    const int MAX = 3e5;
    long long fac[MAX], finv[MAX], inv[MAX];
    auto Extended_Euclid_inverse_calc = [&]() -> void {
        fac[0] = fac[1] = finv[0] = finv[1] = inv[1] = 1;
        for (int i = 2; i < MAX; i++) {
            fac[i] = fac[i - 1] * i % MOD;
            inv[i] = MOD - inv[MOD % i] * (MOD / i) % MOD;
            finv[i] = finv[i - 1] * inv[i] % MOD;
        }
    };
    Extended_Euclid_inverse_calc();
    auto nCk = [&](int n, int k) -> long long {
        if (n < k or n < 0 or k < 0) return 0;
        return fac[n] * (finv[k] * finv[n - k] % MOD) % MOD;
    };
}
