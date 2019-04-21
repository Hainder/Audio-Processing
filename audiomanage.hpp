#ifndef AUDIOMANAGE_H
#define AUDIOMANAGE_H
#include <QObject>
#include <QDebug>
#include "FMODE/fmod.hpp"

#include <string>
#include <map>
#include <iostream>
#include <vector>

 typedef std::map<std::string, FMOD::Sound*> SoundMap;
 typedef short int PCM16;
 typedef std::map<std::string, std::vector<PCM16>> sound_map_PCM_vector_data;

class audioMng {

    public:
        audioMng();
         ~audioMng();

        void audioLoad (const std::string& path,bool streami);                          //load an audio from file
        void audioGetData (const std::string& path);                                    //get PCM from audio file
        void audioSetSecChannel (std::vector <PCM16> *data);                            //cose of all file mono - set stereo
        void audioEXproc (const std::string& path,float gain,float pan,float timeshift);//gain,pan,timeshift effects
        void audioWavWrite(const std::string& path);                                    //write wav file
        void Play (const std::string& path,float gain,float pan,float timeshift);       //play the sound
        std::vector<qreal> audioRconfPlot(const std::string& path,bool EX);             //reconf audio data for plot

    private:

      void gainSET (std::vector <PCM16>* data, float gain);          //gain setting
      void panSET(std::vector <PCM16>* data, float pan);             //pan setting
      void timeShift(std::vector <PCM16> *data,float timeshift);    //timeshift setting
      void getLRgain(float pan, float* LGAIN, float* RGAIN);        //calculate a gain for L and R channel for pan
         FMOD::System* system = nullptr;                            //init FMOD system
         FMOD::Channel* soundChannel = nullptr;                     //init FMOD channel
         SoundMap sounds;                                           //sound map (with sound from file )
         sound_map_PCM_vector_data sound_PCM_vector_data;           //audio data map (data from sound file ;))
         unsigned int lengthOFaudioDATA;                            //lenth of data from sound
         std::vector<PCM16> sound_vector_data;                      //vector for processed sound
         float current_sound_friq;                                  //Sample Rate Friquency
         int current_sound_channel;                                 //how mach cannel sound have (always one)
         int current_sond_bits_sample;                              //bit per sample
         FMOD_SOUND_TYPE typeOFsound;                               //FMOD type of sound file
         FMOD_SOUND_FORMAT soundFORMAT;                             //FMOD type of sound Format (pcm etc)
         bool stream;                                               // *.ogg or not *.ogg

        struct WAVHEADER                                            //wav header
        {
            char chunkId[4];
            unsigned long chunkSize;
            char format[4];
            char subchunk1Id[4];
            unsigned long subchunk1Size;
            unsigned short audioFormat;
            unsigned short numChannels;
            unsigned long sampleRate;
            unsigned long byteRate;
             unsigned short blockAlign;
            unsigned short bitsPerSample;
            char subchunk2Id[4];
            unsigned long subchunk2Size;
        };

};


#endif // SOUNDSYSTEM_H
