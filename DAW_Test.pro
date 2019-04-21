QT += quick
QT += widgets
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    audiomanage.cpp \
        main.cpp \
    track_data.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!arndroid: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    FMODE/fmod.h \
    FMODE/fmod.hpp \
    FMODE/fmod_codec.h \
    FMODE/fmod_common.h \
    FMODE/fmod_dsp.h \
    FMODE/fmod_dsp_effects.h \
    FMODE/fmod_errors.h \
    FMODE/fmod_output.h \
    audiomanage.hpp \
    track_data.hpp

DISTFILES += \
    #fmod64.dll \
    #fmodL.dll \
    #fmodL64.dll \
    fmod_vcd.lib



unix|win32: LIBS += -L$$PWD/./ -lfmod_vc

INCLUDEPATH += $$PWD/.
DEPENDPATH += $$PWD/.
