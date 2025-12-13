note
	description: "Tests for SIMPLE_REGEX"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Basic Matching

	test_basic_match
			-- Test basic pattern matching.
		note
			testing: "covers/{SIMPLE_REGEX}.match"
		local
			regex: SIMPLE_REGEX
			match: SIMPLE_REGEX_MATCH
		do
			create regex.make_from_pattern ("hello")
			assert_true ("compiled", regex.is_compiled)
			match := regex.match ("hello world")
			assert_true ("matched", match.is_matched)
			assert_strings_equal ("value", "hello", match.value)
		end

	test_no_match
			-- Test when pattern doesn't match.
		note
			testing: "covers/{SIMPLE_REGEX}.match"
		local
			regex: SIMPLE_REGEX
			match: SIMPLE_REGEX_MATCH
		do
			create regex.make_from_pattern ("xyz")
			match := regex.match ("hello world")
			assert_false ("not matched", match.is_matched)
		end

feature -- Test: Character Classes

	test_digit_class
			-- Test \d character class.
		note
			testing: "covers/{SIMPLE_REGEX}.match"
		local
			regex: SIMPLE_REGEX
			match: SIMPLE_REGEX_MATCH
		do
			create regex.make_from_pattern ("\d+")
			match := regex.match ("abc123def")
			assert_true ("matched", match.is_matched)
			assert_strings_equal ("digits", "123", match.value)
		end

	test_word_class
			-- Test \w character class.
		note
			testing: "covers/{SIMPLE_REGEX}.match"
		local
			regex: SIMPLE_REGEX
			match: SIMPLE_REGEX_MATCH
		do
			create regex.make_from_pattern ("\w+")
			match := regex.match ("hello world")
			assert_true ("matched", match.is_matched)
			assert_strings_equal ("word", "hello", match.value)
		end

feature -- Test: Find All

	test_find_all
			-- Test finding all matches.
		note
			testing: "covers/{SIMPLE_REGEX}.find_all"
		local
			regex: SIMPLE_REGEX
			matches: SIMPLE_REGEX_MATCH_LIST
		do
			create regex.make_from_pattern ("\d+")
			matches := regex.find_all ("a1b22c333")
			assert_integers_equal ("three matches", 3, matches.count)
		end

feature -- Test: Replace

	test_replace_first
			-- Test replacing first match.
		note
			testing: "covers/{SIMPLE_REGEX}.replace_first"
		local
			regex: SIMPLE_REGEX
			result: STRING
		do
			create regex.make_from_pattern ("world")
			result := regex.replace_first ("hello world world", "there")
			assert_strings_equal ("replaced", "hello there world", result)
		end

	test_replace_all
			-- Test replacing all matches.
		note
			testing: "covers/{SIMPLE_REGEX}.replace_all"
		local
			regex: SIMPLE_REGEX
			result: STRING
		do
			create regex.make_from_pattern ("o")
			result := regex.replace_all ("hello", "0")
			assert_strings_equal ("all replaced", "hell0", result)
		end

feature -- Test: Builder

	test_builder_literal
			-- Test regex builder with literal.
		note
			testing: "covers/{SIMPLE_REGEX_BUILDER}.literal"
		local
			builder: SIMPLE_REGEX_BUILDER
			regex: SIMPLE_REGEX
		do
			create builder.make
			regex := builder.literal ("test").build
			assert_true ("compiled", regex.is_compiled)
			assert_true ("matches", regex.match ("test string").is_matched)
		end

	test_builder_digit
			-- Test regex builder with digit.
		note
			testing: "covers/{SIMPLE_REGEX_BUILDER}.digit"
		local
			builder: SIMPLE_REGEX_BUILDER
			regex: SIMPLE_REGEX
		do
			create builder.make
			regex := builder.digit.one_or_more.build
			assert_true ("matches digits", regex.match ("abc123").is_matched)
		end

feature -- Test: Match Positions

	test_match_position
			-- Test match start and end positions.
		note
			testing: "covers/{SIMPLE_REGEX_MATCH}.start_position"
			testing: "covers/{SIMPLE_REGEX_MATCH}.end_position"
		local
			regex: SIMPLE_REGEX
			match: SIMPLE_REGEX_MATCH
		do
			create regex.make_from_pattern ("world")
			match := regex.match ("hello world")
			assert_true ("matched", match.is_matched)
			assert_integers_equal ("start", 7, match.start_position)
			assert_integers_equal ("end", 11, match.end_position)
		end

end
