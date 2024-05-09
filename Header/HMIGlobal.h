#ifndef HMIGLOBAL_H
#define HMIGLOBAL_H

#include <QObject>

#define APP_DIR                                         QGuiApplication::applicationDirPath()
#define APP_MAIN_QML                                    "/Qml/main.qml"
#define APP_RESOURCE_PREFIX                             "file:///" + APP_DIR
#define APP_RESOURCE_IMAGE_DIR                          "qrc://images/res/image/"

#define APP_NAME                                        "CascadeHMI"


extern void initLogger();
#define INIT_DEBUG  initLogger();

# define Q_SLOTS QT_ANNOTATE_ACCESS_SPECIFIER(qt_slot)
# define Q_SIGNALS public QT_ANNOTATE_ACCESS_SPECIFIER(qt_signal)

//Property Macro
#define OCUBE_READONLY_PROPERTY(Type, Name, Value) \
  public:                                          \
  Q_PROPERTY(Type Name READ Name CONSTANT)         \
    Type Name() const { return (Value); }

#define OCUBE_PROPERTY_WITHOUT_RETURNARG_ON_SIGNAL(Type, Name, Function)   \
  public:                                                                  \
  Q_PROPERTY(Type Name READ Name WRITE set##Function NOTIFY Name##Changed) \
    Type Name() const {                                                    \
      return Name##_;                                                      \
    }                                                                      \
    void set##Function(const Type Name) {                                  \
      if(Name##_ != Name){                                                 \
        Name##_ = Name;                                                    \
        emit Name##Changed();                                     \
      }                                                                    \
    }                                                                      \
  private :                                                                \
    Type Name##_;

#define OCUBE_PROPERTY_WITHOUT_RETURNARG(Type, Name, Function)   \
  public:                                                                  \
  Q_PROPERTY(Type Name READ Name WRITE set##Function NOTIFY Name##Changed) \
    Type Name() const {                                                    \
      return Name##_;                                                      \
    }                                                                      \
    void set##Function(const Type Name) {                                  \
      if(Name##_ != Name){                                                 \
        Name##_ = Name;                                                    \
      }                                                                    \
    }                                                                      \
  private :                                                                \
    Type Name##_;

#define OCUBE_STRING_PROPERTY(Id, Value)                \
  public:                                               \
  Q_PROPERTY(QString Id READ Id NOTIFY languageChanged) \
    QString Id() const { return Value; }

#define OCUBE_READONLY_STRING_PROPERTY(Id, Value, Signal) \
  public:                                                 \
  Q_PROPERTY(QString Id READ Id NOTIFY Signal)            \
    QString Id() const { return Value; }

#define OCUBE_READONLY_MINMAX_PROPERTY(Type, Name, Value1,Value2) \
  public:                                                         \
  Q_PROPERTY(Type Name##_MIN READ Name##_MIN CONSTANT)            \
    Type Name##_MIN() const { return (Value1); }                  \
  Q_PROPERTY(Type Name##_MAX READ Name##_MAX CONSTANT)            \
    Type Name##_MAX() const { return (Value2); }

//Logger Macro
#ifdef ENABLE_DEBUG
#define VERBOSE() qDebug("DEBUG : [%s][%s:%d]", __FILE__, __func__, __LINE__)
#define DEBUG(MESSAGE) qDebug() << QString("DEBUG : [%1][%2:%3] - ").arg(__FILE__).arg(__func__).arg(__LINE__) << (MESSAGE)
#else
#define VERBOSE()
#define DEBUG(MESSAGE)
#endif

//Error message
#define LANG_ERROR0     tr("")
#define LANG_ERROR1     tr("External power Lost")



#endif // HMIGLOBAL_H
