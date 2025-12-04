//usr/bin/g++ --std=c++23 "$0" && exec ./a.out "$@"
#include <iostream>
#include <optional>
#include <algorithm>
#include <typeinfo>
#include <string_view>
#include <ranges>
#include <algorithm>
#include <vector>
#include <utility>
#include <cassert>

using namespace std::literals;

constexpr bool logging = true;

template <typename T> std::string_view type_name() {
    std::string_view func_name(__PRETTY_FUNCTION__);
    std::string_view tmp = func_name.substr(func_name.find_first_of("["));
    std::string_view type = tmp.substr(0, tmp.size());
    return type;
};

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

template <typename T>
T part1(std::string_view input) {
    auto iter = input
        | std::views::split(',')
        | std::views::transform([](auto subrange) { return std::string_view(subrange); })
        | std::views::transform([](auto sv) {
            // if (logging) std::cout << "range: " << sv << "\n";
            auto range = sv
                | std::views::split('-')
                | std::views::transform([](auto subrange) {return std::string_view(subrange);})
                | std::views::transform([](auto sv) {
                    // if (logging) std::cout << sv << "\n";
                    return vtonum<T>(sv);})
                | std::views::transform([](auto res) {return *res;})
                | std::ranges::to<std::vector<T>>();
            assert(range.size() == 2);
            auto output = std::views::iota(range[0], range[1] + 1)
                | std::views::transform([](auto value) { return std::to_string(value); })
                | std::views::filter([](auto str) {
                    if (str.size() % 2 != 0) return false;
                    return str.substr(0, str.size() / 2) == str.substr(str.size() / 2, str.size());
                })
                | std::views::transform([](auto sv) {
                    // if (logging) std::cout << sv << ",";
                    return vtonum<T>(std::string_view(sv));})
                | std::views::transform([](auto res) {return *res;})
                | std::ranges::to<std::vector<T>>();
            // if (logging) std::cout << "\n";
            return output;
            });

    T acc = 0;
    auto output = iter | fold(acc, [](auto acc, auto inner_iter) {
        auto res = inner_iter | fold(acc, [](auto acc, auto v) {
            acc += v;
            // std::cout << "running total: " << acc << "\n";
            return acc;
        });
        return res;
    });

    return output;
}

bool check_repeats(std::string_view part, std::string_view str) {
    if ((str.size() % part.size()) != 0) return false;
    // if (logging) std::cout << "part divisibility: " << str.size() / part.size() << "\n";
    for (auto i : std::views::iota(1, static_cast<int>(str.size() / part.size()))) {
        // if (logging) std::cout << str << " (" << i << ") " << part << " : " << str.substr(i * part.size(), part.size()) << "\n";
        if (str.substr(i * part.size(), part.size()) != part) {
            return false;
        }
    }
    // if (logging) std::cout << part << ": " << str << "\n";
    return true;
}

template <typename T>
T part2(std::string_view input) {
    auto iter = input
        | std::views::split(',')
        | std::views::transform([](auto subrange) { return std::string_view(subrange); })
        | std::views::transform([](auto sv) {
            // if (logging) std::cout << "range: " << sv << "\n";
            auto range = sv
                | std::views::split('-')
                | std::views::transform([](auto subrange) {return std::string_view(subrange);})
                | std::views::transform([](auto sv) {
                    // if (logging) std::cout << sv << "\n";
                    return vtonum<T>(sv);})
                | std::views::transform([](auto res) {return *res;})
                | std::ranges::to<std::vector<T>>();
            assert(range.size() == 2);
            auto output = std::views::iota(range[0], range[1] + 1)
                | std::views::transform([](auto value) { return std::to_string(value); })
                | std::views::filter([](auto str) {
                    // if (logging) std::cout << 0 << ": " << str << "\n";
                    for (auto  i : std::views::iota(1, static_cast<int>(str.size() / 2) + 1)) {
                        // if (logging) std::cout << i << ": " << str << "\n";
                        if (check_repeats(str.substr(0, i), str)) {
                            return true;
                        }
                    }
                    return false;
                })
                | std::views::transform([](auto sv) {
                    // if (logging) std::cout << sv << ",";
                    return vtonum<T>(std::string_view(sv));})
                | std::views::transform([](auto res) {return *res;})
                | std::ranges::to<std::vector<T>>();
            // if (logging) std::cout << "\n";
            return output;
            });

    T acc = 0;
    auto output = iter | fold(acc, [](auto acc, auto inner_iter) {
        auto res = inner_iter | fold(acc, [](auto acc, auto v) {
            acc += v;
            // std::cout << "running total: " << acc << "\n";
            return acc;
        });
        return res;
    });

    return output;
}


int main() {
    constexpr std::string_view test_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"sv;
    constexpr std::string_view input = "4487-9581,755745207-755766099,954895848-955063124,4358832-4497315,15-47,1-12,9198808-9258771,657981-762275,6256098346-6256303872,142-282,13092529-13179528,96201296-96341879,19767340-19916378,2809036-2830862,335850-499986,172437-315144,764434-793133,910543-1082670,2142179-2279203,6649545-6713098,6464587849-6464677024,858399-904491,1328-4021,72798-159206,89777719-90005812,91891792-91938279,314-963,48-130,527903-594370,24240-60212"sv;

    std::cout << "part1 test: " << part1<uint64_t>(test_input) << "\n";
    std::cout << "part1: " << part1<uint64_t>(input) << "\n";

    std::cout << "part2 test: " << part2<uint64_t>(test_input) << "\n";
    std::cout << "part2: " << part2<uint64_t>(input) << "\n";

}
