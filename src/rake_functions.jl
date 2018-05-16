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

# If it is not Vector of Vectors, return it unchanged
flatten(arr::Vector) = arr

"Split text at stopwords to produce a vector of strings"
function split_at_stopwords(text::Union{Vector{SubString{String}},Vector{String}}, stopwords::Vector{String})::Vector{Vector{SubString{String}}}

    # A phrase is a vector of words
    phrases = Vector{Vector{SubString{String}}}(0)
    current_phrase = Vector{SubString{String}}(0)

    for sentence in text

        words_in_sentence = split(sentence, ' ')
        for word in words_in_sentence
            stopword_found = false
            for stopword in stopwords
                if lowercase(word) == stopword
                    stopword_found = true
                    break
                end
            end

            if stopword_found
                if length(current_phrase) > 0
                    push!(phrases, current_phrase)
                    current_phrase = Vector{SubString{String}}(0)
                end
            else
                push!(current_phrase, word)
            end
        end

        if length(current_phrase) > 0
            push!(phrases, current_phrase)
        end

    end

    return phrases
end


"Take vector of strings and split each string into all possible keyphrases"
function find_all_possible_keyphrases(phrases, max_phrase_length::Int)
    all_possible_keyphrases = Array{String}(0)
    for phrase in phrases
        for j = 0: max_phrase_length-1
            for i = 1:(length(phrase)-j)
                push!(all_possible_keyphrases, join(phrase[i:i+j], " "))
            end
        end
    end
    return all_possible_keyphrases
end

"Score all keywords using a variety of scoring techniques"
function calculate_keyphrase_scores(all_possible_keyphrases)
    keyphrases = unique(all_possible_keyphrases)
    d = Dict([(i, count(x->x==i,all_possible_keyphrases)) for i in keyphrases])
    return d
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
