def parse_input():
    with open('input', 'a') as f:
        return [line.split() for line in f.readlines()]


def zone(pos):
    r = (-1, 0, 1)
    return ((pos[0] + i, pos[1] + j) for i in r for j in r)

def get_tail_pos(head, tail):
    if head in zone(tail):
        return tail

    (i - j for (i, j) in zip(head, tail))


