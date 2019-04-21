#include <audiomanage.hpp>
#include <math.h>
#define PI_4 0.78539816339 // PI/4
#define SQRT2_2 0.70710678118 // SQRT(2)/2


audioMng::audioMng(){

    FMOD::System_Create(&system);
    system->init(32,FMOD_INIT_NORMAL,nullptr);
}

audioMng::~audioMng(){
    SoundMap::iterator iter;
    for (iter = sounds.begin(); iter != sounds.end();++iter)
        iter->second->release();
    sounds.clear();
    system->release();
    system = 0;
}



void audioMng::audioLoad(const std::string &path,bool streami){
    stream = streami;
    if (sounds.find(path) != sounds.end()) return;
    FMOD::Sound* sound = nullptr;
    if (stream)
        system->createStream(path.c_str(), FMOD_DEFAULT, nullptr, &sound);
    else
        system->createSound(path.c_str(), FMOD_DEFAULT,nullptr, &sound);
   sounds.insert(std::make_pair(path,sound));

    //gets type, format, num of channels, bit per sample of sound
   sound->getFormat(&typeOFsound,&soundFORMAT,&current_sound_channel,&current_sond_bits_sample);
   //gets sample rate friquency
   sound->getDefaults(&current_sound_friq,nullptr);

}

void audioMng::audioGetData(const std::string &path){
    sound_vector_data.clear();
    SoundMap::iterator sound = sounds.find(path); //finding a need sound
    if (sound == sounds.end()) qDebug()<<"error at LoadData";
    unsigned int datalen;   //entire data lenght
    if (!stream) {//if sound file is *.wav
        void* ptr1; //first part of data
        void* ptr2; //second part of data
        unsigned int len1;  //length of ptr1
        unsigned int len2;  //length of ptr2



        sound->second->getLength(&datalen,FMOD_TIMEUNIT_PCM); //get the sound's length
        lengthOFaudioDATA = datalen;

        sound->second->lock(0,datalen,&ptr1,&ptr2,&len1,&len2); //lock at sound's data
        PCM16* ptrData = static_cast<PCM16*>(ptr1); //read ptr1 data from void
        for (int i=0;i<datalen;i++){
           sound_vector_data.push_back(ptrData[i]); //load to vector for next processing
        }

        audioSetSecChannel(&sound_vector_data); //for write file
        sound_PCM_vector_data.insert(std::make_pair(path,sound_vector_data)); //storege sound data in map by filename
        sound->second->unlock(&ptr1, &ptr2,len1,len2); //unlock from FMOD for FMOD needed
        }
    else {  //if sound file is *.ogg
        sound->second->getLength(&datalen,FMOD_TIMEUNIT_PCM); //get the sound's length
        PCM16* buffer = new PCM16 [datalen];    //buffer for data
        unsigned int read;  //how much read
        sound->second->readData(buffer,datalen,&read); //take a data
        for (int i=0;i<datalen;i++){
           sound_vector_data.push_back(buffer[i]); //load it in vector
        }

        audioSetSecChannel(&sound_vector_data); //for write file
        sound_PCM_vector_data.insert(std::make_pair(path,sound_vector_data)); //storege sound data in map by filename

        }
}

void audioMng::audioSetSecChannel(std::vector <PCM16> *data){
    std::vector <PCM16> datain = *data;
    data->clear();
    for (int i=0; i<datain.size(); i++) {
        data->push_back(datain[i]);     //Left channel
        data->push_back(datain[i]);     //Right channel
    }

}


//////////////////////////////////////////////////////////////////////////////////////////////////

