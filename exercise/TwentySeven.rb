def characters(filename)
    File.foreach(filename) do |line| 
        line.split('').each do |c|
            yield(c)
        end
    end
end

def all_words(filename)
    start_char = true
    word = ""
    characters(filename) do |c| 
        if start_char == true
            word = ""
            if c.match(/^[[:alpha:]]$/)
                word = c.downcase
                start_char = false
            else
            end
        else
            if c.match(/^[[:alpha:]]$/)
                word.concat(c.downcase)
            else
                start_char = true
                yield(word)
            end
        end
    end
end
            
def non_stop_words(filename)
    stopwords = File.read("../stop_words.txt").split(",").concat(Array("a".."z"))
    
    all_words(filename) do |word| 
        if !stopwords.include?(word)
            yield(word)
        end
    end
end

def count_and_sort(filename)
    freqs = Hash.new

    i = 1

    non_stop_words(filename) do |word|
        if !freqs.key?(word)
            freqs[word] = 1
        else
            freqs[word] = freqs[word] + 1
        end

        if i % 5000 == 0
            yield freqs.sort_by{|w,c| c}.reverse
        end

        i = i+1
    end

    yield freqs.sort_by{|w,c| c}.reverse
end


count_and_sort(ARGV[0]) do |sorted| 
    puts("----------------------------------")
    for (w, c) in sorted[0..25]
        puts w+ ' - '+ c.to_s
    end
end
