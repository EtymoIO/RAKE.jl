using RAKE
# Explicitly import some of the internal functions which aren't exported
import RAKE: flatten, split_at_stopwords, find_all_possible_keyphrases
using Base.Test

@testset "RAKE" begin
    @testset "remove_redundant_whitespace" begin
        @test remove_redundant_whitespace(" a") == "a"
        @test remove_redundant_whitespace(" a  b") == "a b"
        @test remove_redundant_whitespace("Bob  the builder") == "Bob the builder"
    end

    @testset "flatten" begin
        @test flatten([["a", "rabbit"],["a", "frog"]]) == ["a", "rabbit", "a", "frog"]
        @test flatten([["a"], ["rabbit"],["a", "frog"]]) == ["a", "rabbit", "a", "frog"]
    end

    @testset "split_at_stopwords" begin
        substringify(str_vec) = SubString{String}.(str_vec)
        @test split_at_stopwords([SubString{String}("Bob the builder")], ["the"]) == substringify.([["Bob"], ["builder"]])
        @test split_at_stopwords(["Bob the builder"], ["the"]) == substringify.([["Bob"], ["builder"]])

        @test (split_at_stopwords(["Bobby Bobbington the brilliantly bold builder and Bill"], ["the", "and"]) == [
            SubString{String}.(["Bobby","Bobbington"]),
            SubString{String}.(["brilliantly","bold","builder"]),
            SubString{String}.(["Bill"])
        ])

        begin
            sentences = ["In mathematics a matrix is a rectangular array of numbers arranged in rows and columns"]
            stopwords = ["in", "a", "is", "of", "in", "and"]
            phrases = substringify.([["mathematics"], ["matrix"], ["rectangular", "array"], ["numbers", "arranged"], ["rows"], ["columns"]])
            @test split_at_stopwords(sentences, stopwords) == phrases
        end
    end

    @testset "Find all possible keyphrases" begin
        @test find_all_possible_keyphrases([["shops"]], 2) == ["shops"]
        @test find_all_possible_keyphrases([["I", "once", "walked"]], 5) ==  ["I", "once", "walked", "I once", "once walked", "I once walked"]

        begin
            phrases = [["deep", "convolutional", "neural", "networks"]]
            one_grams = ["deep", "convolutional", "neural", "networks"]
            two_grams = ["deep convolutional", "convolutional neural", "neural networks"]
            three_grams = ["deep convolutional neural", "convolutional neural networks"]
            four_grams = ["deep convolutional neural networks"]

            @test find_all_possible_keyphrases(phrases, 1) == one_grams
            @test find_all_possible_keyphrases(phrases, 2) == vcat(one_grams, two_grams)
            @test find_all_possible_keyphrases(phrases, 3) == vcat(one_grams, two_grams, three_grams)
            @test find_all_possible_keyphrases(phrases, 4) == vcat(one_grams, two_grams, three_grams, four_grams)
        end
    end
end
