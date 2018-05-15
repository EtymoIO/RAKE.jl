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
# TODO make more efficient, alter functions so dont need try catch, fix spacing issue 
function split_at_stopwords(text, stopwords)
    phrases = SubString{String}[]
    for sentence in text
        phrases_in_sentence = [sentence]
        phrases_in_sentence2 = SubString{String}[]
        for stop_word in stopwords
            stop_word = stop_word*" "
            for i in range(1, length(phrases_in_sentence))
                # Split up each phrase on stopword, then flatten into one vector again
                try
                    append!(phrases_in_sentence2, split(phrases_in_sentence[i], stop_word))
                catch(MethodError) # error when splitting character
                    append!(phrases_in_sentence2, phrases_in_sentence[i])
                end
            end
            phrases_in_sentence = phrases_in_sentence2
            phrases_in_sentence2 = SubString{String}[]
        end
        try
            append!(phrases, flatten(phrases_in_sentence))
        catch(MethodError) # error when 1D array
            append!(phrases, phrases_in_sentence)
        end
    end
    return phrases
end


"Take vector of strings and split each string into all possible keyphrases"
function find_all_possible_keyphrases(phrases, max_phrase_length::Int)
    all_possible_keyphrases = Array(String,0)
    for sentence in phrases
        split_sentence = split.(sentence, ' ')
        for j = 0: max_phrase_length-1
            for i = 1:(length(split_sentence)-j)
                push!(all_possible_keyphrases, join(split_sentence[i:i+j], " "))
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
