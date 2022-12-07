package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type dir struct {
	name   string
	size   uint64
	father *dir
	items  []*dir
}

func recursion_1(ptr *dir) uint64 {
	var sum uint64 = 0
	if ptr.size <= 100000 {
		sum += ptr.size
	}
	for _, item := range ptr.items {
		sum += recursion_1(item)
	}
	return sum
}

func recursion_2(ptr *dir, sum uint64) uint64 {
	var smallest uint64 = 70000000
	if sum-ptr.size <= 40000000 {
		smallest = ptr.size
	}
	for _, item := range ptr.items {
		tmp := recursion_2(item, sum)
		if tmp < smallest {
			smallest = tmp
		}
	}
	return smallest
}

func parse(lines *[]string) *dir {
	root := &dir{
		name:   "/",
		size:   0,
		father: nil,
	}

	ptr := root
	for _, line := range *lines {
		if strings.HasPrefix(line, "$ cd") {
			if line[5:] == ".." {
				ptr.father.size += ptr.size
				ptr = ptr.father
			} else if line[5:] != "/" {
				tmp := &dir{
					name:   line[5:],
					size:   0,
					father: ptr,
				}
				ptr.items = append(ptr.items, tmp)
				ptr = tmp
			}
		} else if !strings.HasPrefix(line, "$ ls") && !strings.HasPrefix(line, "dir ") {
			d := strings.Split(line, " ")
			size, _ := strconv.ParseUint(d[0], 10, 64)
			ptr.size += size
		}
	}

	for ptr.father != nil {
		ptr.father.size += ptr.size
		ptr = ptr.father
	}
	return root
}

func main() {
	dat, _ := os.ReadFile("../inputs/day07.txt")
	lines := strings.Split(string(dat), "\r\n")

	root := parse(&lines)

	fmt.Println("Part 1:", recursion_1(root))
	fmt.Println("Part 2:", recursion_2(root, root.size))
}
