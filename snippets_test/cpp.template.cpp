#include <bits/stdc++.h>
using namespace std;
void func() {
}
int main() {
    int N = 10;
    vector<int> A(N, 1);
    for (int a = 1; a < N; ++a) {
    }
    for (int i = 0; i < N; i++) {
        A[i]++;
    }
    for (long long i = 0; i < N; i++) {
        A[i]++;
    }
    for (int i = N - 1; i >= 0; i--) {
        A[i]++;
    }
    for (long long i = 0; i * i <= N; i++) {
        A[i]++;
    }
    vector<vector<int>> B(N, vector<int>(N, 1));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            B[i][j]++;
        }
    }
    for (auto &v : A) {
        v++;
    }
    auto func = [&](const int &a) -> void { cout << a << endl; };
    auto rec = [&](auto self, const int &a) -> void {
        if (a == 1) return;
        self(self, 1); // recursive
    };
    long long a;
    double b;
    vector<int> c;
    set<int> d;
    multiset<set<long long>> aa;
    map<unordered_map<double, pair<long long, int>>, int> aaa;
    tuple<stack<int>, queue<int>, priority_queue<int>> T;
    priority_queue<int, vector<int>, greater<int>> lesss;
    deque<char> dq;
    const double PI = acos(-1);
    const int INF = 1001001001;
    // const long long INF = 1001001001001001001ll;
    const long long MOD = 998244353;
    // const long long MOD = 1000000007;
    const vector<int> dx = {0, 1, 0, -1};
    const vector<int> dy = {1, 0, -1, 0};
    // const vector<int> dx = {0, 1, 0, -1, 1, -1, 1, -1};
    // const vector<int> dy = {1, 0, -1, 0, 1, 1, -1, -1};
    vector<int> G(N);
    for (int i = 0; i < N; i++) {
        cin >> G[i];
    }
    vector<int> F(N), FF(N);
    for (int i = 0; i < N; i++) {
        cin >> F[i] >> FF[i];
    }
    vector<vector<char>> EE(N, vector<char>(N));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            cin >> EE[i][j];
        }
    }
    vector<vector<int>> JJ(N);
    for (int i = 0; i < N; i++) {
        int A, B;
        cin >> A >> B;
        A--, B--;
        JJ[A].push_back(B);
        JJ[B].push_back(A);
    }
    cout << (true ? "Yes" : "No") << endl;
    cout << fixed << setprecision(20);
    // if (true) cout << " ";
    // cout << A[true];
    cout << endl;
    int ans = 0;
    int tmp = 0;
    ans = max(ans, tmp);
    ans = min(ans, tmp);
    sort(A.begin(), A.end());
    sort(A.rbegin(), A.rend());
    swap(ans, tmp);
    sort(A.begin(), A.end());
    A.erase(unique(A.begin(), A.end()), A.end());
    int aaaaa = __builtin_ctz(10);
    aaaaa = __builtin_popcount(10);
    aaaaa = __builtin_popcountll(100);
    cout << aaaaa << endl;
    bool ok = true;
    int jjjjj = A.size();
    cout << "debug_A:";                // TODO debug
    for (auto v : A) cout << " " << v; // TODO debug
    cout << endl;                      // TODO debug
    auto divFloor = []<class T>(T a, T b) -> T {
        return a / b - (((a ^ b) < 0 and a % b != 0) ? 1 : 0);
    };
    auto divCeil = []<class T>(T a, T b) -> T {
        return a / b + (((a ^ b) > 0 and a % b != 0) ? 1 : 0);
    };
    int rrr = (5 + 2 - 1) / 2;
    auto islow = [](char c) -> bool { return islower(c) != 0; };
    auto isupp = [](char c) -> bool { return isupper(c) != 0; };
    auto split = [](string s, char c) -> vector<string> {
        vector<string> S;
        string t;
        for (char v : s) {
            if (v == c) {
                if (!t.empty()) S.push_back(t);
                t.clear();
            } else {
                t += v;
            }
        }
        if (!t.empty()) S.push_back(t);
        return S;
    };
}
