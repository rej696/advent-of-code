from typing import List


if __name__ == "__main__":
  value = -1
  prev = 0
  queue = []
  with open("input.txt") as file:
    for line in file.readlines():
      queue.append(int(line))

      if len(queue) >= 3:
        cur = sum(queue)
        if cur > prev:
          value += 1
        prev = cur
        queue.pop(0)
  
  print(value)