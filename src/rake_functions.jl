"Return text with all redundant whitespace removed"
function remove_redundant_whitespace(text)
    cleaned_text = string(text[1])
    previous_c = text[1]
    for i in 2:length(text)
        c = text[i]
        if !(previous_c == ' ' && c == ' ')
            cleaned_text *= string(c)
        end
        previous_c = c
    end
    # Finally remove whitespaces from start and end
    return strip(cleaned_text)
end

"Utility function which turns vector of vectors into vector by concatenating them together"
function flatten(arr::Vector{Vector{T}}) where {T}
    flattened_arr = arr[1]
    for i = 2:length(arr)
        append!(flattened_arr, arr[i])
    end
    return flattened_arr
end

"Split text at stopwords to produce a vector of strings"
function split_at_stopwords(rake_config, text)
    phrases = SubString{String}[]
    for sentence in sentences
        phrases_in_sentence = String[]
        for stop_word in rake_config.stop_words
            # Split up each phrase on stopword, then flatten into one vector again
            phrases_in_sentence = flatten(split.(phrases_in_sentence, stop_word))
        end
        append(!phrases, phrase_in_sentences)
    end
    return phrases
end


"Take vector of strings and split each string into all possible keyphrases"
function find_all_possible_keyphrases(phrases, max_phrase_length::Int)
    all_possible_keyphrases = Array(String,0)
    for sentence in phrases
        split_sentence = split.(sentence, ' ')
        for j = 1: max_phrase_length
            for i = 1:(length(split_sentence)-j)
                push!(all_possible_keyphrases, join(split_sentence[i:i+j]), " ")
            end
        end
    end
    return all_possible_keyphrases
end

"Score all keywords using a variety of scoring techniques"
function calculate_keyphrase_scores(all_possible_keyphrases)::Vector{Tuples{String, Score}}
    keyphrases = unique(all_possible_keyphrases)
    d = Dict([(i, count(x->x==i,all_possible_keyphrases)) for i in keyphrases])
    return keyphrase_with_score_tuples
end

"Utility function to test if string is a float"
function isa_numberstring(s)
    try
        parse(Float64, s)
        return True
    catch
        return False
    end
end
