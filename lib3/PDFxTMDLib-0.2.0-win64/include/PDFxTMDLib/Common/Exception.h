#pragma once
#include <exception>
#include <string>

namespace PDFxTMD
{
class PDFxTMDException : public std::exception
{
  public:
    explicit PDFxTMDException(const std::string &message) : m_message(message)
    {
    }
    virtual const char *what() const noexcept override
    {
        return m_message.c_str();
    }

  private:
    std::string m_message;
};

class FileLoadException : public PDFxTMDException
{
  public:
    explicit FileLoadException(const std::string &fileName)
        : PDFxTMDException("Failed to load file: " + fileName)
    {
    }
};

class OutOfRangeExcecption : public PDFxTMDException
{
  public:
    explicit OutOfRangeExcecption(const std::string &message)
        : PDFxTMDException("Out of range exception: " + message)
    {
    }
};
class PolicyExeption : public PDFxTMDException
{
  public:
    explicit PolicyExeption(const std::string &message)
        : PDFxTMDException("Policy Exception: " + message)
    {
    }
};
class InvalidFormatException : public PDFxTMDException
{
  public:
    explicit InvalidFormatException(const std::string &message)
        : PDFxTMDException("Invalid Format Exception: " + message)
    {
    }
};
class InvalidInfoFile : public PDFxTMDException
{
  public:
    explicit InvalidInfoFile(const std::string &message)
        : PDFxTMDException("Invalid Info File: " + message)
    {
    }
};
class InitializationError : public PDFxTMDException
{
  public:
    explicit InitializationError(const std::string &message)
        : PDFxTMDException("InitializationError: " + message)
    {
    }
};
class InvalidInputError : public PDFxTMDException
{
  public:
    explicit InvalidInputError(const std::string &message)
        : PDFxTMDException("Invalid input error: " + message)
    {
    }
};
class NotSupportError : public PDFxTMDException
{
  public:
    explicit NotSupportError(const std::string &message)
        : PDFxTMDException("Not supported error: " + message)
    {
    }
};
} // namespace PDFxTMD
