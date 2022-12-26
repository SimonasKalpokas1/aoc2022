
f = open("../inputs/day17.txt", "r")
directions = readline(f)
close(f)

rock_shapes = [
    ["####"],
    [".#.", "###", ".#."],
    ["..#", "..#", "###"],
    ["#", "#", "#", "#"],
    ["##", "##"]
]

grid_width = 7
grid = [repeat(['.'], grid_width) for _ in 0:6000]
pushfirst!(grid, repeat(['#'], grid_width))
heights = repeat([1], grid_width)

function jet_push_rock(rock_x, direction)
    if direction == '<'
        return rock_x - 1
    elseif direction == '>'
        return rock_x + 1
    else
        println("Incorrect direction: ", direction)
        exit(1)
    end
end

function is_position_valid(rock_shape, rock_x, rock_y)
    if rock_x == 0 || rock_x + length(rock_shape[1]) - 1 > grid_width
        return false
    end

    for (row_ind, row) in enumerate(rock_shape)
        for (cell_ind, cell) in enumerate(row)
            if cell == '#' && grid[rock_y-row_ind+1][rock_x+cell_ind-1] == '#'
                return false
            end
        end
    end
    return true
end

function jet_try_push_rock(rock_shape, rock_x, rock_y, direction)
    new_x = jet_push_rock(rock_x, direction)
    if is_position_valid(rock_shape, new_x, rock_y)
        return (new_x, rock_y)
    else
        return (rock_x, rock_y)
    end
end

function place_rock(rock_shape, rock_x, rock_y, recalculate_height)
    for (row_ind, row) in enumerate(rock_shape)
        for (cell_ind, cell) in enumerate(row) 
            if cell == '#'
                if grid[rock_y - row_ind + 1][rock_x + cell_ind - 1] == '#'
                    println("Unexpected clash")
                    exit(1)
                end
                grid[rock_y - row_ind + 1][rock_x + cell_ind - 1] = '#'
                if recalculate_height && heights[rock_x + cell_ind - 1] < rock_y - row_ind + 1
                    heights[rock_x + cell_ind - 1] = rock_y - row_ind + 1
                end
            end
        end
    end
end

repetition_correction = 0
relative_heights_dict = Dict()
direction_ind = 0
max_rocks = 1000000000000

i = 0
while i < max_rocks
    global i, repetition_correction
    if repetition_correction == 0 && i % length(rock_shapes) == 0
        min_height = minimum(heights)
        relative_heights = map((h) -> h - min_height, heights)
        push!(relative_heights, direction_ind % length(directions))
        current = get(relative_heights_dict, relative_heights, -1)
        if current != -1 
            rocks_left = (max_rocks-current[1])
            repetition_correction = (rocks_left ÷ (i - current[1]) - 1) * (min_height - current[2])
            i = max_rocks - rocks_left % (i - current[1])
        end
        relative_heights_dict[relative_heights] = (i, min_height)
    end

    if i == 2022
        println("Part 1: ", maximum(heights) - 1)
    end
    
    rock_shape = rock_shapes[i % length(rock_shapes) + 1]
    x, y = (3, maximum(heights) + length(rock_shape) + 3)
    
    while is_position_valid(rock_shape, x, y) 
        global direction_ind
        direction = direction_ind % length(directions) + 1
        x, y = jet_try_push_rock(rock_shape, x, y, directions[direction])
        direction_ind += 1
        y -= 1
    end
    y += 1
    place_rock(rock_shape, x, y, true)
    i += 1
end

println("Part 2: ", repetition_correction + maximum(heights)-1)