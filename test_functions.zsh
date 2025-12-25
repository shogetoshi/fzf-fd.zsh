#!/bin/zsh

# テスト対象の関数を読み込む
source "${0:A:h}/fzf-fd.zsh"

# テスト結果カウンタ
passed=0
failed=0

# テストヘルパー関数
assert_eq() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    if [[ "$expected" == "$actual" ]]; then
        echo "✓ PASS: $test_name"
        ((passed++))
    else
        echo "✗ FAIL: $test_name"
        echo "  expected: '$expected'"
        echo "  actual:   '$actual'"
        ((failed++))
    fi
}

echo "=== get_query tests ==="

# テストケース
assert_eq "bbb" "$(get_query 'aaa/bbb')" "aaa/bbb -> bbb"
assert_eq "aaa" "$(get_query 'aaa')" "aaa -> aaa"
assert_eq "" "$(get_query 'aaa/bbb ')" "aaa/bbb (末尾スペース) -> 空"
assert_eq "aaa" "$(get_query '.git/aaa')" ".git/aaa -> aaa"
assert_eq "" "$(get_query '')" "空文字 -> 空"
assert_eq "file.txt" "$(get_query 'cat /path/to/file.txt')" "cat /path/to/file.txt -> file.txt"
assert_eq "" "$(get_query 'cat ')" "cat (末尾スペース) -> 空"
assert_eq "bar" "$(get_query 'foo bar')" "foo bar -> bar"

echo ""
echo "=== get_dir tests ==="

assert_eq "" "$(get_dir 'aaa')" "aaa -> 空"
assert_eq "aaa" "$(get_dir 'aaa/bbb')" "aaa/bbb -> aaa"
assert_eq "" "$(get_dir 'aaa ')" "aaa (末尾スペース) -> 空"
assert_eq ".git" "$(get_dir '.git/aaa')" ".git/aaa -> .git"
assert_eq "/path/to" "$(get_dir 'cat /path/to/file.txt')" "cat /path/to/file.txt -> /path/to"

echo ""
echo "=== Results ==="
echo "Passed: $passed"
echo "Failed: $failed"

if [[ $failed -gt 0 ]]; then
    exit 1
fi
