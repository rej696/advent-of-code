
score = {
    'scissors': 3,
    'paper': 2,
    'rock': 1
}

elf_map = {
    'A': 'rock',
    'B': 'paper',
    'C': 'scissors'
}

my_map = {
    'X': 'rock',
    'Y': 'paper',
    'Z': 'scissors'
}


def find_score(elf_input, my_input):
    my_score = score[my_map[my_input]]
    elf_score = score[elf_map[elf_input]]

    if my_score == elf_score:
        return elf_score + 3, my_score + 3

    if my_score % 3 == (elf_score + 1) % 3:
        # my score is 1 higher than elf, therefore I win
        my_score += 6
    else:
        # elf wins
        elf_score += 6

    return elf_score, my_score


def find_score2(elf_input, result):
    elf_score = score[elf_map[elf_input]]

    if result == 'X':
        # I lose
        my_move = -1
    elif result == 'Y':
        # Draw
        my_move = 0
    else:
        # I win
        my_move = 1

    my_score = (((elf_score % 3) + my_move) % 3)

    if my_score == 0:
        my_score = 3

    if my_score == elf_score:
        assert result == 'Y'
        return elf_score + 3, my_score + 3

    if my_score % 3 == (elf_score + 1) % 3:
        # my score is 1 higher than elf, therefore I win
        my_score += 6
        assert result == 'Z'
    else:
        # elf wins
        assert result == 'X'
        elf_score += 6

    return elf_score, my_score

def test():
    you_total = 0
    elf_total = 0
    for line in ["A Y", "B X", "C Z"]:
        input = line.split()
        elf, you = find_score(input[0], input[1])
        print(f"My Score: {you}, Elf Score:{elf}")
        elf_total += elf
        you_total += you

    print(f"My Score: {you_total}, Elf Score:{elf_total}")


def main():
    with open("input", "r") as f:
        you_total = 0
        elf_total = 0
        for line in f.readlines():
            # if (any([key == line[0] for key in elf_map.keys()])
            #         and any([key == line[1] for key in my_map.keys()])):
            input = line.split()
            elf, you = find_score2(input[0], input[1])
            elf_total += elf
            you_total += you

    print(f"My Score: {you_total}, Elf Score:{elf_total}")

if __name__ == "__main__":
    test()
    main()
