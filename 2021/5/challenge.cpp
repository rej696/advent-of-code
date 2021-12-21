#include <iostream>
#include <fstream>
#include <string>
#include <array>
#include <vector>
#include <tuple>
#include <regex>

namespace challenge
{
  typedef struct coord
  {
    int x;
    int y;
  } coord_t;

  typedef std::array<int, 999> row_t;

  typedef std::array<row_t, 999> grid_t;
  grid_t grid;

  void initialise()
  {
    for (grid_t::iterator it = grid.begin(); it != grid.end(); ++it)
    {
      for (row_t::iterator jt = (*it).begin(); jt != (*it).end(); ++jt)
      {
        (*jt) = 0;
      }
    }
  }

  bool isPositive(const int coord1, const int coord2)
  {
    if (coord1 <= coord2)
    {
      return true;
    }
    return false;
  }

  std::vector<coord_t> getCoords(int x1, int y1, int x2, int y2)
  {
    std::vector<coord_t> retval = std::vector<coord_t>();
    int len;
    bool xdir = isPositive(x1, x2);
    bool ydir = isPositive(y1, y2);

    if (x1 == x2)
    {
      // Horizontal line
      len = ydir ? (y2 - y1) : (y1 - y2);
      for (int i = 0; i <= len; ++i)
      {
        retval.push_back({x1, (ydir ? (y1 + i) : (y1 - i))});
      }
    }
    else if (y1 == y2)
    {
      // Vertical Line
      len = xdir ? (x2 - x1) : (x1 - x2);
      for (int i = 0; i <= len; ++i)
      {
        retval.push_back({(xdir ? (x1 + i) : (x1 - i)), y1});
      }
    }
    else
    {
      // Diagonal line (Part 2)
      len = ydir ? (y2 - y1) : (y1 - y2);
      for (int i = 0; i <= len; ++i)
      {
        retval.push_back({
          (xdir ? (x1 + i) : (x1 - i)),
          (ydir ? (y1 + i) : (y1 - i))});
      }
    }

    return retval;
  }

  void processCoords(const std::vector<coord_t> coords)
  {
    for (std::vector<coord_t>::const_iterator it = coords.cbegin(); it != coords.cend(); ++it)
    {
      ++grid[it->y][it->x];
    }
  }

  void processLine(const std::string line)
  {
    int x1, y1, x2, y2;
    std::vector<coord_t> coords;
    std::regex rgx("([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)");
    std::smatch match;

    if (std::regex_match(line.cbegin(), line.cend(), match, rgx))
    {
      x1 = stoi(match[1]);
      y1 = stoi(match[2]);
      x2 = stoi(match[3]);
      y2 = stoi(match[4]);
    }

    processCoords(getCoords(x1, y1, x2, y2));
  }

  void readFile()
  {
    std::ifstream inputFile("./input.txt");
    std::string line;

    if (inputFile.is_open())
    {
      while (std::getline(inputFile, line))
      {
        processLine(line);
      }

      inputFile.close();
    }
    else
    {
      std::cout << "Unable to open file" << std::endl;
    }
  }

  int calculateDanger(int dangerValue)
  {
    int totalDanger = 0;

    for (grid_t::const_iterator it = grid.cbegin(); it != grid.cend(); ++it)
    {
      for (row_t::const_iterator jt = (*it).cbegin(); jt != (*it).cend(); ++jt)
      {
        if ((*jt) >= dangerValue)
        {
          ++totalDanger;
        }
      }
    }

    return totalDanger;
  }
}

// Main function
int main(int argc, char *argv[])
{
  challenge::initialise();
  challenge::readFile();
  std::cout << "Total Danger: " << challenge::calculateDanger(2) << std::endl;
}