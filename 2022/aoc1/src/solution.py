
elves = []
with open("input", "r") as f:
    elf = 0
    for line in f.readlines():
        if line == '\n':
            elves.append(elf)
            elf = 0
        else:
            elf += int(line)
elves.sort()
print(elves[-1])

print(elves[-1] + elves[-2] + elves[-3])


