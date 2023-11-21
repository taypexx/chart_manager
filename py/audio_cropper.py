import sys
from moviepy.editor import AudioFileClip

def cut():    
    filepath = sys.argv[1]
    original_name = sys.argv[2]
    new_name = sys.argv[3]
    time_start = sys.argv[4]

    audio = AudioFileClip(filepath + "/" + original_name)
    cut_audio = audio.subclip(time_start)
    cut_audio.write_audiofile(filepath + "/" + new_name)

if __name__ =='__main__' : 
    cut()