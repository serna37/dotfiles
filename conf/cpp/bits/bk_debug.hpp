#include <cxxabi.h>
#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <stack>
using std::cerr;
using std::deque;
using std::map;
using std::multiset;
using std::pair;
using std::priority_queue;
using std::queue;
using std::set;
using std::stack;
using std::string;
using std::tuple;
using std::vector;
// =====================================
// primitive
// =====================================
void _print(const int &v) {
    cerr << v;
}
void _print(const long long &v) {
    cerr << v;
}
void _print(const double &v) {
    cerr << v;
}
void _print(const string &v) {
    cerr << "\033[32m" << '"' << "\033[m" << v << "\033[32m" << '"' << "\033[m";
}
void _print(const char &v) {
    cerr << "\033[32m"
         << "'"
         << "\033[m" << v << "\033[32m"
         << "'"
         << "\033[m";
}
void _print_start() {
    cerr << "\033[32m"
         << "{"
         << "\033[m";
}
void _print_end() {
    cerr << "\033[32m"
         << "}"
         << "\033[m";
}
void _print_p_start() {
    cerr << "\033[32m"
         << "("
         << "\033[m";
}
void _print_p_end() {
    cerr << "\033[32m"
         << ")"
         << "\033[m";
}
void _print_sep() {
    cerr << "\033[32m"
         << ","
         << "\033[m";
}
void _print_LF() {
    cerr << "\n";
}
// =====================================
// pair tuple
// =====================================
template <typename T, typename U> void _print(const pair<T, U> &v) {
    _print_p_start();
    _print(v.first);
    _print_sep();
    _print(v.second);
    _print_p_end();
}
template <typename T, typename U, typename R>
void _print(const tuple<T, U, R> &v) {
    _print_p_start();
    _print(get<0>(v));
    _print_sep();
    _print(get<1>(v));
    _print_sep();
    _print(get<2>(v));
    _print_p_end();
}
template <typename T, typename U, typename R, typename S>
void _print(const tuple<T, U, R, S> &v) {
    _print_p_start();
    _print(get<0>(v));
    _print_sep();
    _print(get<1>(v));
    _print_sep();
    _print(get<2>(v));
    _print_sep();
    _print(get<3>(v));
    _print_p_end();
}
// =====================================
// vector vector2 set multiset map
// =====================================
template <typename T> void _print(const vector<T> &v) {
    _print_start();
    for (int i = 0; i < static_cast<int>(v.size()); ++i) {
        if (i) _print_sep();
        _print(v[i]);
    }
    _print_end();
}
template <typename T> void _print(const vector<vector<T>> &v) {
    _print_start();
    _print_LF();
    for (int i = 0; i < static_cast<int>(v.size()); ++i) {
        for (int j = 0; j < static_cast<int>(v[i].size()); ++j) {
            if (j) _print_sep();
            _print(v[i][j]);
        }
        _print_LF();
    }
    _print_end();
}
template <typename T> void _print(const set<T> &v) {
    _print_start();
    int i = 0;
    for (auto &&x : v) {
        if (i++) _print_sep();
        _print(x);
    }
    _print_end();
}
template <typename T> void _print(const multiset<T> &v) {
    _print_start();
    int i = 0;
    for (auto &&x : v) {
        if (i++) _print_sep();
        _print(x);
    }
    _print_end();
}
template <typename T, typename U> void _print(const map<T, U> &v) {
    _print_start();
    int i = 0;
    for (auto &&[k, x] : v) {
        if (i++) _print_sep();
        _print_p_start();
        _print(k);
        _print_sep();
        _print(x);
        _print_p_end();
    }
    _print_end();
}
// =====================================
// stack queue priority_queue deque
// =====================================
template <typename T> void _print(const stack<T> &v) {
    auto x = v;
    _print_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.top());
        x.pop();
    }
    _print_end();
}
template <typename T> void _print(const queue<T> &v) {
    auto x = v;
    _print_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.front());
        x.pop();
    }
    _print_end();
}
template <typename T> void _print(const priority_queue<T> &v) {
    auto x = v;
    _print_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.top());
        x.pop();
    }
    _print_end();
}
template <typename T> void _print(const deque<T> &v) {
    auto x = v;
    _print_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.front());
        x.pop_front();
    }
    _print_end();
}
// =====================================
// 最上位の型名を取得
// =====================================
template <typename T> string _get_top_type(const T &v) {
    // 型名をデマングルする
    int res;
    char *r = abi::__cxa_demangle(typeid(v).name(), nullptr, nullptr, &res);
    if (res != 0) {
        cerr << "demangle error"
             << "\n";
        free(r);
        return "";
    }
    string tmp = r;
    free(r);
    // stdうんたらを消す
    const string prefix = "std::__1::";
    const int presz = prefix.size();
    auto p = tmp.find(prefix);
    while (p != string::npos) {
        tmp.erase(p, presz);
        p = tmp.find(prefix, p + 1);
    }
    // 最初の<までを見る
    auto p2 = tmp.find('<');
    if (p2 != string::npos) {
        tmp = tmp.substr(0, p2);
    }
    if (tmp == "basic_string") {
        tmp = "string";
    }
    return tmp;
}
// =====================================
// base
// =====================================
template <typename T> void print(const T &v) {
    _print(v);
    _print_LF();
}
#define debug(...)                                                             \
    cerr << "\033[32m"                                                         \
         << "--debug "                                                         \
         << "\033[34m"                                                         \
         << "["                                                                \
         << "\033[33m" << #__VA_ARGS__ << "\033[34m"                           \
         << "]"                                                                \
         << "\033[m"                                                           \
         << ":",                                                               \
        print(__VA_ARGS__)
// ==========================================================================
// ==========================================================================
