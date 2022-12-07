class Node:
    def __init__(self, parent, children=None, size=0):
        self.parent: Node = parent
        self.size: int = size
        self.children = children

    def is_dir(self):
        return type(self.children) == dict

    def goto_root(self):
        if self.parent is None:
            return self
        return self.parent.goto_root()

    def get_child(self, key):
        return self.children[key]

    def add_child(self, data):
        if data[0] == "dir":
            self.children[data[1]] = Node(self, children={})
        else:
            self.children[data[1]] = Node(self, size=int(data[0]))

    def populate_dir_size(self):
        for child in self.children.values():
            if child.is_dir():
                child.populate_dir_size()

            self.size += child.size

    def print(self, prefix, name=""):
        print(prefix + name + ": " + str(self.size))
        if self.children is None:
            return

        for name, child in self.children.items():
            child.print(prefix + "-", name)

    def part1(self):
        acc = 0
        if self.is_dir():
            if self.size <= 100000:
                acc += self.size

            for child in self.children.values():
                if self.is_dir():
                    acc += child.part1()

        return acc

    def part2(self, minimum_space, smallest):
        # dir is big enough to delete
        if self.is_dir() and self.size >= minimum_space:
            smallest = get_smaller(self.size, smallest)
            for child in self.children.values():
                smallest = get_smaller(
                    smallest,
                    child.part2(minimum_space, smallest))

        return smallest


def get_smaller(size1, size2):
    if size1 < size2:
        return size1
    return size2


def read_input():
    return open("input", "r").readlines()


def parse_cmd(cmd, node):
    if cmd[0] == "cd":
        args = cmd[1]
        if args == "..":
            node = node.parent
        elif args == "/":
            node = node.goto_root()
        else:
            node = node.get_child(args)

        return node, False

    assert cmd[0] == "ls"
    return node, True


def parse_input(lines, current_node):
    listing = False
    for line in lines:
        item = line.split()
        if item[0] == "$":
            item.pop(0)
            current_node, listing = parse_cmd(item, current_node)
        else:
            assert listing
            current_node.add_child(item)


def main():
    root = Node(None, children={})

    parse_input(read_input(), root)
    root.populate_dir_size()
    minimum_space = (30_000_000 + root.size) - 70_000_000
    print(root.part1())
    print(root.part2(minimum_space, root.size))


if __name__ == "__main__":
    main()
