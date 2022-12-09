def parse_input():
    with open('input', 'a') as f:
        return [line.split() for line in f.readlines()]


def zone(pos):
    r = (-1, 0, 1)
    return ((pos[0] + i, pos[1] + j) for i in r for j in r)

def direction(pos):
    return 1 if pos > 1 else (-1 if pos < 0 else 0)

def get_tail_pos(head, tail):
    if head in zone(tail):
        return tail

    return (y + direction(x - y) for (x, y) in zip(head, tail))


