#pragma once
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
// 区切り文字系
// =====================================
// array: インデックスで要素にアクセスできる系
inline void _print_a_start() {
    cerr << "\033[32m"
         << "["
         << "\033[m";
}
inline void _print_a_end() {
    cerr << "\033[32m"
         << "]"
         << "\033[m";
}
// brucet: その他の集合
inline void _print_b_start() {
    cerr << "\033[32m"
         << "{"
         << "\033[m";
}
inline void _print_b_end() {
    cerr << "\033[32m"
         << "}"
         << "\033[m";
}
// parentheses: タプル系
inline void _print_p_start() {
    cerr << "\033[32m"
         << "("
         << "\033[m";
}
inline void _print_p_end() {
    cerr << "\033[32m"
         << ")"
         << "\033[m";
}
// カンマ、改行
inline void _print_sep() {
    cerr << "\033[32m"
         << ","
         << "\033[m";
}
inline void _print_LF() {
    cerr << "\n";
}
// =====================================
// 型が入れ子になっているか判定
// =====================================
template <typename T> bool _is_nested(const T &v, int f = 3) {
    // 型名をデマングルする
    int res;
    char *r = abi::__cxa_demangle(typeid(v).name(), nullptr, nullptr, &res);
    if (res != 0) {
        cerr << "demangle error"
             << "\n";
        free(r);
        return false;
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
    // stringはbasic_string<char ...
    if (tmp == "basic_string<") {
        tmp = "string";
    }
    int cnt = 0;
    for (auto &&ch : tmp) {
        if (ch == '<') ++cnt;
    }
    // 閾値fについて
    // vector<int>はvector<int, allocator<int>>になる
    // setではもっと多い
    return cnt >= f;
}
// =====================================
// 対応型用のinterfaceを宣言しておく
// =====================================
template <typename T> void _print(const T &v);
template <typename T> void _print(const vector<T> &v);
template <typename T> void _print(const set<T> &v);
template <typename T> void _print(const multiset<T> &v);
template <typename T, typename U> void _print(const map<T, U> &v);
template <typename T, typename U> void _print(const pair<T, U> &v);
template <typename T, typename U, typename R>
void _print(const tuple<T, U, R> &v);
template <typename T, typename U, typename R, typename S>
void _print(const tuple<T, U, R, S> &v);
template <typename T> void _print(const stack<T> &v);
template <typename T> void _print(const queue<T> &v);
template <typename T> void _print(const priority_queue<T> &v);
template <typename T> void _print(const deque<T> &v);
// =====================================
// プリミティブ型用
// =====================================
inline void _print(const int &v) {
    cerr << v;
}
inline void _print(const long long &v) {
    cerr << v;
}
inline void _print(const double &v) {
    cerr << v;
}
inline void _print(const char &v) {
    cerr << "\033[32m'\033[m" << v << "\033[32m'\033[m";
}
inline void _print(const string &v) {
    cerr << "\033[32m" << '"' << "\033[m" << v << "\033[32m" << '"' << "\033[m";
}
// 直接引数に入れたりとかした場合
template <typename T> void _print(const T &v) {
    cerr << v;
}
// =====================================
// pair tuple3 tuple4
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
    bool isnested = _is_nested(v);
    _print_a_start();
    if (isnested) _print_LF();
    for (int i = 0; i < static_cast<int>(v.size()); ++i) {
        if (isnested) cerr << "  ";
        if (i) _print_sep();
        _print(v[i]);
        if (isnested) _print_LF();
    }
    _print_a_end();
}
template <typename T> void _print(const set<T> &v) {
    bool isnested = _is_nested(v, 4);
    _print_b_start();
    if (isnested) _print_LF();
    int i = 0;
    for (auto &&x : v) {
        if (isnested) cerr << "  ";
        if (i++) _print_sep();
        _print(x);
        if (isnested) _print_LF();
    }
    _print_b_end();
}
template <typename T> void _print(const multiset<T> &v) {
    bool isnested = _is_nested(v, 4);
    _print_b_start();
    if (isnested) _print_LF();
    int i = 0;
    for (auto &&x : v) {
        if (isnested) cerr << "  ";
        if (i++) _print_sep();
        _print(x);
        if (isnested) _print_LF();
    }
    _print_b_end();
}
template <typename T, typename U> void _print(const map<T, U> &v) {
    _print_b_start();
    _print_LF();
    int i = 0;
    for (auto &&[k, x] : v) {
        cerr << "  ";
        if (i++) _print_sep();
        _print_p_start();
        _print(k);
        _print_sep();
        _print(x);
        _print_p_end();
        _print_LF();
    }
    _print_b_end();
}
// =====================================
// stack queue priority_queue deque
// =====================================
template <typename T> void _print(const stack<T> &v) {
    auto x = v;
    _print_b_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.top());
        x.pop();
    }
    _print_b_end();
}
template <typename T> void _print(const queue<T> &v) {
    auto x = v;
    _print_b_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.front());
        x.pop();
    }
    _print_b_end();
}
template <typename T> void _print(const priority_queue<T> &v) {
    auto x = v;
    _print_b_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.top());
        x.pop();
    }
    _print_b_end();
}
template <typename T> void _print(const deque<T> &v) {
    auto x = v;
    _print_a_start();
    int i = 0;
    while (!x.empty()) {
        if (i++) _print_sep();
        _print(x.front());
        x.pop_front();
    }
    _print_a_end();
}
// =====================================
// base
// =====================================
template <typename T> void print(const T &v, const string &name) {
    cerr << "\033[90m[debug]\033[36m " << name << "\033[m => ";
    _print(v);
    _print_LF();
}
#define debug(...) print(__VA_ARGS__, #__VA_ARGS__)
// cpp_dump
// https://zenn.dev/sassan/articles/19db660e4da0a4
// #include "cpp-dump.hpp"
// #define debug(...) cpp_dump(__VA_ARGS__)
