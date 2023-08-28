open Stdio

type value = 
  | Int of int
  | Function of (int -> int)

type job = 
  | Value of value
  | Operation of string * string * (value -> value -> value)

let multiply (a : value) (b : value): value =
  match a, b with
  | Int a, Int b -> Int (a * b)
  | Function f, Int b -> Function (fun y -> f (y / b))
  | Int a, Function f -> Function (fun y -> f (y / a))
  | Function _, Function _ -> failwith "invalid operation"

let divide (a : value) (b : value): value =
  match a, b with
  | Int a, Int b -> Int (a / b)
  | Function f, Int b -> Function (fun y -> f (y * b))
  | Int a, Function f -> Function (fun y -> f (a / y))
  | Function _, Function _ -> failwith "invalid operation"
  
let add (a : value) (b : value): value =
  match a, b with
  | Int a, Int b -> Int (a + b)
  | Function f, Int b -> Function (fun y -> f (y - b))
  | Int a, Function f -> Function (fun y -> f (y - a))
  | Function _, Function _ -> failwith "invalid operation"
  
let subtract (a : value) (b : value): value =
  match a, b with
  | Int a, Int b -> Int (a - b)
  | Function f, Int b -> Function (fun y -> f (y + b))
  | Int a, Function f -> Function (fun y -> f (a - y))
  | Function _, Function _ -> failwith "invalid operation"
  
let equal (a : value) (b : value): value =
  match a, b with
  | Function f, Int b -> Int (f b)
  | Int a, Function f -> Int (f a)
  | _, _ -> failwith "invalid operation"
  
let is_digit digit =
  match digit with
  | '0' .. '9' -> true
  | _ -> false

let split_line line =
  let parts = String.split_on_char ':' line in
  match parts with
  | [a; b] -> (a, String.trim b)
  | _ -> failwith "invalid line"

let parse_job str = 
  match is_digit str.[0] with
  | true -> Value (Int (int_of_string str))
  | false -> 
      match String.split_on_char ' ' str with
      | [a; b; c] -> Operation (a, c, 
        match b with
        | "*" -> multiply
        | "/" -> divide
        | "+" -> add
        | "-" -> subtract
        | "=" -> equal
        | _ -> failwith "invalid command")
      | _ -> failwith "invalid line"
      
let create_hash_table lines =
  let hash_table = Hashtbl.create (List.length lines) in
    List.iter (fun line -> 
      let (key, value) = split_line line in
      Hashtbl.add hash_table key (parse_job value)) lines;
    hash_table
    
let rec get_value hash_table key =
  match Hashtbl.find hash_table key with
  | Value i -> i
  | Operation (a, b, f) -> f (get_value hash_table a) (get_value hash_table b)
  | exception Not_found -> failwith "invalid key"
  
let lines = In_channel.read_lines "../inputs/day21.txt"
  
let part1 = 
  match get_value (create_hash_table lines) "root" with
  | Int i -> i
  | _ -> failwith "invalid value"

let part2 = 
  let hash_table = create_hash_table lines in
    Hashtbl.add hash_table "humn" (Value (Function (fun x -> x)));
    Hashtbl.add hash_table "root" (match Hashtbl.find hash_table "root" with
      | Operation (a, b, _) -> Operation (a, b, equal)
      | _ -> failwith "invalid root");
    match get_value hash_table "root" with
    | Int i -> i
    | _ -> failwith "invalid value"

let () = printf "Part 1: %d\n" part1
let () = printf "Part 2: %d\n" part2