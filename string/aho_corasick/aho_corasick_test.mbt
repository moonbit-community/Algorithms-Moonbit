///|
fn assert_match(mat : ACMatch, start : Int, end : Int, idx : Int) -> Unit raise {
  assert_eq(mat.start(), start)
  assert_eq(mat.end(), end)
  assert_eq(mat.pattern_index(), idx)
}

///|
fn assert_match_arrays(
  matches : Array[ACMatch],
  expected_start : Array[Int],
  expected_end : Array[Int],
  expected_idx : Array[Int],
) -> Unit raise {
  assert_eq(matches.length(), expected_start.length())
  assert_eq(matches.length(), expected_end.length())
  assert_eq(matches.length(), expected_idx.length())
  for i = 0; i < matches.length(); i = i + 1 {
    assert_match(
      matches[i],
      expected_start[i],
      expected_end[i],
      expected_idx[i],
    )
  }
}

///|
fn clone_int_array(arr : Array[Int]) -> Array[Int] {
  let copy : Array[Int] = []
  for i = 0; i < arr.length(); i = i + 1 {
    copy.push(arr[i])
  }
  copy
}

///|
fn sort_match_triples(
  start : Array[Int],
  end : Array[Int],
  idx : Array[Int],
) -> Unit {
  let n = start.length()
  for i = 0; i < n; i = i + 1 {
    for j = i + 1; j < n; j = j + 1 {
      let swap = if end[j] < end[i] {
        true
      } else if end[j] == end[i] {
        if start[j] < start[i] {
          true
        } else if start[j] == start[i] {
          idx[j] < idx[i]
        } else {
          false
        }
      } else {
        false
      }
      if swap {
        let tmp_start = start[i]
        let tmp_end = end[i]
        let tmp_idx = idx[i]
        start[i] = start[j]
        end[i] = end[j]
        idx[i] = idx[j]
        start[j] = tmp_start
        end[j] = tmp_end
        idx[j] = tmp_idx
      }
    }
  }
}

///|
fn assert_matches_unordered(
  matches : Array[ACMatch],
  expected_start : Array[Int],
  expected_end : Array[Int],
  expected_idx : Array[Int],
) -> Unit raise {
  assert_eq(matches.length(), expected_start.length())
  assert_eq(matches.length(), expected_end.length())
  assert_eq(matches.length(), expected_idx.length())
  let actual_start : Array[Int] = []
  let actual_end : Array[Int] = []
  let actual_idx : Array[Int] = []
  for i = 0; i < matches.length(); i = i + 1 {
    actual_start.push(matches[i].start())
    actual_end.push(matches[i].end())
    actual_idx.push(matches[i].pattern_index())
  }
  let expected_start_copy = clone_int_array(expected_start)
  let expected_end_copy = clone_int_array(expected_end)
  let expected_idx_copy = clone_int_array(expected_idx)
  sort_match_triples(actual_start, actual_end, actual_idx)
  sort_match_triples(expected_start_copy, expected_end_copy, expected_idx_copy)
  for i = 0; i < actual_start.length(); i = i + 1 {
    assert_eq(actual_start[i], expected_start_copy[i])
    assert_eq(actual_end[i], expected_end_copy[i])
    assert_eq(actual_idx[i], expected_idx_copy[i])
  }
}

///|
fn naive_fill_matches(
  patterns : Array[String],
  text : String,
  start : Array[Int],
  end : Array[Int],
  idx : Array[Int],
) -> Unit {
  for p = 0; p < patterns.length(); p = p + 1 {
    let pattern = patterns[p]
    let len = pattern.length()
    if len == 0 {
      continue
    }
    if text.length() < len {
      continue
    }
    for i = 0; i <= text.length() - len; i = i + 1 {
      let mut matched = true
      for j = 0; j < len; j = j + 1 {
        if text.code_unit_at(i + j) != pattern.code_unit_at(j) {
          matched = false
          break
        }
      }
      if matched {
        start.push(i)
        end.push(i + len - 1)
        idx.push(p)
      }
    }
  }
}

