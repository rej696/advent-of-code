def parse_input(filename="input"):
    with open(filename, "r") as f:
        return {(i,j): ord(c) for j,c in enumerate(line) for i, line in
                enumerate(f.readlines())}


def strength(cycle, xs):
    return cycle * xs[cycle - 1]


def get_start_coord(hillmap):
    for k in hillmap.keys():
            if hillmap[k] == ord("S"):
                return i, j
    return None

def get_routes(coord):
    i = coord[0]
    j = coord[1]
    return [(i + 1, j), (i - 1, j),
            (i, j + 1), (i, j - 1)]



def search_path(hillmap, path):
    # sort by size of value (higher value is better
    for option in sort(get_routes(path[-1])):
        if option not in hillmap.keys():
            continue
        if hillmap[option] not in range(hillmap[coord[-1]] - 1, hillmap[coord[-1]] + 2):
            continue
        if option in path:
            continue
        result = search_path(hillmap, path)
        if result is not None:
            return result
    return None



def part1(filename="input"):
    hillmap = parse_input(filename)
    shape = tuple(map(inc, max(hillmap.keys())))
    path = (get_start_coord(hillmap))
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
