/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<colorPickerBackend.h>)
#  include <colorPickerBackend.h>
#endif
#if __has_include(<colorhistorymodel.h>)
#  include <colorhistorymodel.h>
#endif
#if __has_include(<colorwheel.h>)
#  include <colorwheel.h>
#endif
#if __has_include(<eyedropPreview.h>)
#  include <eyedropPreview.h>
#endif
#if __has_include(<textfielddoublevalidator.h>)
#  include <textfielddoublevalidator.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_ColorPicker()
{
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<ColorHistoryModel>("ColorPicker", 1);
    qmlRegisterAnonymousType<QAbstractItemModel, 254>("ColorPicker", 1);
    qmlRegisterTypesAndRevisions<ColorPickerBackend>("ColorPicker", 1);
    qmlRegisterTypesAndRevisions<ColorWheel>("ColorPicker", 1);
    qmlRegisterAnonymousType<QQuickItem, 254>("ColorPicker", 1);
    qmlRegisterTypesAndRevisions<EyedropPreview>("ColorPicker", 1);
    QMetaType::fromType<QDoubleValidator *>().id();
    QMetaType::fromType<QDoubleValidator::Notation>().id();
    qmlRegisterTypesAndRevisions<TextFieldDoubleValidator>("ColorPicker", 1);
    QT_WARNING_POP
    qmlRegisterModule("ColorPicker", 1, 0);
}

static const QQmlModuleRegistration colorPickerRegistration("ColorPicker", qml_register_types_ColorPicker);