///|
fn assert_naive_equivalence(
  patterns : Array[String],
  text : String,
) -> Unit raise {
  let automaton = ACAutomaton::new()
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "single pattern basic match" {
  let automaton = ACAutomaton::new()
  assert_eq(automaton.pattern_count(), 0)
  let id = automaton.add_pattern("he")
  assert_eq(id, 0)
  assert_eq(automaton.pattern_count(), 1)
  let matches = automaton.query("hello")
  assert_match_arrays(matches, [0], [1], [0])
}

///|
test "no matches in text" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("world")
  let matches = automaton.query("hello")
  assert_eq(matches.length(), 0)
}

///|
test "overlapping patterns" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("he")
  let _ = automaton.add_pattern("she")
  let _ = automaton.add_pattern("hers")
  let matches = automaton.query("ushers")
  assert_match_arrays(matches, [1, 2, 2], [3, 3, 5], [1, 0, 2])
}

///|
test "prefix patterns report all matches" {
  let automaton = ACAutomaton::new()
  let patterns = ["a", "ab", "abc", "abcd"]
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let matches = automaton.query("abcd")
  assert_match_arrays(matches, [0, 0, 0, 0], [0, 1, 2, 3], [0, 1, 2, 3])
}

///|
test "multiple occurrences of same pattern" {
  let automaton = ACAutomaton::new()
  let idx = automaton.add_pattern("aba")
  assert_eq(idx, 0)
  let matches = automaton.query("ababa")
  assert_match_arrays(matches, [0, 2], [2, 4], [0, 0])
}

///|
test "clear resets automaton" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("foo")
  assert_eq(automaton.pattern_count(), 1)
  automaton.clear()
  assert_eq(automaton.pattern_count(), 0)
  let matches = automaton.query("foobar")
  assert_eq(matches.length(), 0)
  let id = automaton.add_pattern("bar")
  assert_eq(id, 0)
  let matches2 = automaton.query("foobar")
  assert_match_arrays(matches2, [3], [5], [0])
}

///|
test "query empty text" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("test")
  let matches = automaton.query("")
  assert_eq(matches.length(), 0)
}

///|
test "duplicate patterns produce separate matches" {
  let automaton = ACAutomaton::new()
  let id1 = automaton.add_pattern("aba")
  let id2 = automaton.add_pattern("aba")
  assert_eq(id1, 0)
  assert_eq(id2, 1)
  let matches = automaton.query("ababa")
  let expected_start = [0, 0, 2, 2]
  let expected_end = [2, 2, 4, 4]
  let expected_idx = [0, 1, 0, 1]
  assert_match_arrays(matches, expected_start, expected_end, expected_idx)
}

///|
test "matches sharing end index preserve output order" {
  let automaton = ACAutomaton::new()
  let id_a = automaton.add_pattern("a")
  let id_ba = automaton.add_pattern("ba")
  assert_eq(id_a, 0)
  assert_eq(id_ba, 1)
  automaton.build()
  let matches = automaton.query("ba")
  assert_match_arrays(matches, [0, 1], [1, 1], [1, 0])
}

///|
test "punctuation and symbol patterns" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("@@")
  let _ = automaton.add_pattern("#$")
  let _ = automaton.add_pattern("$@")
  let text = "!!@@##$$@@"
  let matches = automaton.query(text)
  let expected_start = [2, 5, 7, 8]
  let expected_end = [3, 6, 8, 9]
  let expected_idx = [0, 1, 2, 0]
  assert_match_arrays(matches, expected_start, expected_end, expected_idx)
}

///|
test "clear and reuse multiple cycles" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("abc")
  let first = automaton.query("abcabc")
  assert_match_arrays(first, [0, 3], [2, 5], [0, 0])
  automaton.clear()
  let _ = automaton.add_pattern("bc")
  let _ = automaton.add_pattern("cab")
  let second = automaton.query("abcabc")
  let expected_start = [1, 2, 4]
  let expected_end = [2, 4, 5]
  let expected_idx = [0, 1, 0]
  assert_match_arrays(second, expected_start, expected_end, expected_idx)
}

