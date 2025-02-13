#pragma once

#include <fstream>
#include <map>
#include <optional>
#include <string>
#include <variant>
#include <vector>

#include "PartonUtils.h"
#include <PDFxTMDLib/fkYAML/node.hpp>

namespace PDFxTMD
{
class ConfigWrapper
{
  public:
    enum class Format
    {
        YAML
    };

    ConfigWrapper() = default;

    bool loadFromFile(const std::string &filename, Format format)
    {
        if (format == Format::YAML)
        {
            std::ifstream ifs(filename);
            if (!ifs.is_open())
            {
                return false;
            }
            try
            {
                data.yaml = fkyaml::node::deserialize(ifs);
                data.format = format;
                return true;
            }
            catch (const std::exception &)
            {
                return false;
            }
        }
        return false;
    }

    bool loadFromString(const std::string &data_string, Format format)
    {
        if (format == Format::YAML)
        {
            try
            {
                std::istringstream iss(data_string);
                data.yaml = fkyaml::node::deserialize(iss);
                data.format = format;
                return true;
            }
            catch (const std::exception &)
            {
                return false;
            }
        }
        return false;
    }

    template <typename T> std::pair<std::optional<T>, ErrorType> get(const std::string &key) const
    {
        if (data.format == Format::YAML)
        {
            try
            {
                if (data.yaml.contains(key))
                {
                    T value = data.yaml[key].get_value<T>();
                    return {value, ErrorType::None};
                }
                return {std::nullopt, ErrorType::CONFIG_KeyNotFound};
            }
            catch (const std::exception &)
            {
                return {std::nullopt, ErrorType::CONFIG_ConversionFailed};
            }
        }
        return {std::nullopt, ErrorType::CONFIG_KeyNotFound};
    }

  private:
    struct Data
    {
        Format format;
        fkyaml::node yaml;
    } data;
};
} // namespace PDFxTMD
