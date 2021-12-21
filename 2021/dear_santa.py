#! /usr/env/bin python3
# My Christmas wishlist

class Rowan:
    def __init__(self):
        self.is_good = True
        self.presents = [
            "A Million Pounds",
            "Programming Textbooks",
            "Expensive Synthesizers"
        ]

    def print_presents(self):
        for present in self.presents:
            print(present)

    def get_presents(self):
        if self.is_good:
            self.print_presents()
        else:
            print("Coal")


if __name__ == "__main__":
    rowan = Rowan()
    rowan.get_presents()