///|
test "repeated queries maintain state" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("aba")
  let _ = automaton.add_pattern("bab")
  let text = "ababab"
  let first = automaton.query(text)
  let second = automaton.query(text)
  let expected_start = [0, 1, 2, 3]
  let expected_end = [2, 3, 4, 5]
  let expected_idx = [0, 1, 0, 1]
  assert_match_arrays(first, expected_start, expected_end, expected_idx)
  assert_match_arrays(second, expected_start, expected_end, expected_idx)
}

///|
test "build without patterns" {
  let automaton = ACAutomaton::new()
  automaton.build()
  let matches = automaton.query("any text")
  assert_eq(matches.length(), 0)
}

///|
test "naive cross check simple datasets" {
  let pattern_sets = [
    ["a"],
    ["ab", "ba"],
    ["aba", "bab", "aa"],
    ["abc", "bc", "c"],
    ["xyz", "z", "yz", "xy"],
    ["needle", "need", "dle"],
    ["aba", "abba", "bababa"],
    ["he", "she", "hers", "his"],
    ["foo", "bar", "foobar"],
    ["cad", "cada", "ad"],
  ]
  let texts = [
    "a", "aba", "ababa", "abcabc", "xyzxyz", "find the needle in the haystack", "babbababa",
    "ushers usher his sheep", "foo and bar make foobar", "abracadabra",
  ]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check repeated characters" {
  let pattern_sets = [
    ["a", "aa", "aaa"],
    ["b", "bb", "bbb", "bbbb"],
    ["ab", "aba", "abab", "baba"],
    ["aaab", "aab", "ab"],
    ["aaaaa", "aaa", "aa"],
  ]
  let texts = ["aaaaaa", "bbbbbbbb", "abababababa", "aaababaaab", "aaaaaaaaaa"]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check whitespace and punctuation" {
  let pattern_sets = [
    [" ", "  ", "   "],
    [", ", " .", "?"],
    ["newline", "\n", "line"],
    ["tab", "\t", " \\t"],
    [" mix", "mix ", " mix "],
  ]
  let texts = [
    "     ", "comma, period. question?", "first line\nsecond line\nthird line", "tab\tseparated\tvalues",
    "mix and match mix and match",
  ]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check mixed case sensitivity" {
  let pattern_sets = [
    ["A", "a"],
    ["Hello", "hello", "HEL"],
    ["Case", "case", "Sensitive", "sensitive"],
    ["Title", "title", "TiTlE"],
    ["Upper", "lower", "Mixed", "MiXeD"],
  ]
  let texts = [
    "AaAaAa", "Hello HEL hello HeLlO", "Case sensitive CASE SENSITIVE case Sensitive",
    "This Title title is about TitleCase", "Upper lower Mixed mixed UPPER LOWER",
  ]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check numeric strings" {
  let pattern_sets = [
    ["1", "12", "123"],
    ["2024", "024", "24"],
    ["00", "000", "0000"],
    ["314", "159", "265", "358"],
    ["987", "678", "567", "456"],
    ["111", "222", "333", "123", "321"],
  ]
  let texts = [
    "0123456789", "2024024", "0000000", "314159265358979", "12345678987654321", "111222333123321",
  ]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check overlapping dictionary" {
  let pattern_sets = [
    ["abc", "bcd", "cde", "def"],
    ["aaaa", "aaab", "aaba", "abaa"],
    ["xyz", "yza", "zab", "abx"],
    ["pattern", "att", "tt", "tern"],
    ["aba", "bab", "abaaba", "bababa"],
    ["prefix", "prefixes", "suffix", "suffixes"],
    ["longer", "long", "lon", "ger"],
    ["abcabc", "bcabca", "cabcab"],
  ]
  let texts = [
    "abcdefg", "aaabaaaabaaa", "xyzabxyzab", "patternattic", "ababababababa", "prefix and suffix prefixes and suffixes",
    "longerlonglongerger", "abcabcabcabc",
  ]
  for case_idx = 0; case_idx < pattern_sets.length(); case_idx = case_idx + 1 {
    let patterns = pattern_sets[case_idx]
    let text = texts[case_idx]
    assert_naive_equivalence(patterns, text)
  }
}

