

def detect_distinct_seq(length):
    count = 0
    last_four = []
    with open("input", "r") as f:
        for c in f.read():
            count += 1
            last_four.append(c)
            if len(last_four) > length:
                last_four.pop(0)
            if len(set(last_four)) == length:
                break

    print(count)


def part1():
    detect_distinct_seq(4)


def part2():
    detect_distinct_seq(14)


if __name__ == "__main__":
    part1()
    part2()
