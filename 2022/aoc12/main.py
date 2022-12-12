def parse_input(filename="input"):
    with open(filename, "r") as f:
        return {(i, j): ord(c)
                for i, line in enumerate(f.readlines())
                for j, c in enumerate(line)}


def get_start_coord(hillmap):
    for k in hillmap.keys():
        if hillmap[k] == ord("S"):
            return k
    return None


def get_routes(coord, shape):
    i = coord[0]
    j = coord[1]
    return list(filter(
        (lambda c: all([c[i] >= 0 and c[i] < shape[i] for i in range(2)])),
         [(i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)]))


def search_path(hillmap, path, shape):
    # sort by size of value (higher value is better)
    print(path)
    coord = path[-1]
    options = list(filter((lambda k: k not in path), get_routes(coord, shape)))
    options.sort(key=(lambda x: hillmap[x]), reverse=True)
    for option in options:
        if hillmap[coord] == ord("z") and hillmap[option] == ord("E"):
            return (*path, option)
        if option not in hillmap.keys():
            continue
        if (hillmap[option] not in range(hillmap[coord] - 1, hillmap[coord] + 2)
                and not (hillmap[option] == ord("a")
                    and hillmap[coord] == ord("S"))):
            continue
        if option in path:
            continue
        result = search_path(hillmap, (*path, option), shape)
        if result is not None:
            return result
    return None


def part1(filename="input"):
    hillmap = parse_input(filename)
    shape = tuple(map((lambda x: x + 1), max(hillmap.keys())))
    path = search_path(hillmap, (get_start_coord(hillmap),), shape)
    return len(path) - 1


if __name__ == "__main__":
    # TODO implement dystras shortest path
    print(part1("test"))
    print(part1("input"))
