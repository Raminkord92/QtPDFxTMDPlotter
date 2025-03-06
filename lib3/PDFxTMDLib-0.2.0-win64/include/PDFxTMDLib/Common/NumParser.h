#pragma once
#include <charconv>
#include <cstring>
#include <string_view>

namespace PDFxTMD
{

class NumParser
{
  public:
    explicit NumParser(std::string_view input) noexcept
        : _current(input.data()), _end(input.data() + input.size())
    {
    }

    void reset(std::string_view input) noexcept
    {
        _current = input.data();
        _end = input.data() + input.size();
    }

    template <typename T> NumParser &operator>>(T &value) noexcept
    {
        skipSpaces();
        value = parseNumber<T>();
        return *this;
    }

    [[nodiscard]] bool hasMore() const noexcept
    {
        return _current < _end;
    }

  private:
    const char *_current;
    const char *_end;

    void skipSpaces() noexcept
    {
        while (_current < _end && *_current == ' ')
        {
            ++_current;
        }
    }

    template <typename T> T parseNumber() noexcept
    {
        T value;
        auto [ptr, ec] = std::from_chars(_current, _end, value);
        if (ec == std::errc::invalid_argument || ec == std::errc::result_out_of_range)
        {
            value = T{};
        }
        _current = ptr;
        return value;
    }
};

} // namespace PDFxTMD