///|
test "naive cross check with increasing pattern counts" {
  let base_text = "mississippi river mission"
  let collections = [
    ["mi"],
    ["mi", "issi"],
    ["mi", "issi", "iss", "miss"],
    ["mi", "issi", "iss", "miss", "mission"],
    ["mi", "issi", "iss", "miss", "mission", "river"],
    ["mi", "issi", "iss", "miss", "mission", "river", "r"],
    ["mi", "issi", "iss", "miss", "mission", "river", "r", "ri"],
  ]
  for i = 0; i < collections.length(); i = i + 1 {
    assert_naive_equivalence(collections[i], base_text)
  }
}

///|
test "naive cross check with varying text lengths" {
  let patterns = ["he", "her", "hers", "his", "is"]
  let texts = [
    "h", "he", "her", "hers", "his", "their history is here", "he is hers and he is his",
  ]
  for i = 0; i < texts.length(); i = i + 1 {
    assert_naive_equivalence(patterns, texts[i])
  }
}

///|
test "naive cross check with random like dataset" {
  let patterns = [
    "sun", "moon", "star", "planet", "galaxy", "universe", "nova", "cosmos", "asteroid",
    "meteor", "comet", "orbit",
  ]
  let texts = [
    "the sun, moon, and stars shine", "planet earth orbits the sun", "meteors and comets streak across the cosmos",
    "a nova within the galaxy brightens the universe", "asteroid belts orbit planets in the cosmos",
  ]
  for i = 0; i < texts.length(); i = i + 1 {
    assert_naive_equivalence(patterns, texts[i])
  }
}

///|
test "naive cross check for programming keywords" {
  let patterns = [
    "if", "else", "while", "for", "return", "break", "continue", "fn", "struct",
    "let", "mut", "pub", "use",
  ]
  let snippets = [
    "fn main() { let value = 0 }", "while true { break }", "for i in 0..10 { continue }",
    "pub struct Data { mut field : Int }", "if cond { return } else { use path }",
  ]
  for i = 0; i < snippets.length(); i = i + 1 {
    assert_naive_equivalence(patterns, snippets[i])
  }
}

///|
test "naive cross check for multilingual snippets" {
  let patterns = [
    "hola", "bonjour", "hello", "こんにちは", "你好", "안녕하세요", "hola hola",
    "bonjour!", "hello?", "にちは", "好", "녕",
  ]
  let texts = [
    "hola hello bonjour", "こんにちは 你好 안녕하세요", "hola hola! bonjour! hello?",
    "mixed scripts こんにちはhello你好", "안녕하세요? hola hola bonjour!",
  ]
  for i = 0; i < texts.length(); i = i + 1 {
    assert_naive_equivalence(patterns, texts[i])
  }
}

