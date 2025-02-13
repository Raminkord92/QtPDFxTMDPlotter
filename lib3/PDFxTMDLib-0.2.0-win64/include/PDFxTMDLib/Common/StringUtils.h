#pragma once
// https://stackoverflow.com/questions/216823/how-to-trim-a-stdstring
#include <algorithm>
#include <cctype>
#include <locale>

namespace PDFxTMD
{
// trim from start (in place)
inline void ltrim(std::string &s)
{
    s.erase(s.begin(),
            std::find_if(s.begin(), s.end(), [](unsigned char ch) { return !std::isspace(ch); }));
}

// trim from end (in place)
inline void rtrim(std::string &s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) { return !std::isspace(ch); })
                .base(),
            s.end());
}
// trim from both ends (in place)
inline void trim(std::string &s)
{
    rtrim(s);
    ltrim(s);
}

// trim from start (copying)
inline std::string ltrim_copy(std::string s)
{
    ltrim(s);
    return s;
}

// trim from end (copying)
inline std::string rtrim_copy(std::string s)
{
    rtrim(s);
    return s;
}

// trim from both ends (copying)
inline std::string trim_copy(std::string s)
{
    trim(s);
    return s;
}
// Function to convert a string to lowercase
inline std::string ToLower(const std::string &str)
{
    std::string lowerStr = str; // Create a copy of the input string
    std::transform(lowerStr.begin(), lowerStr.end(), lowerStr.begin(), ::tolower);
    return lowerStr;
}

// Function to convert a string to uppercase
inline std::string ToUpper(const std::string &str)
{
    std::string upperStr = str; // Create a copy of the input string
    std::transform(upperStr.begin(), upperStr.end(), upperStr.begin(), ::toupper);
    return upperStr;
}
} // namespace PDFxTMD
