using RAKE
using Base.Test

@testset "remove_redundant_whitespace"
begin
    @test remove_redundant_whitespace(" a") == "a"
    @test remove_redundant_whitespace(" a  b") == "a b"
    @test remove_redundant_whitespace("Bob  the builder") == "Bob the builder"
end

@testset "flatten"
begin
    @test flatten([["a", "rabbit"],["a", "frog"]]) == ["a", "rabbit", "a", "frog"]
    @test flatten([["a"], ["rabbit"],["a", "frog"]]) == ["a", "rabbit", "a", "frog"]
end

@testset "split_at_stopwords"
begin
    @test split_at_stopwords(["Bob the builder"], ["the"]) == ["Bob", "builder"]
    #@test split_at_stopwords(["In mathematics a matrix is a rectangular array of numbers arranged in rows and columns"], ["In", "a", "is", "of", "in", "and"])
    #     == ["In mathematics", "matrix", ]
end

@testset
begin
    @test find_all_possible_keyphrases(["shops"], 2) == ["shops"]
    @test find_all_possible_keyphrases(["I once walked"], 5) ==  ["I", "once", "walked", "I once", "once walked", "I once walked"]
    @test find_all_possible_keyphrases(["I once walked to the shops"], 2) ==
        ["I", "once", "walked", "to", "the", "shops", "I once", "once walked", "walked to", "to the", "the shops"]
end
