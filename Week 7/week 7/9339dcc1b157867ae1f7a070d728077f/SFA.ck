/*
Course: Music Programming
Date: 09Dec2013
Assignment #7: SomethingNice
*/


public class SFA
{
    //array of strings (path) for Use of an array of strings for loading sound files into SndBuf objects
    string sound_samples[9];
    //load array with file paths
    me.dir(-1) + "/audio/snare_01.wav" => sound_samples[0];
    me.dir(-1) + "/audio/snare_02.wav" => sound_samples[1];
    me.dir(-1) + "/audio/snare_03.wav" => sound_samples[2];
    me.dir(-1) + "/audio/stereo_fx_01.wav" => sound_samples[3];
    me.dir(-1) + "/audio/stereo_fx_02.wav" => sound_samples[4];
    me.dir(-1) + "/audio/stereo_fx_03.wav" => sound_samples[5];
    me.dir(-1) + "/audio/stereo_fx_04.wav" => sound_samples[6];
    me.dir(-1) + "/audio/stereo_fx_05.wav" => sound_samples[7];
    me.dir(-1) + "/audio/hihat_02.wav" => sound_samples[8];
    
    fun int getcap()
    {
        return this.sound_samples.cap();
    }
    
    fun string get(int which)
    {
        return this.sound_samples[which];
    }
}
