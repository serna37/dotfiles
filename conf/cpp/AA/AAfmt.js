// 行を、文法を崩さないように単語分割する
// string s = " ", v = ""; みたいなものを分割しないようハンドリング
let need = 0
const grammerSplit = line => {
    // includeは分割できない
    if (line.startsWith("#")) {
        need += line.length
        return line
    }
    const res = []
    for (let i = 0; i < line.length; ++i) {
        // ダブルクォートのハンドリング
        if (line[i] == '"') {
            const word = []
            word.push(line[i])
            ++i
            while (i < line.length && line[i] != '"') {
                word.push(line[i])
                ++i
            }
            word.push(line[i])
            res.push(word.join(""))
            continue
        }
        // シングルクォートのハンドリング
        if (line[i] == "'") {
            const word = []
            word.push(line[i])
            ++i
            while (i < line.length && line[i] != "'") {
                word.push(line[i])
                ++i
            }
            word.push(line[i])
            res.push(word.join(""))
            continue
        }
        // 空白を無視
        if (line[i] == " ") continue
        const word = []
        while (i < line.length && line[i] != " ") {
            word.push(line[i])
            ++i
        }
        // 分けてもいい文字で分割
        // ().;あたりは分割できるが、文字の密集度を考慮
        const allow = "().;"
        const w = word.join("")
        const list = []
        for (let i = 0; i < w.length; ++i) {
            let a = ""
            while (i < w.length && !~allow.indexOf(w[i])) {
                a += w[i]
                ++i
            }
            list.push(a)
            if (~allow.indexOf(w[i])) {
                list.push(w[i])
                continue
            }

        }
        res.push(...list)
    }
    need += res.map(v => v.length).reduce((a, b) => a + b, 0)
    return res
}

// プログラム文字列を受け取る
const input = require('fs').readFileSync("/dev/stdin", "utf8")
let words = input.split("\n").flatMap(grammerSplit)

// AAを読み込む
let cnt = 0
const readAA = (filename) => {
    cnt = 0
    return require('fs').readFileSync(filename, "utf-8").split("\n")
        .map(line => {
            // 空白の連続か、文字の連続に分割する
            const res = []
            for (let i = 0; i < line.length; ++i) {
                // 空白の連続
                if (line[i] == " ") {
                    let a = " "
                    ++i
                    while (i < line.length && line[i] == " ") {
                        a += line[i]
                        ++i
                    }
                    res.push(a)
                    continue
                }
                // 文字列の連続
                let a = ""
                while (i < line.length && line[i] != " ") {
                    a += line[i]
                    ++i
                }
                res.push(a)
            }
            cnt += res.map(v => v.length).reduce((a, b) => a + b, 0)
            return res
        })
}
let AA = readAA("./AA/AA.txt")
if (cnt < need ) {
    AA = readAA("./AA/AA100.txt")
    if (cnt < need) {
        console.log("error")
    }
}

// 単語をAAにあてがう
// AAの文字列サイズ以上になるように、wordsをあてがう
// 空白はそのまま
// 2文字以上余ったら、全部/で埋める
let i = 0
const headers = words.filter(v => v.startsWith("#")).join("\n")
words = words.filter(v => !v.startsWith("#"))
const AAformattedProgram = headers + "\n" + AA.map(blocks => {
    const line = blocks.map(block => {
        if (block.startsWith(" ")) return block
        if (i >= words.length) {
            return block.length >= 2
                ? "/".repeat(block.length)
                : "//"
        }
        let len = block.length
        let a = ""
        while (i < words.length) {
            if (len < 0) break
            a += words[i]
            a += " "
            len -= words[i].length
            --len
            ++i
        }
        return a
    }).join("")
    return line
}).join("\n")

// 出力
console.log(AAformattedProgram)

