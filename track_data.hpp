#ifndef TRACK_DATA_HPP
#define TRACK_DATA_HPP

#include <vector>
#include <iostream>
#include <QObject>
#include <QDebug>
#include "audiomanage.hpp"
#include "windows.h"


class TrackData : public QObject, public audioMng
{
    Q_OBJECT
public:
    explicit TrackData(QObject *parent = nullptr);

    Q_INVOKABLE void getSound(QString path); //get the sound from file

    ////////////////////////////for plot/////////////////////////////////////////
    Q_INVOKABLE std::vector<qreal> getAudioLeft(QString filename,bool EX);//get gata for left channel
    Q_INVOKABLE std::vector<qreal> getAudioRight(QString filename,bool EX);//get gata for right channel
    Q_INVOKABLE std::vector<qreal> setAudioLeft(std::vector <qreal> data); //include only the left channel
    Q_INVOKABLE std::vector<qreal> setAudioRight(std::vector <qreal> data);//include only the right channel
    /////////////////////////////////////////////////////////////////////////////////////
    Q_INVOKABLE void setEffects(QString filename,float gain, float pan,float timeshift);    //set the effects to audio data
    Q_INVOKABLE  void playAudio(QString filename,float gain,float pan, float timeshift);    //play sound :))
    Q_INVOKABLE void wavWrite (QString filename);                                           //write a wav file

    audioMng sound;

};






#endif // TRACK_DATA_HPP
