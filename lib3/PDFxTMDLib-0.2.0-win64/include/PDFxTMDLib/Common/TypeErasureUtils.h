#pragma once
namespace PDFxTMD
{
class _Undefined_class;

union _Nocopy_types {
    void *_M_object;
    const void *_M_const_object;
    void (*_M_function_pointer)();
    void (_Undefined_class::*_M_member_pointer)();
};

// Helper constants for storage
constexpr size_t MAX_SIZE = sizeof(_Nocopy_types);
constexpr size_t MAX_ALIGN = alignof(_Nocopy_types);

// Dynamic storage
struct DynamicStorage
{
    template <typename T, typename... Args> T *create(Args &&...args)
    {
        return new T(std::forward<Args>(args)...);
    }

    template <typename T> void destroy(T *ptr) noexcept
    {
        delete ptr;
    }
};

// In-class storage
template <size_t Capacity, size_t Alignment> struct InClassStorage
{
    template <typename T, typename... Args> T *create(Args &&...args)
    {
        void *memory = static_cast<void *>(buffer_.data());
        return ::new (memory) T(std::forward<Args>(args)...);
    }

    template <typename T> void destroy(T *ptr) noexcept
    {
        ptr->~T();
    }

  private:
    alignas(Alignment) std::array<std::byte, Capacity> buffer_;
};

// Helper class to encapsulate storage logic
class StorageHelper
{
  public:
    template <typename T, typename... Args>
    static T *create(std::array<std::byte, MAX_SIZE> &storageBuffer, Args &&...args)
    {
        if (isStoredLocally<T>())
        {
            void *memory = static_cast<void *>(storageBuffer.data());
            return ::new (memory) T(std::forward<Args>(args)...);
        }
        else
        {
            return new T(std::forward<Args>(args)...);
        }
    }

    template <typename T>
    static void destroy(std::array<std::byte, MAX_SIZE> &storageBuffer, T *ptr) noexcept
    {
        if (isStoredLocally<T>())
        {
            ptr->~T();
        }
        else
        {
            delete ptr;
        }
    }

  private:
    template <typename T> static constexpr bool isStoredLocally()
    {
        return sizeof(T) <= MAX_SIZE && alignof(T) <= MAX_ALIGN && (MAX_ALIGN % alignof(T) == 0);
    }
};

} // namespace PDFxTMD
