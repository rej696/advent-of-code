def parse_input(filename="input"):
    with open(filename, "r") as f:
        return [line.split() for line in f.readlines()]


def strength(cycle, xs):
    return cycle * xs[cycle - 1]


def get_xs(filename="input"):
    xs = [1]
    for op in parse_input(filename):
        if op[0] == "noop":
            xs.append(xs[-1])
        else:
            xs.append(xs[-1])
            xs.append(xs[-1] + int(op[1]))

    return xs


def part1(filename="input"):
    xs = get_xs(filename)
    return sum(strength(i, xs) for i in range(20, 221, 40))


def is_lit(i, x):
    return i % 40 in range(x - 1, x + 2)


def part2(filename="input"):
    xs = get_xs(filename)

    for i, x in enumerate(xs):
        if is_lit(i, x):
            print("#", end="")
        else:
            print(".", end="")

        if ((i + 1) % 40) == 0:
            print("")


if __name__ == "__main__":
    print(part1())
    part2()
