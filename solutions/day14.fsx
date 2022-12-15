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

let rec dfs ((x, y): int * int) (grid: int[][]) : option<int> * int =
    if grid[y][x] <> 0 then
        (None, 0)
    elif y = max_y - 1 then
        grid[y][x] <- 1
        (Some(0), 1)
    else
        let (down_p1, down_p2) = dfs (x, y + 1) grid
        let (left_down_p1, left_down_p2) = dfs (x - 1, y + 1) grid
        let (right_down_p1, right_down_p2) = dfs (x + 1, y + 1) grid
        let p1s = [ down_p1; left_down_p1; right_down_p1 ]
        let p2s = [ down_p2; left_down_p2; right_down_p2 ]
        grid[y][x] <- 1
        (p1s
         |> List.tryFindIndex Option.isSome
         |> Option.map (fun ind -> List.take ind p2s |> List.fold (+) 0 |> (+) <| (Option.get p1s[ind])),
         (List.reduce (+) p2s) + 1)

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

let part_1, part_2 = dfs (start_x, start_y) grid

printfn "Part 1: %d" (Option.get part_1)
printfn "Part 2: %d" part_2
