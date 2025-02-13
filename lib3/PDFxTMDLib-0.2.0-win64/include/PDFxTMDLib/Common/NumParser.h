#pragma once
#include <charconv>
#include <cstring>
#include <string_view>

namespace PDFxTMD
{

class NumParser
{
  public:
    // Constructor takes string_view to avoid copies
    explicit NumParser(std::string_view input) noexcept
        : _current(input.data()), _end(input.data() + input.size())
    {
    }

    // Reset with new input
    void reset(std::string_view input) noexcept
    {
        _current = input.data();
        _end = input.data() + input.size();
    }

    // Fast stream-like operator
    template <typename T> NumParser &operator>>(T &value) noexcept
    {
        skipSpaces();
        value = parseNumber<T>();
        return *this;
    }

    // Check if more data available
    [[nodiscard]] bool hasMore() const noexcept
    {
        return _current < _end;
    }

  private:
    const char *_current; // Current position
    const char *_end;     // End of input

    // Skip spaces using fast pointer arithmetic
    void skipSpaces() noexcept
    {
        while (_current < _end && *_current == ' ')
        {
            ++_current;
        }
    }

    // Fast number parsing using from_chars
    template <typename T> T parseNumber() noexcept
    {
        T value;
        auto [ptr, ec] = std::from_chars(_current, _end, value);
        _current = ptr;
        return value;
    }
};

} // namespace PDFxTMD
