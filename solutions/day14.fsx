// Run with 'dotnet fsi .\day14.fsx'
open System.IO

let lines =
    File.ReadLines("../inputs/day14.txt")
    |> Seq.map (fun line -> line.Split "->" |> Seq.map (fun cell -> cell.Trim().Split(',') |> Array.map int))

let max_y =
    2
    + (Seq.map (fun line -> Seq.reduce max (Seq.map (fun (coords: int[]) -> coords[1]) line)) lines
       |> Seq.reduce max)

let min_x = 500 - max_y - 2
let max_x = 500 + max_y + 2

let grid = [| for _ in 0..max_y -> (Array.zeroCreate (max_x - min_x)) |]

for t in 0 .. max_x - min_x - 1 do
    grid[max_y][t] <- 1

for line in lines |> Seq.map (fun coords -> Seq.zip coords (Seq.tail coords)) do
    for (a, b) in line do
        if a[0] <> b[0] then
            for i in min a[0] b[0] .. max a[0] b[0] do
                grid[a[1]][i - min_x] <- 1
        else
            for i in min a[1] b[1] .. max a[1] b[1] do
                grid[i][a[0] - min_x] <- 1

let start_x = 500 - min_x
let start_y = 0
let mutable count = 0
let mutable part_1_is_Done = false
let mutable bigBreak = false

while not bigBreak do
    let mutable x = start_x
    let mutable y = start_y
    let mutable Break = false

    if grid[y][x] <> 0 then
        bigBreak <- true
        Break <- true

    while not Break do
        if grid[y + 1][x] = 0 then
            y <- y + 1
        elif grid[y + 1][x - 1] = 0 then
            y <- y + 1
            x <- x - 1
        elif grid[y + 1][x + 1] = 0 then
            y <- y + 1
            x <- x + 1
        else
            grid[y][x] <- 2

            if not part_1_is_Done && y = max_y - 1 then
                part_1_is_Done <- true
                printfn "Part 1: %d" count

            count <- count + 1
            Break <- true

    if not Break then
        bigBreak <- true


printfn "Part 2: %d" count
