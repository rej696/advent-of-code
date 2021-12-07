if __name__ == "__main__":
  value = -1
  prev = 0
  with open("input.txt") as file:
    for line in file.readlines():
      if int(line) > prev:
        value += 1
      prev = int(line)
  
  print(value)
      