///|
test "custom alphabet size with naive check" {
  let patterns = ["abc", "bcd", "cde", "def"]
  let text = "abcdefghi"
  let automaton = ACAutomaton::new()
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "custom alphabet handles high byte characters" {
  let patterns = ["ã", "õ", "çã", "ção"]
  let text = "informação e ação com coração"
  assert_naive_equivalence(patterns, text)
}

///|
test "rebuild after every insertion" {
  let automaton = ACAutomaton::new()
  let patterns = ["cat", "cater", "caterpillar", "dog", "dodge", "dot"]
  let text = "the caterpillar dodged the dog"
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])
    automaton.build()
    let matches = automaton.query(text)
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    let subset : Array[String] = []
    for j = 0; j <= i; j = j + 1 {
      subset.push(patterns[j])
    }
    naive_fill_matches(subset, text, expected_start, expected_end, expected_idx)
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "clear and rebuild multiple rounds" {
  let rounds_patterns = [
    ["red", "green", "blue"],
    ["circle", "square", "triangle"],
    ["cat", "dog", "bird", "fish"],
    ["north", "south", "east", "west"],
  ]
  let rounds_texts = [
    "red green blue green", "circle square circle triangle", "dog and cat and fish and bird",
    "north east south west north",
  ]
  let automaton = ACAutomaton::new()
  for round = 0; round < rounds_patterns.length(); round = round + 1 {
    automaton.clear()
    for i = 0; i < rounds_patterns[round].length(); i = i + 1 {
      let _ = automaton.add_pattern(rounds_patterns[round][i])

    }
    let matches = automaton.query(rounds_texts[round])
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(
      rounds_patterns[round],
      rounds_texts[round],
      expected_start,
      expected_end,
      expected_idx,
    )
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "pattern count growth to triple digits" {
  let automaton = ACAutomaton::new()
  let patterns : Array[String] = []
  for i = 0; i < 120; i = i + 1 {
    let mut word = "p"
    for j = 0; j < i % 5; j = j + 1 {
      word += "q"
    }
    word += i.to_string()
    patterns.push(word)
    let id = automaton.add_pattern(word)
    assert_eq(id, i)
    assert_eq(automaton.pattern_count(), i + 1)
  }
  let text = "p0 p1 pq2 pqq3 pqqq4 pqqqq5 p0p1p2p3p4"
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "alphabet full byte coverage" {
  let patterns = [
    "\u0000\u0001", "\u0001\u0002", "\u0002\u0003", "\u0003\u0004", "\u0004\u0005",
  ]
  let text = "\u0000\u0001\u0002\u0003\u0004\u0005"
  assert_naive_equivalence(patterns, text)
}

///|
test "repeated queries with interleaved insertions" {
  let automaton = ACAutomaton::new()
  let text = "abracadabra abracadabra"
  let patterns = [
    ["abra"],
    ["abra", "cad"],
    ["abra", "cad", "dabra"],
    ["abra", "cad", "dabra", "acad"],
  ]
  for stage = 0; stage < patterns.length(); stage = stage + 1 {
    if stage > 0 {
      for i = 0; i < patterns[stage].length(); i = i + 1 {
        let mut exists = false
        for j = 0; j < patterns[stage - 1].length(); j = j + 1 {
          if patterns[stage][i] == patterns[stage - 1][j] {
            exists = true
            break
          }
        }
        if !exists {
          let _ = automaton.add_pattern(patterns[stage][i])

        }
      }
    } else {
      let _ = automaton.add_pattern("abra")

    }
    let matches = automaton.query(text)
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(
      patterns[stage],
      text,
      expected_start,
      expected_end,
      expected_idx,
    )
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "long pattern and long text alignment" {
  let patterns = [
    "lorem ipsum dolor sit amet", "ipsum", "dolor", "sit amet", "amet", "lorem",
  ]
  let text = "lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet"
  assert_naive_equivalence(patterns, text)
}

///|
test "suffix and prefix interplay" {
  let patterns = ["abcde", "bcde", "cde", "de", "e", "abc", "abcd", "bcd", "cd"]
  let text = "abcdeabcdeabcde"
  assert_naive_equivalence(patterns, text)
}

///|
test "query after partial match reset" {
  let patterns = ["abc", "bcd", "cde", "def"]
  let text = "abxyzdefabc"
  assert_naive_equivalence(patterns, text)
}

///|
test "large dictionary slices" {
  let automaton = ACAutomaton::new()
  let patterns : Array[String] = []
  let alphabet = ["a", "b", "c", "d", "e"]
  for i = 0; i < alphabet.length(); i = i + 1 {
    for j = 0; j < alphabet.length(); j = j + 1 {
      let mut pattern = alphabet[i]
      pattern += alphabet[j]
      patterns.push(pattern)
      let _ = automaton.add_pattern(pattern)

    }
  }
  for i = 0; i < alphabet.length(); i = i + 1 {
    let mut pattern = alphabet[i]
    pattern += alphabet[i]
    pattern += alphabet[i]
    patterns.push(pattern)
    let _ = automaton.add_pattern(pattern)

  }
  let text = "abcdeedcbaabcdeedcba"
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "stress test with repeated phrases" {
  let phrase = "to be or not to be"
  let mut text = phrase
  text += " that is the question "
  text += phrase
  text += " whether tis nobler "
  text += phrase
  let patterns = [
    "to", "be", "or", "not", "to be", "be or", "or not", "not to", "question", "nobler",
  ]
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with incremental alphabet expansion" {
  let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
  let patterns : Array[String] = []
  let mut text = ""
  for i = 0; i < letters.length(); i = i + 1 {
    text += letters[i]
    patterns.push(text)
  }
  let automaton = ACAutomaton::new()
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "stress test repeated build and query cycles" {
  let automaton = ACAutomaton::new()
  let patterns = [
    "alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota",
    "kappa",
  ]
  let text = "alpha beta gamma delta epsilon zeta eta theta iota kappa"
  for cycle = 0; cycle < 5; cycle = cycle + 1 {
    automaton.clear()
    for i = 0; i < patterns.length(); i = i + 1 {
      let _ = automaton.add_pattern(patterns[i])

    }
    automaton.build()
    let matches = automaton.query(text)
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(
      patterns, text, expected_start, expected_end, expected_idx,
    )
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "stress test alternating uppercase lowercase" {
  let patterns = [
    "Aa", "aA", "AA", "aa", "AaAa", "aAaA", "AaaA", "aaAA", "AaAA", "aaAa", "Aaaa",
    "aaaa", "AAAA",
  ]
  let text = "AaAaAaAa aAaAaA AAaaAAaa AAAAaaaa"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test numeric sequences" {
  let patterns = [
    "01", "12", "23", "34", "45", "56", "67", "78", "89", "90", "012", "123", "234",
    "345", "456", "567", "678", "789", "890", "901",
  ]
  let text = "012345678901234567890"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test long repeated pattern" {
  let pattern = "abcabcabcabcabcabc"
  let patterns = [pattern, "abcabc", "bcabca", "cabcab", "abc", "cab", "bca"]
  let mut text = pattern
  text += pattern
  text += "abcabc"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with palindromes" {
  let patterns = [
    "racecar", "level", "deed", "civic", "radar", "refer", "noon", "madam", "wow",
    "kayak",
  ]
  let text = "racecar level deed civic radar refer noon madam wow kayak"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with alternating words" {
  let patterns = [
    "yes", "no", "maybe", "yesno", "noyes", "yesmaybe", "maybeyes",
  ]
  let text = "yes no maybe yes no maybe yes no maybe"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with emoji" {
  let patterns = [
    "😀", "😁", "😂", "🤣", "😀😁", "😁😂", "😂🤣", "😀😂",
  ]
  let text = "😀😁😂🤣😀😁😂🤣"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with hierarchical prefixes" {
  let patterns = [
    "a", "ab", "abc", "abcd", "abcde", "abcdef", "abcdefg", "abcdefgh", "abcdefghi",
  ]
  let text = "abcdefghijklmnop"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test large repeated dictionary" {
  let automaton = ACAutomaton::new()
  let patterns : Array[String] = []
  for i = 0; i < 50; i = i + 1 {
    let mut pattern = "pattern"
    pattern += i.to_string()
    let _ = automaton.add_pattern(pattern)
    patterns.push(pattern)
  }
  let text = "pattern0 pattern1 pattern2 pattern3 pattern4 pattern5 pattern6 pattern7 pattern8 pattern9"
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "stress test extended whitespace" {
  let patterns = [" ", "  ", "   ", "    ", "\t", " \t", "\t "]
  let text = " \t  \t   \t    "
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test interleaved numbers and letters" {
  let patterns = [
    "a1", "1a", "a1a", "1a1", "a11", "11a", "a1a1", "1a1a", "aa11", "11aa", "a111",
    "111a", "aa111", "111aa",
  ]
  let text = "a1a11a1a a1a1 11aa a111 111aa"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test with alternating build and clear" {
  let automaton = ACAutomaton::new()
  let sequences = [
    ["one", "two", "three"],
    ["alpha", "beta"],
    ["red", "blue", "green", "yellow"],
    ["north", "south"],
  ]
  let texts = [
    "one two three two one three", "alpha beta alpha beta", "red green blue yellow red",
    "north south north south",
  ]
  for round = 0; round < sequences.length(); round = round + 1 {
    automaton.clear()
    for i = 0; i < sequences[round].length(); i = i + 1 {
      let _ = automaton.add_pattern(sequences[round][i])

    }
    automaton.build()
    let matches = automaton.query(texts[round])
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(
      sequences[round],
      texts[round],
      expected_start,
      expected_end,
      expected_idx,
    )
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "stress test verifying fail transitions" {
  let patterns = ["ab", "bab", "bc", "bca", "caa", "aab"]
  let text = "abccab"
  let automaton = ACAutomaton::new()
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  automaton.build()
  let matches = automaton.query(text)
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(patterns, text, expected_start, expected_end, expected_idx)
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "stress test large repeated query" {
  let automaton = ACAutomaton::new()
  let patterns = ["test", "testing", "tested", "tester"]
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let text = "testing tester tested test"
  for iteration = 0; iteration < 20; iteration = iteration + 1 {
    let matches = automaton.query(text)
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(
      patterns, text, expected_start, expected_end, expected_idx,
    )
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "stress test alternating insertions and queries" {
  let automaton = ACAutomaton::new()
  let patterns = [
    "alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota",
    "kappa",
  ]
  let text = "alpha beta gamma delta epsilon zeta eta theta iota kappa"
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])
    let subset : Array[String] = []
    for j = 0; j <= i; j = j + 1 {
      subset.push(patterns[j])
    }
    let matches = automaton.query(text)
    let expected_start : Array[Int] = []
    let expected_end : Array[Int] = []
    let expected_idx : Array[Int] = []
    naive_fill_matches(subset, text, expected_start, expected_end, expected_idx)
    assert_matches_unordered(
      matches, expected_start, expected_end, expected_idx,
    )
  }
}

///|
test "stress test with mirrored patterns" {
  let patterns = [
    "abc", "cba", "abcd", "dcba", "abcde", "edcba", "abba", "baab", "noon", "noon",
  ]
  let text = "abcba abcdcba abcdeedcba abba baab noon"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test combination of lengths" {
  let patterns = [
    "a", "be", "see", "deed", "eagle", "fable", "g", "hi", "ice", "joker", "kilo",
    "lemon", "memory", "night", "olive", "pearl", "query", "river", "stone", "tide",
  ]
  let text = "a be see deed eagle fable g hi ice joker kilo lemon memory night olive pearl query river stone tide"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test mixture of digits and words" {
  let patterns = [
    "1", "2", "3", "10", "20", "30", "one", "two", "three", "ten", "twenty", "thirty",
    "1one", "2two", "3three",
  ]
  let text = "1one 2two 3three 10 ten 20 twenty 30 thirty"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying no false positives" {
  let patterns = ["xyz", "uvw", "rst", "mnop"]
  let text = "abcdefghijkl"
  let automaton = ACAutomaton::new()
  for i = 0; i < patterns.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns[i])

  }
  let matches = automaton.query(text)
  assert_eq(matches.length(), 0)
}

///|
test "stress test with sequential clears" {
  let automaton = ACAutomaton::new()
  let patterns_round1 = ["alpha", "beta"]
  let patterns_round2 = ["gamma", "delta", "epsilon"]
  let _ = automaton.add_pattern("placeholder")
  automaton.clear()
  for i = 0; i < patterns_round1.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns_round1[i])

  }
  let matches1 = automaton.query("alpha beta gamma")
  let exp_start1 : Array[Int] = []
  let exp_end1 : Array[Int] = []
  let exp_idx1 : Array[Int] = []
  naive_fill_matches(
    patterns_round1, "alpha beta gamma", exp_start1, exp_end1, exp_idx1,
  )
  assert_matches_unordered(matches1, exp_start1, exp_end1, exp_idx1)
  automaton.clear()
  for i = 0; i < patterns_round2.length(); i = i + 1 {
    let _ = automaton.add_pattern(patterns_round2[i])

  }
  let matches2 = automaton.query("gamma delta epsilon")
  let exp_start2 : Array[Int] = []
  let exp_end2 : Array[Int] = []
  let exp_idx2 : Array[Int] = []
  naive_fill_matches(
    patterns_round2, "gamma delta epsilon", exp_start2, exp_end2, exp_idx2,
  )
  assert_matches_unordered(matches2, exp_start2, exp_end2, exp_idx2)
}

///|
test "stress test verifying single character alphabet" {
  let automaton = ACAutomaton::new()
  let _ = automaton.add_pattern("0")
  let _ = automaton.add_pattern("00")
  let _ = automaton.add_pattern("000")
  let matches = automaton.query("000000")
  let expected_start : Array[Int] = []
  let expected_end : Array[Int] = []
  let expected_idx : Array[Int] = []
  naive_fill_matches(
    ["0", "00", "000"],
    "000000",
    expected_start,
    expected_end,
    expected_idx,
  )
  assert_matches_unordered(matches, expected_start, expected_end, expected_idx)
}

///|
test "stress test verifying complex failure chains" {
  let patterns = ["abcd", "bcd", "cd", "d", "bcda", "cdaa", "daa", "aa"]
  let text = "abcdabcdaa"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying unicode combining marks" {
  let patterns = ["é", "é", "e"]
  let text = "ééeé"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying long sentence" {
  let patterns = [
    "the", "quick", "brown", "fox", "jumps", "over", "lazy", "dog", "the quick",
    "quick brown", "brown fox", "fox jumps", "jumps over", "over the", "the lazy",
    "lazy dog", "the quick brown fox",
  ]
  let text = "the quick brown fox jumps over the lazy dog"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying alternating languages" {
  let patterns = [
    "hola", "hello", "bonjour", "ciao", "hola hello", "hello bonjour", "bonjour ciao",
  ]
  let text = "hola hello bonjour ciao hola hello"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying substring removal" {
  let patterns = ["remove", "move", "ove", "ve", "rem", "emo", "mov"]
  let text = "remove move removal"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying repeated spaces" {
  let patterns = ["  ", "   ", "    ", "     "]
  let text = "       "
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying digits in sentences" {
  let patterns = ["year", "2024", "202", "024", "24", "year 2024", "24 year"]
  let text = "the year 2024 is special"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying uppercase sentences" {
  let patterns = [
    "THE", "QUICK", "BROWN", "FOX", "THE QUICK", "QUICK BROWN", "BROWN FOX",
  ]
  let text = "THE QUICK BROWN FOX"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying digits only text" {
  let patterns = ["123", "234", "345", "456", "567", "678", "789", "890"]
  let text = "1234567890"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying repeated alphabets" {
  let patterns = [
    "abc", "bcd", "cde", "def", "efg", "fgh", "ghi", "hij", "ijk", "abcd", "bcde",
    "cdef", "defg", "efgh", "fghi", "ghij",
  ]
  let text = "abcdefghijklmnopqrstuvwxyz"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying partial overlaps" {
  let patterns = ["abc", "bcd", "cde", "def", "efg", "fgh"]
  let text = "abcdefgh"
  assert_naive_equivalence(patterns, text)
}

///|
test "stress test verifying repeated sequences" {
  let patterns = ["aba", "bab", "abab", "baba", "ababa", "babab"]
  let text = "ababababab"
  assert_naive_equivalence(patterns, text)
}
