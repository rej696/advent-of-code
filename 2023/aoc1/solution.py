

def part1():
    with open("input", "r") as f:
        return sum(int(f"{line[0]}{line.strip()[-1]}") for line in f.readlines())


if __name__ == "__main__":
    part1()
