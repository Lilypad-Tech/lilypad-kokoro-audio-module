from kokoro import KPipeline
import scipy
import torch
import os

def save_audio(audio: torch.Tensor, filename: str):
    output_dir = "/outputs"
    os.makedirs(output_dir, exist_ok=True)

    # # Save as wav format
    wav_output_path = os.path.join(output_dir, filename)
    if audio is not None:
        # Ensure audio is on CPU and in the right format
        audio_cpu = audio.cpu().numpy()
        
        # Save using scipy.io.wavfile
        scipy.io.wavfile.write(
            wav_output_path,
            24000,  # Kokoro uses 24kHz sample rate
            audio_cpu
        )
    else:
        print("No audio was generated")

pipeline = KPipeline(lang_code='a')
prompt = os.environ.get("PROMPT", os.environ.get("DEFAULT_PROMPT", "In a world increasingly shaped by technology, the pace of innovation shows no sign of slowing. From artificial intelligence and blockchain to quantum computing and biotechnology, every field is evolving rapidly, promising to reshape how we live, work, and connect."))
voice = os.environ.get("VOICE", os.environ.get("DEFAULT_VOICE", "heart"))

# frenir is the male voice
if voice == "fenrir":
    voice_preset = "am_fenrir"
elif voice == "heart":
    voice_preset = "af_heart"
elif voice == "bella":
    voice_preset = "af_bella"
elif voice == "puck":
    voice_preset = "am_puck"
else:
    # Default to heart if an unsupported voice is provided
    voice_preset = "af_heart"

generator = pipeline(prompt, voice=voice_preset)
for i, (gs, ps, audio) in enumerate(generator):
    save_audio(audio, 'output.wav')
    