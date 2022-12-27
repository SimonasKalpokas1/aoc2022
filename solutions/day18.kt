import java.io.File
import java.util.LinkedList
import kotlin.math.abs

fun part_1(cubes: List<List<Int>>): Int {
    var touching_walls = 0
    for ((cube_a_ind, cube_a) in cubes.withIndex()) {
        for (cube_b in cubes.drop(cube_a_ind + 1)) {
            if (cube_a.zip(cube_b).map { (a, b) -> abs(a - b) }.sum() == 1) {
                touching_walls++
            }
        }
    }
    return cubes.size * 6 - touching_walls * 2
}

fun part_2(cubes: List<List<Int>>): Int {
    val size = 22
    val cave = Array(size) { Array(size) { IntArray(size) { _ -> 0 } } }

    for (cube in cubes) {
        cave[cube[0] + 1][cube[1] + 1][cube[2] + 1] = 1
    }
    cave[0][0][0] = 2

    val cubesToVisit = LinkedList<Array<Int>>()
    cubesToVisit.push(arrayOf(0, 0, 0))

    var ans = 0
    while (cubesToVisit.isNotEmpty()) {
        val cube = cubesToVisit.pop()
        for (coord in 0..2) {
            for (displacement in arrayOf(-1, 1)) {
                if (cube[coord] + displacement < 0 || cube[coord] + displacement >= size) {
                    continue
                }
                val new_cube = cube.clone()
                new_cube[coord] += displacement
                if (cave[new_cube[0]][new_cube[1]][new_cube[2]] == 1) {
                    ans++
                } else if (cave[new_cube[0]][new_cube[1]][new_cube[2]] == 0) {
                    cubesToVisit.push(new_cube)
                    cave[new_cube[0]][new_cube[1]][new_cube[2]] = 2
                }
            }
        }      
    }
    return ans
}

fun main() {
    val lines =
            File("../inputs/day18.txt").readText().split("\r\n").map {
                it.split(",").map { it.toInt() }
            }

    println("Part 1: ${part_1(lines)}")
    println("Part 2: ${part_2(lines)}")
}
