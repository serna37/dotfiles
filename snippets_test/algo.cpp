#include <bits/stdc++.h>
using namespace std;
int main() {
    int N = 10;
    vector<int> A(N, 0);
    bool alma = true;
    for (int i = 0; i < N; i++) {
        alma &= A[i] == 9;
    }
    bool anma = false;
    for (int i = 0; i < N; i++) {
        anma |= A[i] == 9;
    }
    do {
        cout << "debug_A:";                // TODO debug
        for (auto v : A) cout << " " << v; // TODO debug
        cout << endl;                      // TODO debug
    } while (next_permutation(A.begin(), A.end()));
    for (int bit = 0; bit < 1 << N; bit++) {
        long long tmp = 0;
        for (int k = 0; k < N; k++) {
            if (bit & (1ll << k)) {
                tmp |= A[k];
            }
        }
    }
    for (long long i = N; i > 0; i = (i - 1) & N) {
        cout << N - i << endl;
    }
    cout << N << endl;
    // string ans = "";
    // int r = 0;
    // for (int l = 0; l < N; l++) {
    // l = r;
    // if (l >= N) {
    // break;
    //}
    // while (r < N and A[l] == A[r]) {
    //++r;
    //}
    // ans += A[l] + to_string(r - l);
    //}
    vector<vector<int>> G(N);
    for (int i = 0; i < N; i++) {
        int A, B;
        cin >> A >> B;
        A--, B--;
        G[A].push_back(B);
        G[B].push_back(A);
    }
    queue<int> q;
    q.push(0);
    vector<int> d(N, -1);
    d[0] = 0;
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        for (int nv : G[v]) {
            if (d[nv] == -1) {
                d[nv] = d[v] + 1;
                q.push(nv);
            }
        }
    }
    vector<vector<char>> GG(N, vector<char>(N));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            cin >> GG[i][j];
        }
    }
    // queue<pair<int, int>> q;
    // q.push({0, 0});
    // vector<vector<int>> d(N, vector<int>(N, -1));
    // d[0][0] = 0;
    // while (!q.empty()) {
    // int py = q.front().first;
    // int px = q.front().second;
    // q.pop();
    // for (int i = 0; i < 4; i++) {
    // int y = py + dy[i];
    // int x = px + dx[i];
    // if (y < 0 or x < 0 or N <= y or N <= x) continue;
    // if (d[y][x] == -1 and cango(GG[y][x])) {
    // d[y][x] = d[py][px] + 1;
    // q.push({y, x});
    //}
    //}
    //}
    auto cango = [](const char &a) -> bool {
        string white = ".SG";
        return white.find(a) != string::npos;
    };
    // for (int k = 0; k < 4; k++) {
    // int y = i + dy[k];
    // int x = j + dx[k];
    // if (y < 0 or x < 0 or row <= y or column <= x) continue;
    //}
    // if (y < 0 or x < 0 or row <= y or column <= x) continue;
    // vector<int> dp(N + 1, 0);
    // dp[0] = 0;
    // fori
    // cout << dp[N] << endl;
    // vector<vector<int>> dp(N + 1, vector<int>(W + 1, 0));
    // dp[0][0] = 0;
    // fori2
    // cout << dp[N][W] << endl;
    vector<long long> S(N + 1);
    for (int i = 0; i < N; i++) {
        S[i + 1] = S[i] + A[i];
    }
    vector<long long> R(N + 1);
    for (int i = N - 1; i >= 0; i--) {
        R[i] = R[i + 1] + A[i];
    }
    vector<vector<long long>> SS(N + 1, vector<long long>(N + 1));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            SS[i + 1][j + 1] = SS[i + 1][j] + G[i][j];
        }
    }
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            SS[i + 1][j + 1] += SS[i][j + 1];
        }
    }
    vector<int> D(N - 1);
    for (int i = 0; i < N - 1; i++) {
        D[i] = A[i + 1] - A[i];
    }
    A[4]++;
    A[8 + 1]--;
    auto compress = []<class T>(vector<T> &a) -> int {
        vector<T> c = a;
        sort(c.begin(), c.end());
        c.erase(unique(c.begin(), c.end()), c.end());
        for (auto &v : a) v = lower_bound(c.begin(), c.end(), v) - c.begin();
        return c.size();
    };
}
