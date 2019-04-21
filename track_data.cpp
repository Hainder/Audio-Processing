#include "track_data.hpp"
#include "audiomanage.hpp"

template<typename T>
constexpr T M_PI = T(3.1415926535897932385);


TrackData::TrackData(QObject *parent) : QObject(parent)
{

}

void TrackData::getSound(QString path){

    std::string path_sound = path.toStdString();
    bool stream;
    //check .ogg or .wav
    if (path_sound.find(".ogg") == std::string::npos || path_sound.find(".ogg") == std::string::npos )
        stream = false;
      else
        stream = true;

    sound.audioLoad(path_sound,stream);
    sound.audioGetData(path_sound);


}


/////////////////////////GET LEFT CHANNEL////////////////////////////
    std::vector<qreal> TrackData::getAudioLeft(QString filename,bool EX){
        std::string path = filename.toStdString();
        return setAudioLeft(sound.audioRconfPlot(path,EX));
    }
        std::vector<qreal> TrackData::setAudioLeft(std::vector <qreal> data){

            std::vector<qreal> result;
            for (int i=0; i<data.size(); i+=2){
                result.push_back(data[i]); //only L data load
            }
            return result;
        }
/////////////////////////GET RIGHT CHANNEL////////////////////////////
    std::vector<qreal> TrackData::getAudioRight(QString filename,bool EX){

        std::string path = filename.toStdString();
        return setAudioRight(sound.audioRconfPlot(path,EX));
    }

        std::vector<qreal> TrackData::setAudioRight(std::vector <qreal> data){

            std::vector<qreal> result;
            for (int i=1; i<data.size(); i+=2){
                result.push_back(data[i]);  //only R data load
            }
            return result;
        }
////////////////////////////////////////////////////////////////////


void TrackData::setEffects(QString filename,float gain, float pan,float timeshift){
    std::string path = filename.toStdString();
    sound.audioEXproc(path,gain,pan,timeshift);
}


void TrackData::wavWrite(QString filename){
    std::string path = filename.toStdString();
    sound.audioWavWrite(path);
}

void TrackData::playAudio(QString filename, float gain, float pan, float timeshift){
    std::string path = filename.toStdString();
    gain = gain/4;
    if (gain==0||gain<0)
        gain = 0;
    Sleep(timeshift*1000);
    sound.Play(path,gain,pan,0);
}
