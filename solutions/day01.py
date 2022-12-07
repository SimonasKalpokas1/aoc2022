
def part1(lines):
    ans = 0

    summation = 0
    for line in lines:
        if line[0] == '\n':
            ans = max(ans, summation)
            summation = 0
        else:
            summation += int(line)
    return ans

def part2(lines):
    cals = []

    summation = 0    
    for line in lines:
        if line[0] == '\n':
            cals.append(summation)
            summation = 0
        else:
            summation += int(line)
    return sum(sorted(cals)[-3:])

with open('../inputs/day01.txt', 'r') as f:
    lines = f.readlines()
    print("Part 1:", part1(lines))
    print("Part 2:", part2(lines))
    



