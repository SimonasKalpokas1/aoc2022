local file = io.open("../inputs/day09.txt", 'r')
data = file:read("*a")
file:close()

Rope = {}
for i=1,10 do Rope[i] = {0, " ", 0} end

visited1 = { ["0 0"] = true }
visited2 = { ["0 0"] = true }
count1 = 1
count2 = 1

for str in string.gmatch(data, "[A-Z] [0-9]+[\r\n]*") do
    direction = string.sub(str, 1, 1)
    amount = tonumber(string.match(str, "[0-9]+"))
    for i=1,amount do
        if     direction == "R" then Rope[1][1] = Rope[1][1] + 1
        elseif direction == "D" then Rope[1][3] = Rope[1][3] - 1
        elseif direction == "L" then Rope[1][1] = Rope[1][1] - 1
        elseif direction == "U" then Rope[1][3] = Rope[1][3] + 1
        end

        for i=2,10 do
            diff1 = Rope[i-1][1] - Rope[i][1]
            diff2 = Rope[i-1][3] - Rope[i][3]
            if math.abs(diff1) > 1 then 
                Rope[i][1] = Rope[i][1] + diff1//math.abs(diff1)
                if Rope[i-1][3] ~= Rope[i][3] then Rope[i][3] = Rope[i][3] + diff2//math.abs(diff2) end        
            elseif math.abs(diff2) > 1 then 
                Rope[i][3] = Rope[i][3] + diff2//math.abs(diff2)
                if Rope[i-1][1] ~= Rope[i][1] then Rope[i][1] = Rope[i][1] + diff1//math.abs(diff1) end
            else 
                break
            end
            
            coords1 = table.concat(Rope[2])
            if not visited1[coords1] then
                visited1[coords1] = true
                count1 = count1 + 1
            end

            coords2 = table.concat(Rope[10])
            if not visited2[coords2] then
                visited2[coords2] = true
                count2 = count2 + 1
            end
        end 
    end
end

print("Part 1:", count1)
print("Part 2:", count2)