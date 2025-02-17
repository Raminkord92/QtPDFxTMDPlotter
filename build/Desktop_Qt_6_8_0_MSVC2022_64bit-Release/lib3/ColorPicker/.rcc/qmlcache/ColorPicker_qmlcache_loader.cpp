#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _colorpicker_qml_ColorPicker_ColorPickerDialog_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _colorpicker_qml_ColorPicker_ColorSampler_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _colorpicker_qml_ColorPicker_ColorHistory_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _colorpicker_qml_ColorPicker_ColorSlider_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _colorpicker_qml_ColorPicker_RGBSlider_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _colorpicker_qml_ColorPicker_HSVSlider_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/ColorPickerDialog.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_ColorPickerDialog_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/ColorSampler.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_ColorSampler_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/ColorHistory.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_ColorHistory_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/ColorSlider.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_ColorSlider_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/RGBSlider.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_RGBSlider_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/colorpicker/qml/ColorPicker/HSVSlider.qml"), &QmlCacheGeneratedCode::_colorpicker_qml_ColorPicker_HSVSlider_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_ColorPicker)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_ColorPicker))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_ColorPicker)() {
    return 1;
}
