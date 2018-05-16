mutable struct Rake
    stop_words::Vector{String}
    min_char_length::Int
    max_words_length::Int
    min_keyword_frequency::Int
    min_words_length_adj::Int
    max_words_length_adj::Int
    min_phrase_freq_adj::Int
end

struct Score
    rank::Float64
    frequency::Int
end

function Rake(stop_words; min_char_length=3, max_words_length=3, min_keyword_frequency=10,
              min_words_length_adj=1, max_words_length_adj=1, min_phrase_freq_adj=2)
    Rake(stop_words, min_char_length, max_words_length, min_keyword_frequency,
         min_words_length_adj, max_words_length_adj, min_phrase_freq_adj)
end

import Base.run

function run(self::Rake, text)

    # Convert all multiple whitespace to single whitespace
    cleaned_text = remove_redundant_whitespace(text)

    # Convert to lower case
    cleaned_text = lowercase(cleaned_text)

    # Split on punctuation
    split_on = ['.', '?', '!', '\n', ';', ',', ':', '\u2019', '\u2013']
    sentences = split(cleaned_text, split_on)

    # Split on stopwords
    phrases = split_at_stopwords(sentences, Rake.stop_words)

    # Find all possible keywords
    all_possible_keyphrases = find_all_possible_keyphrases(phrases)

    # Score all possible keywords
    keyphrase_with_score = calculate_keyphrase_scores(all_possible_keyphrases)

    # Function to compare our (keyword, score) tuples
    #tuple_compare(x,y) = x[2].rank > y[2].rank
    #sorted_keywords = sort(keyword_candidates, lt=tuple_compare)

    return keyphrase_with_score
end
