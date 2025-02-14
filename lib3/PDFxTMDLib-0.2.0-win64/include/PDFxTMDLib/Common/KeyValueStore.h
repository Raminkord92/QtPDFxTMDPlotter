#pragma once
#include <map>
#include <optional>
#include <string>
#include <variant>

namespace PDFxTMD
{
enum class Types
{
    Int,
    Float,
    String
};
using StandardType = std::variant<int, float, std::string>;
using StandardTypeMap = std::map<std::string, StandardType>;
class KeyValueStore
{
  public:
    void set(const std::string &key, const StandardType &value)
    {
        m_data[key] = value;
    }
    std::optional<StandardType> get(const std::string &key) const
    {
        if (!contains(key))
            return std::nullopt;
        return m_data.at(key);
    }
    bool contains(const std::string &key) const
    {
        auto foundKeyItr = m_data.find(key);
        if (foundKeyItr == m_data.end())
            return false;
        return true;
    }

  private:
    StandardTypeMap m_data;
};
} // namespace PDFxTMD
