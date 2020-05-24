require "set"

all_words = [(), nil]
stop_words = [(), nil]

non_stop_words = [(), lambda do 
    all_words[0].select{ |word| !stop_words[0].include?(word) && word != ""}
end]

unique_words = [(), lambda do
    Set.new(non_stop_words[0])
end
]

counts = [(), lambda do
    Hash[unique_words[0].collect {|w| [w, non_stop_words[0].count(w)]}]
end]

sorted_data = [(), lambda do
    counts[0].sort_by{|w,c| c}.reverse
end]

$all_columns = [all_words, stop_words, non_stop_words, unique_words, counts, sorted_data]

def update()
    $all_columns.each do |c|
        if c[1] != nil
            c[0] = c[1].call
        end
    end
end

all_words[0] = File.read(ARGV[0]).split(/[\W_]+/).map(&:downcase)
stop_words[0] = File.read("../stop_words.txt").split(",").concat(Array("a".."z"))


update()

for (w, c) in sorted_data[0][0..25]
    puts w+ ' - '+ c.to_s
end


$end = false


while !$end
    file_path = ""
    print "\nEnter file path to run: (enter 'quit' to exit program)\n"
    STDOUT.flush
    file_path = STDIN.gets.chomp

    if file_path != "quit"
        all_words[0].concat(File.read(file_path).split(/[\W_]+/).map(&:downcase))
        update()

        for (w, c) in sorted_data[0][0..25]
            puts w+ ' - '+ c.to_s
        end
    else
        puts "\nGoodbye!"
        $end = true
    end
end


