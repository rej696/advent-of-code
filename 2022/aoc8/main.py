def read_input():
    tree_map = {}
    shape = (0, 0)
    with open("input", "r") as f:
        lines = f.readlines()
        shape = (len(lines), len(lines[0].strip()))
        for i, line in enumerate(lines):
            for j, tree in enumerate(line.strip()):
                tree_map[(i, j)] = int(tree)

    return tree_map, shape


def find_visible_trees(trees, shape):
    visible_trees = set()

    # populate perimeter trees
    for j in range(shape[1]):
        visible_trees.add((0, j))
        visible_trees.add((shape[0] - 1, j))
    for i in range(shape[0]):
        visible_trees.add((i, 0))
        visible_trees.add((i, shape[1] - 1))

    # Visible from top
    for i in range(1, shape[0]):
        largest_tree = trees[(i, 0)]
        for j in range(1, shape[1]):
            if trees[(i, j)] > largest_tree:
                visible_trees.add((i, j))
                largest_tree = trees[(i, j)]

    # Visible from bottom
    for i in range(shape[0] - 2, 0, -1):
        largest_tree = trees[(i, shape[1] - 1)]
        for j in range(shape[1] - 2, 0, -1):
            if trees[(i, j)] > largest_tree:
                visible_trees.add((i, j))
                largest_tree = trees[(i, j)]

    # Visible from left
    for j in range(1, shape[1]):
        largest_tree = trees[(0, j)]
        for i in range(1, shape[0]):
            if trees[(i, j)] > largest_tree:
                visible_trees.add((i, j))
                largest_tree = trees[(i, j)]

    # Visible from right
    for j in range(shape[0] - 2, 0, -1):
        largest_tree = trees[(shape[1] - 1, j)]
        for i in range(shape[1] - 2, 0, -1):
            if trees[(i, j)] > largest_tree:
                visible_trees.add((i, j))
                largest_tree = trees[(i, j)]

    return visible_trees


def find_most_scenic_tree(trees, shape):
    scenic_scores = {}

    for tree in trees.keys():
        down = 0
        for i in range(tree[0] + 1, shape[0]):
            if trees[(i, tree[1])] < trees[tree]:
                down += 1
            else:
                down += 1
                break

        up = 0
        for i in range(tree[0] - 1, -1, -1):
            if trees[(i, tree[1])] < trees[tree]:
                up += 1
            else:
                up += 1
                break

        left = 0
        for j in range(tree[1] + 1, shape[1]):
            if trees[(tree[0], j)] < trees[tree]:
                left += 1
            else:
                left += 1
                break

        right = 0
        for j in range(tree[1] - 1, -1, -1):
            if trees[(tree[0], j)] < trees[tree]:
                right += 1
            else:
                right += 1
                break

        scenic_scores[tree] = up * down * left * right

    return scenic_scores


def main():
    print(f"part1: {len(find_visible_trees(*read_input()))}")
    print(f"part2: {max(find_most_scenic_tree(*read_input()).values())}")


if __name__ == "__main__":
    main()
