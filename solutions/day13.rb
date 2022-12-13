
def parse_arr str
    i = 0
    arr = []
    while i < str.length 
        if str[i] == ','
            i = i + 1       
        elsif str[i] == '['
            j, item = parse_arr(str[i+1..])
            arr.append(item)
            i = i + j + 1
        elsif str[i] == ']'
            return i+1, arr
        else
            arr.append(str[i..].to_i)
            i = str.index(/[,\]]/, i)         
        end
    end
end

def compare_arr a, b
    for i in 0..[a.length, b.length].min-1 do
        if (a[i].is_a? Integer) && (b[i].is_a? Integer)
            ret = b[i] <=> a[i]
        elsif (a[i].is_a? Integer)
            ret = compare_arr([a[i]], b[i])
        elsif (b[i].is_a? Integer)
            ret = compare_arr(a[i], [b[i]])
        else 
            ret = compare_arr(a[i], b[i])
        end
        if ret != 0
            return ret
        end
    end
    b.length <=> a.length
end 

file = File.open("../inputs/day13.txt")

file_data = file.readlines.map(&:chomp)

file.close


all = [[[2]], [[6]]]
part_1 = 0
for (a, b, _), i in file_data.each_slice(3).with_index
    _, arr = parse_arr a[1..]
    _, brr = parse_arr b[1..]

    all.append arr 
    all.append brr

    if compare_arr(arr, brr) == 1 
        part_1 = part_1 + i + 1
    end
end

all = all.sort { |a, b| compare_arr(b, a) }
part_2 = (all.index([[2]]) + 1) * (all.index([[6]]) + 1)

print "Part 1: ", part_1, "\n"
print "Part 2: ", part_2, "\n"