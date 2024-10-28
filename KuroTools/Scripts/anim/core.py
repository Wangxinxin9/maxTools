
import subprocess
import os
from pymxs import runtime as rt

FFMPEG_PATH = os.path.join(os.path.dirname(__file__), u"tools", u"ffmpeg.exe")

def convert_avi_to_mov(input_path, output_path):
    cmd_args = [FFMPEG_PATH]
    cmd_args += ["-i", input_path]
    cmd_args += ["-vcodec", "libx264"]
    cmd_args += ["-pix_fmt","yuv420p"]
    cmd_args += [output_path, "-y"]
    ffmpeg_process = subprocess.Popen(cmd_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    for std_out_line in iter(ffmpeg_process.stdout.readline, ""):
        print(std_out_line.strip())
    ffmpeg_process.stdout.close()
    return_code = ffmpeg_process.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, cmd_args)

def convert_avi_to_mp4(input_path, output_path):
    cmd_args = [FFMPEG_PATH, "-i", input_path, output_path, "-y"]
    ffmpeg_process = subprocess.Popen(cmd_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    for std_out_line in iter(ffmpeg_process.stdout.readline, ""):
        print(std_out_line.strip())
    ffmpeg_process.stdout.close()
    return_code = ffmpeg_process.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, cmd_args)

if __name__ == "__main__":
    if rt.previewDefFileName_ != None and rt.previewSaveFileName_ != None:
        if rt.previewSaveFileType_ == "mp4":
            convert_avi_to_mp4(rt.previewDefFileName_, rt.previewSaveFileName_)
        else:
            convert_avi_to_mov(rt.previewDefFileName_, rt.previewSaveFileName_)
        #convert_avi_to_mov((r'F:\_preview.avi'), (r'F:\_preview.mp4'))