void audioMng::audioEXproc(const std::string &path,float gain,float pan,float timeshift){
    sound_map_PCM_vector_data::iterator soundData = sound_PCM_vector_data.find(path);
    std::vector <PCM16> tempSoundData = soundData->second;
    timeShift(&tempSoundData,timeshift);
    gainSET(&tempSoundData,gain);
    panSET(&tempSoundData,pan);

    sound_vector_data = tempSoundData;
    tempSoundData.clear();
}

    void audioMng::gainSET(std::vector <PCM16>* data, float gain){
        std::vector <PCM16> datain = *data;
        data->clear();
        for (int i = 0; i<datain.size();i++){
            if(datain[i]*gain>32767)
                data->push_back(32767); //cutoff
            else if (datain[i]*gain<-32767)
                data->push_back(-32767);    //cutoff
            else
                data->push_back((PCM16)(datain[i]*gain));
        }
    }

    void audioMng::panSET(std::vector <PCM16> *data, float pan){
        std::vector <PCM16> datain = *data;
        data->clear();
        float leftGain;
        float rightGain;
        getLRgain(pan,&leftGain,&rightGain);    //take gain for each channel
        for (int i = 0; i<datain.size(); i+=2){
            //set up left channel gain
            if(datain[i]*leftGain>32767)
                data->push_back(32767); //cutoff
            else if (datain[i]*leftGain<-32767)
                data->push_back(-32767);    //cutoff
            else
                data->push_back((PCM16)(datain[i]*leftGain));

            //set up right channel gain
            if(datain[i]*rightGain>32767)
                data->push_back(32767);
            else if (datain[i]*rightGain<-32767)
                data->push_back(-32767);
            else
                data->push_back((PCM16)(datain[i]*rightGain));

        }
    }
        void audioMng::getLRgain(float pan, float* LGAIN, float* RGAIN){
            *LGAIN = 1.0f - pan;
            *RGAIN = 1.0f + pan;
        }

    void audioMng::timeShift(std::vector<PCM16> *data, float timeshift){
        if (timeshift!=0){
            int size = abs(int(timeshift*current_sound_friq));
            std::vector <PCM16> datain = *data; //buffer for old samples
            data->clear();
            PCM16 test=PCM16(0);
                for (int i=0;i<size;i++){
                        data->push_back(test);//push back an dalay
                }
                for (int i=0;i<datain.size();i++){
                        data->push_back(datain[i]);//push back old samples
                }
       }
    }

void audioMng::audioWavWrite(const std::string &path){
//      wav header setting
    WAVHEADER head;

    head.chunkId[0] = 'R';
    head.chunkId[1] = 'I';
    head.chunkId[2] = 'F';
    head.chunkId[3] = 'F';

    head.chunkSize = (sound_vector_data.size())*2 + 36;

    head.format[0] = 'W';
    head.format[1] = 'A';
    head.format[2] = 'V';
    head.format[3] = 'E';

    head.subchunk1Id[0] = 'f';
    head.subchunk1Id[1] = 'm';
    head.subchunk1Id[2] = 't';
    head.subchunk1Id[3] = ' ';

    head.subchunk1Size = current_sond_bits_sample;

    head.audioFormat = 1;

    head.numChannels = 2;
    head.sampleRate = current_sound_friq;
    head.byteRate = current_sound_friq*2*current_sond_bits_sample/8;
    head.blockAlign = 2*current_sond_bits_sample/8;
    head.bitsPerSample = current_sond_bits_sample;

    head.subchunk2Id[0] = 'd';
    head.subchunk2Id[1] = 'a';
    head.subchunk2Id[2] = 't';
    head.subchunk2Id[3] = 'a';

    head.subchunk2Size = (sound_vector_data.size())*2*2;

    //set the sound for write
    sound_map_PCM_vector_data::iterator soundData = sound_PCM_vector_data.find(path);

    FILE *file;
    fopen_s(&file, path.c_str(), "wb");
    fwrite(&head,sizeof(WAVHEADER),44,file);//write head

    for (int i = 0; i < sound_vector_data.size(); i++)
    {
        fwrite(&sound_vector_data[i],2,1,file); //write sound
    }
    fclose(file);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
std::vector<qreal> audioMng::audioRconfPlot(const std::string& path, bool EX){

    std::vector <qreal> result;

    sound_map_PCM_vector_data::iterator audiodata = sound_PCM_vector_data.find(path);

    if (audiodata == sound_PCM_vector_data.end()) qDebug()<<"empty map";
    std::vector <PCM16> tempSound;
    if (EX) //hed been effets set or had been not set
       tempSound = sound_vector_data;
    else
       tempSound = audiodata->second;

    for(int i=0; i<tempSound.size();i++){
       result.push_back((qreal)tempSound[i]/(qreal)32768); //recalc data for plot
    }

    return result;

}

///////////////////////////////////////////////////////////////////////////////////////////////////




void audioMng::Play(const std::string &path,float gain,float pan,float timeshift){
    SoundMap::iterator sound = sounds.find(path);
    if (sound == sounds.end()) return;

      system->playSound(sound->second,nullptr,  false, &soundChannel); //FMOD start play
      soundChannel->setVolume(gain);    //fmod volume setting
      soundChannel->setPan(pan);        //fmod pan setting

      bool isPlayd = true;
    while (isPlayd) {
        soundChannel->isPlaying(&isPlayd);

        system->update();              //update for continue play while sound not over
    }
}

