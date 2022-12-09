local file = io.open("../inputs/day09.txt", 'r')
data = file:read("*a")
file:close()

H = {0, 0}
T = {0, " ", 0}

visited = {}
count = 0

for str in string.gmatch(data, "[A-Z] [0-9]+[\r\n]*") do
    direction = string.sub(str, 1, 1)
    amount = tonumber(string.match(str, "[0-9]+"))
    for i=1,amount do
        if     direction == "R" then H[1] = H[1] + 1
        elseif direction == "D" then H[2] = H[2] - 1
        elseif direction == "L" then H[1] = H[1] - 1
        elseif direction == "U" then H[2] = H[2] + 1
        end

        if math.abs(H[1] - T[1]) > 1 then 
            T[1] = T[1] + (H[1] - T[1])//2 
            if H[2] ~= T[3] then T[3] = H[2] end        
        elseif math.abs(H[2] - T[3]) > 1 then 
            T[3] = T[3] + (H[2] - T[3])//2 
            if H[1] ~= T[1] then T[1] = H[1] end        
        end

        coords = table.concat(T)

        if not visited[coords] then
            visited[coords] = true
            count = count + 1
        end
    end   
end

print("Part 1:", count)
Rope = {}

for i=1,10 do Rope[i] = {0, " ", 0} end

visited = {}
count = 0

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
                Rope[i][1] = Rope[i][1] + (diff1 - (diff1)//math.abs(diff1)) 
                if Rope[i-1][3] ~= Rope[i][3] then Rope[i][3] = Rope[i][3] + (Rope[i-1][3] - Rope[i][3])//math.abs(Rope[i-1][3] - Rope[i][3]) end        
            elseif math.abs(diff2) > 1 then 
                Rope[i][3] = Rope[i][3] + (diff2 - (diff2)//math.abs(diff2)) 
                if Rope[i-1][1] ~= Rope[i][1] then Rope[i][1] = Rope[i][1] + (Rope[i-1][1] - Rope[i][1])//math.abs(Rope[i-1][1] - Rope[i][1]) end
            else 
                break
            end

            coords = table.concat(Rope[10])

            if not visited[coords] then
                visited[coords] = true
                count = count + 1
            end
        end 
    end
end

print("Part 2:", count)