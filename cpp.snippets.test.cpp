// =========================================================
// Template
// =========================================================
// www
#include <bits/stdc++.h>
using namespace std;
// func
void func(int n) {
}
int main() {
    int N = 5;
    // =========================================================
    // grammer
    // =========================================================
    // fori
    for (int i = 0; i < N; i++) {
    }
    // fori_re
    for (int i = N - 1; i >= 0; i--) {
    }
    // forv
    vector<int> A(N);
    for (auto &v : A) {
    }
    // for2
    vector<vector<int>> B(N, vector<int>(N));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
        }
    }
    // func_lambda
    auto lamda = [&](int a) -> void {

    };
    // func_lambda_recursive
    auto recersive = [&](auto self, int a) -> void {
        self(self, 0); // recursive
    };
    // =========================================================
    // type
    // =========================================================
    // ll
    long long a;
    // dou
    double b;
    // vec
    vector<int> c;
    // st
    set<int> d;
    // mul
    multiset<int> e;
    // mp
    map<int, int> f;
    // pp
    pair<int, int> g;
    // tu
    tuple<> h;
    // sta
    stack<int> i;
    // qu
    queue<int> j;
    // pri
    priority_queue<int> k;
    // =========================================================
    // const
    // =========================================================
    // ww_const_PI
    const double PI = acos(-1);
    // ww_const_INFINITY_INT
    const int INF = 1001001001;
    // ww_const_INFINITY_LONG
    const long long aINF = 1001001001001001001ll;
    // ww_const_MOD_998244353
    const long long MOD = 998244353;
    // ww_const_MOD_100000007
    const long long aMOD = 1000000007;
    // ww_const_grid_connector4
    vector<int> dx = {0, 1, 0, -1};
    vector<int> dy = {1, 0, -1, 0};
    // ww_const_grid_connector8
    vector<int> adx = {0, 1, 0, -1, 1, -1, 1, -1};
    vector<int> ady = {1, 0, -1, 0, 1, 1, -1, -1};
    // =========================================================
    // IN OUT
    // =========================================================
    // ww_vec_cin_1
    vector<int> aa(N);
    for (int i = 0; i < N; i++) {
        // cin >> aa[i];
    }
    // ww_stl_cin_vec2
    vector<int> aaa(N), bbb(N);
    for (int i = 0; i < N; i++) {
        // cin >> aaa[i] >> bbb[i];
    }
    // ww_grid_cin
    vector<vector<int>> G(N, vector<int>(N));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            // cin >> G[i][j];
        }
    }
    // ww_graph_cin
    vector<vector<int>> GG(N);
    for (int i = 0; i < N; i++) {
        // int A, B;
        // cin >> A >> B;
        // A--;
        // B--;
        // G[A].push_back(B);
        // G[B].push_back(A);
    }
    int ans = 0;
    // ww_cout
    cout << ans << endl;
    // ww_cout_yes_no
    cout << (true ? "Yes" : "No") << endl;
    // ww_fixed_setprecision
    cout << fixed << setprecision(20);
    // =========================================================
    // STL
    // =========================================================
    // ww_stl_max_ch
    int tmp = 1;
    ans = max(ans, tmp);
    // ww_stl_min_ch
    ans = min(ans, tmp);
    // ww_stl_all
    sort(A.begin(), A.end());
    // ww_stl_all_rev
    sort(A.rbegin(), A.rend());
    // sort
    sort(A.begin(), A.end());
    // ww_stl_transform
    string S;
    std::transform(S.begin(), S.end(), S.begin(), ::tolower);
    // ww_stl_uni
    sort(A.begin(), A.end());
    A.erase(unique(A.begin(), A.end()), A.end());
    // =========================================================
    // builtin
    // =========================================================
    // __builtin_ctz
    int zz = __builtin_ctz(1);
    // __builtin_popcount
    zz = __builtin_popcount(1);
    // __builtin_popcountll
    zz = __builtin_popcountll(1);
    // =========================================================
    // util function
    // =========================================================
    // ww_util_debug_vec_cout
    // also use my vim command :TODOdelete
    cout << "debug_A:";                // TODO debug
    for (auto v : A) cout << " " << v; // TODO debug
    cout << endl;                      // TODO debug
    // ww_util_div_to_ceil
    auto divCeil = []<class T>(T a, T b) -> T {
        return a / b + (((a ^ b) > 0 and a % b != 0) ? 1 : 0);
    };
    assert(divCeil(10, 5) == 2);
    assert(divCeil(10, 3) == 4);
    assert(divCeil(-10, 3) == -3);
    assert(divCeil(aINF, aINF) == 1);
    assert(divCeil(0, 1) == 0);
    // ww_util_div_to_floor
    auto divFloor = []<class T>(T a, T b) -> T {
        return a / b - (((a ^ b) < 0 and a % b != 0) ? 1 : 0);
    };
    assert(divFloor(10, 5) == 2);
    assert(divFloor(10, 3) == 3);
    assert(divFloor(-10, 3) == -4);
    assert(divFloor(aINF, aINF) == 1);
    assert(divFloor(0, 1) == 0);
    // ww_util_split_string
    auto split = [](string s, char c) -> vector<string> {
        vector<string> S;
        string t;
        for (char v : s) {
            if (v == c) {
                if (!t.empty()) {
                    S.push_back(t);
                }
                t.clear();
            } else {
                t += v;
            }
        }
        if (!t.empty()) {
            S.push_back(t);
        }
        return S;
    };
    for (auto &v : split("test:test", ':')) {
        assert(v == "test");
    }
    // =========================================================
    // Algorithm Math
    // =========================================================
    // ww_algo_order_sum_n
    auto digitsum = []<class T>(T a, int N = 10) -> T {
        T ans = 0;
        while (a != 0) {
            ans += a % N;
            a /= N;
        }
        return ans;
    };
    assert(digitsum(15) == 6);
    assert(digitsum(aINF) == 7);
    assert(digitsum(15, 2) == __builtin_popcount(15));
    // ww_algo_divisors_list
    // https://atcoder.jp/contests/abc106/submissions/49604101
    auto divisors = []<class T>(T a) -> vector<T> {
        vector<T> ans;
        for (int i = 1; i * i <= a; i++) {
            if (a % i != 0) {
                continue;
            }
            ans.push_back(i);
            if (a / i != i) {
                ans.push_back(i);
            }
        }
        return ans;
    };
    // ww_algo_is_prime
    auto is_p = []<class T>(T num) -> bool {
        if (num == 2) {
            return true;
        }
        if (num < 2 || num % 2 == 0) {
            return false;
        }
        double sqrtNum = sqrt(num);
        for (T i = 3; i <= sqrtNum; i += 2) {
            if (num % i == 0) {
                return false;
            }
        }
        return true;
    };
    assert(is_p(37) == true);
    // ww_algo_eratosthenes_sieve
    auto eratosthenes = []<class T>(T N) -> vector<bool> {
        vector<bool> is_P(N + 1, true);
        is_P[0] = is_P[1] = false;
        for (T i = 2; i * i <= N; i++) {
            if (!is_P[i]) {
                continue;
            }
            for (T j = i * i; j <= N; j += i) {
                is_P[j] = false;
            }
        }
        return is_P;
    };
    vector<bool> era = eratosthenes(12);
    assert(era[0] == false);
    assert(era[1] == false);
    assert(era[2] == true);
    assert(era[3] == true);
    assert(era[4] == false);
    assert(era[5] == true);
    assert(era[6] == false);
    assert(era[7] == true);
    assert(era[8] == false);
    assert(era[9] == false);
    assert(era[10] == false);
    assert(era[11] == true);
    assert(era[12] == false);
    // ww_algo_prime_fact
    auto p_fact = []<class T>(T N) -> map<T, int> {
        map<T, int> P;
        for (T i = 2; i * i <= N; i++) {
            while (N % i == 0) {
                P[i]++;
                N /= i;
            }
        }
        if (N > 1) {
            P[N]++;
        }
        return P;
    };
    map<int, int> pfact = p_fact(12);
    assert(pfact[2] == 2);
    assert(pfact[3] == 1);
    assert(pfact.size() == 2);
    // ww_algo_mod_pow
    auto mod_pow = [&]<class T>(T a, T n) -> T {
        T ans = 1;
        while (n > 0) {
            if (n & 1) {
                ans = ans * a % MOD;
            }
            a = a * a % MOD;
            n >>= 1ll;
        }
        return ans;
    };
    assert(mod_pow(2, 3) == 8);
    // ww_algo_mod_inverse_Fermat
    auto modinv_fermat = [&](long long a) -> long long {
        return mod_pow(a, MOD - 2);
    };
    assert(modinv_fermat(5) == 598946612);
    // ww_algo_mod_factorial
    vector<long long> mf;
    auto modfact = [&](int x) -> long long {
        if (mf.size() > x) {
            return mf[x];
        }
        if (mf.empty()) {
            mf.push_back(1);
        }
        for (int i = mf.size(); i <= x; i++) {
            long long next = mf.back() * i % MOD;
            mf.push_back(next);
        }
        return mf[x];
    };
    assert(modfact(5) == 120);
    // ww_algo_factorial
    auto factorial = []<class T>(T N) -> T {
        T ans = 1;
        while (N > 0) {
            ans *= N;
            N--;
        }
        return ans;
    };
    assert(factorial(5) == 120);
    // ww_algo_mod_combination
    auto mod_combination = [&](int n, int k) -> long long {
        return modfact(n) * modinv_fermat(modfact(k)) % MOD *
               modinv_fermat(modfact(n - k)) % MOD;
    };
    assert(mod_combination(5, 2) == 10);
    // ww_algo_mod_combination_Euclid
    const int MAX = 3e5;
    long long fac[MAX], finv[MAX], inv[MAX];
    auto Extended_Euclid_inverse_calc = [&]() -> void {
        fac[0] = fac[1] = 1;
        finv[0] = finv[1] = 1;
        inv[1] = 1;
        for (int i = 2; i < MAX; i++) {
            fac[i] = fac[i - 1] * i % MOD;
            inv[i] = MOD - inv[MOD % i] * (MOD / i) % MOD;
            finv[i] = finv[i - 1] * inv[i] % MOD;
        }
    };
    Extended_Euclid_inverse_calc();
    auto nCk = [&](int n, int k) -> long long {
        if (n < k or n < 0 or k < 0) {
            return 0;
        }
        return fac[n] * (finv[k] * finv[n - k] % MOD) % MOD;
    };
    assert(nCk(5, 2) == 10);
    // =========================================================
    // Algorithm Search
    // =========================================================
    // ww_algo_alma
    vector<int> al = {2, 2, 2, 2, 2};
    bool alma = true;
    for (int i = 0; i < 5; i++) {
        alma &= al[i] == 2;
    }
    assert(alma == true);
    al[1] = 3;
    for (int i = 0; i < 5; i++) {
        alma &= al[i] == 2;
    }
    assert(alma == false);
    // ww_algo_anma
    bool anma = false;
    for (int i = 0; i < 5; i++) {
        anma |= al[i] == 10;
    }
    assert(anma == false);
    for (int i = 0; i < 5; i++) {
        anma |= al[i] == 3;
    }
    assert(anma == true);
    // ww_algo_permu_loop
    vector<int> permu = {1, 2, 3};
    do {
        // 123,132,213,231,312,321
    } while (next_permutation(permu.begin(), permu.end()));
    // ww_algo_bit_loop
    vector<int> bi = {1, 2, 3};
    for (int bit = 0; bit < 1 << 3; bit++) {
        long long tmp = 0;
        for (int k = 0; k < 3; k++) {
            if (bit & (1ll << k)) {
                tmp |= bi[k];
            }
        }
        // tmp loop 2^3
    }
    // ww_algo_bit_on_all_pattern
    // https://atcoder.jp/contests/abc269/submissions/49333596
    // output 1 pattern
    // 101 -> 000, 001, 100, 101 -> 0, 1, 4, 5
    int bitall = 5;
    for (long long i = bitall; i > 0; i = (i - 1) & bitall) {
        cout << bitall - i << endl;
    }
    cout << bitall << endl;
    // ww_algo_run_length
    string runstr = "aaabbbc";
    int ssss = runstr.size();
    string anstr = "";
    int r = 0;
    for (int l = 0; l < ssss; l++) {
        l = r;
        if (l >= ssss) {
            break;
        }
        while (r < ssss and runstr[l] == runstr[r]) {
            ++r;
        }
        anstr += runstr[l] + to_string(r - l);
    }
    assert(anstr == "a3b3c1");
    // =========================================================
    // Algorithm Graph
    // =========================================================
    // ww_algo_bfs
    // https://onlinejudge.u-aizu.ac.jp/status/users/serna37/submissions/1/ALDS1_11_C/judge/8792466/C++14
    // ww_algo_grid_filter
    // omit
    // =========================================================
    // Algorithm DP
    // =========================================================
    // ww_algo_dp
    // ww_algo_dp_napsack
    // https://onlinejudge.u-aizu.ac.jp/status/users/serna37/submissions/1/DPL_1_B/judge/8792508/C++14
    // ww_algo_dp_coin_sum
    // https://atcoder.jp/contests/abc286/submissions/49349703
    // ww_algo_dp_pattern
    // https://atcoder.jp/contests/abc211/submissions/49405309
    // ww_algo_dp_tree
    // https://atcoder.jp/contests/abc244/submissions/49374857
    // =========================================================
    // Algorithm RxQ
    // =========================================================
    // RMQ
    // https://onlinejudge.u-aizu.ac.jp/status/users/serna37/submissions/1/DSL_2_A/judge/8784440/C++14
    // segment tree
    // https://atcoder.jp/contests/arc075/submissions/49429892
    // fenwick tree
    // https://atcoder.jp/contests/arc075/submissions/49522128
    // https://onlinejudge.u-aizu.ac.jp/status/users/serna37/submissions/1/DSL_2_B/judge/8795468/C++14
}
