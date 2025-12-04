
#include <charconv>
#include <iomanip>
#include <iostream>
#include <optional>
#include <ranges>
#include <string_view>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace std::literals;

constexpr std::string_view input {
#include "input.txt"
};
// constexpr std::string_view newline {"\n"};

/* parse a string view into an integer value
 */
template <typename T> std::optional<T> vtonum(std::string_view const view)
{
    if (view.empty()) {
        return false;
    }

    char const *first = view.data();
    char const *last = view.data() + view.length();

    T value {};

    std::from_chars_result res = std::from_chars(first, last, value);

    if ((res.ec != std::errc()) || (res.ptr != last)) {
        return {};
    }

    return value;
}

template <typename T, typename F>
struct FoldAdaptor {
    T init;
    F func;

    template <std::ranges::input_range R>
    T operator()(R &&range) const {
        T s = init;
        for (auto &&e: range) {
            s = func(std::move(s), e);
        }
        return s;
    }

    template <std::ranges::input_range R>
    friend T operator|(R &&range, const FoldAdaptor &f) {
        return f(std::forward<R>(range));
    }

};

template <typename T, typename F>
auto fold(T init, F func) {
    return FoldAdaptor<T, F> {init, func};
}

enum class Direction {
    left,
    right,
    nil
};

Direction make_direction(std::string_view sv)
{
    if (sv.empty()) {
        return Direction::nil;
    }
    if (sv.front() == 'R') {
        return Direction::right;
    } else if (sv.front() == 'L') {
        return Direction::left;
    }
    return Direction::nil;
}

template <typename T, T N = 100>
class Angle {
public:
    Angle(std::string_view sv)
    {
        if (auto res = vtonum<T>(sv)) {
            m_value = *res;
        } else {
            std::cout << "Invalid value: " << sv << "\n";
        }
    }

    Angle(T value)
    {
        m_value = modsum(value);
    }

    void operator+=(T other) {
        m_value = modsum(other);
    }

    void operator+=(Angle<T> const& other) {
        m_value = modsum(other.m_value);
    }

    void operator-=(Angle<T> const& other) {
        m_value = modsum(-other.m_value);
    }

    bool operator==(Angle<T> const& other) const {
        return m_value == other.m_value;
    }

    bool operator==(T const& other) const {
        return m_value == other;
    }

    T value(void) {
        return m_value;
    }

private:
    T modsum(T value)
    {
        auto new_value = (m_value + value) % N;
        if (new_value < 0) new_value += N;
        return new_value;
    }

    T m_value {0};
};

struct Entry {
    Entry(std::string_view sv)
        : sv {sv}
        , direction {make_direction(sv.substr(0, 1))}
        , angle {sv.substr(1)}
    {}

    std::string_view sv;
    Direction direction;
    Angle<int> angle;
};

template<typename T = int, T N = 50>
struct State {
    Angle<T> angle {N};
    int count {0};
};

bool logging = false;

void part1(std::string_view data) {

    auto output = data
        | std::views::split("\n"sv)
        | std::views::transform([](auto sv) { return std::string_view(sv); })
        | std::views::filter([](auto sv) { return !sv.empty(); })
        | std::views::transform([](auto sv) {
              return Entry {sv};
          })
        | fold(State {}, [](auto state, auto entry) {
            if (logging) std::cout << "state angle: " << state.angle.value() << ", entry: " << entry.sv;
            if (entry.direction == Direction::right) {
                state.angle += entry.angle;
            } else if (entry.direction == Direction::left) {
                state.angle -= entry.angle;
            } else {
                std::cout << "invalid direction, something went wrong!\n";
            }
            if (logging) std::cout << " -> result angle: " << state.angle.value() << "\n";
            if (state.angle == 0) {
                if (logging) std::cout << "at 0 for the entry: " << entry.sv << "\n";
                state.count++;
            }

            return state;

        });

        std::cout << "part1 count: " << output.count << "\n";

}

void part2(std::string_view data) {

    auto output = data
        | std::views::split("\n"sv)
        | std::views::transform([](auto sv) { return std::string_view(sv); })
        | std::views::filter([](auto sv) { return !sv.empty(); })
        | std::views::transform([](auto sv) {
              return Entry {sv};
          })
        | fold(State {}, [](auto state, auto entry) {
            if (logging) std::cout << "state angle: " << state.angle.value() << ", entry: " << entry.sv << "\n";
            if (entry.direction == Direction::nil) std::cout << "invalid direction, something went wrong!\n";

            int inc = (entry.direction == Direction::right) ? 1 : -1;
            for (auto i: std::views::iota(0, entry.angle.value())) {
                state.angle += inc;
                if (state.angle == 0) {
                    if (logging) std::cout << "pass 0 for the entry: " << entry.sv << "\n";
                    state.count++;
                }
            }

            return state;
        });

        std::cout << "part2 count: " << output.count << "\n";
}

int main(void)
{
    auto test_input {R"(L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
)"sv};
    part1(test_input);
    part2(test_input);

    part1(input);
    part2(input);
}
