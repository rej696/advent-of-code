def parse_input(filename):
    with open(filename, 'r') as f:
        return [line.split() for line in f.readlines()]


def zone(pos):
    r = (-1, 0, 1)
    return ((pos[0] + i, pos[1] + j) for i in r for j in r)

def direction(pos):
    return 1 if pos > 0 else (-1 if pos < 0 else 0)

def get_tail_pos(head, tail):
    if head in zone(tail):
        return tail

    return tuple(y + direction(x - y) for (x, y) in zip(head, tail))

def print_test(head, tail):
    lines = []
    for i in range(10):
        line = []
        for j in range(10):
            line.append("S") if i == 0 and j == 0 else line.append (".")
        lines.append(line)

    lines[tail[0]][tail[1]] = "T"
    lines[head[0]][head[1]] = "H"

    for line in reversed(lines):
        for c in line:
            print(c, end=" ")
        print("")

    print("\n")

def test():
    for head in [(i, j) for i in range(3,8) for j in range(3,8)]:
        print_test(head, tuple(get_tail_pos(head, (5,5))))


move_head = {
    "R": (lambda i, j : (i, j + 1)),
    "L": (lambda i, j : (i, j - 1)),
    "U": (lambda i, j : (i + 1, j)),
    "D": (lambda i, j : (i - 1, j))
}

def part1(filename="input"):
    head = (0,0)
    tail = (0,0)
    tail_positions = {tail}
    for cmd, num in parse_input(filename):
        #print(f"{cmd}: {num}")
        for _ in range(int(num)):
            head = move_head[cmd](*head)
            tail = get_tail_pos(head, tail)
            tail_positions.add(tail)
            #print_test(head, tail)
    #print(tail_positions)
    print(len(tail_positions))


def handle_rope(head, rope):
    tail = get_tail_pos(head, rope[0])

    if len(rope) == 2:
        return tail, get_tail_pos(tail, rope[-1])
    return tail, *handle_rope(tail, rope[1:])


def part2(filename="input"):
    head = (0,0)
    rope = tuple((0,0) for _ in range(9))
    tail_positions = {rope[-1]}
    for cmd, num in parse_input(filename):
        #print(f"{cmd}: {num}")
        for _ in range(int(num)):
            head = move_head[cmd](*head)
            rope = handle_rope(head, rope)
            tail_positions.add(rope[-1])
    print(len(tail_positions))




if __name__ == "__main__":
    #part1("test")
    part1()
    part2()


