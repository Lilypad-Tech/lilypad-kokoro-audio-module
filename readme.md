# Lilypad-kokoro-module

This repo represents the [hexgrad/kokoro model](https://github.com/hexgrad/kokoro) as a module to be run on the Lilypad Network to produce text-to-audio inference

# Inputs

The module allows you to pass in a piece of text and generate an audio sample using the following parameters

- PROMPT -> The text to generate the audio sample from
- VOiCE -> The voice to be used to read the text with the avaailable voices being: `heart`, `fenrir`, `bella` and `puck`

# How to run

Run this on the lilypad network via:

```bash
lilypad run gihub.com/Lilypad-Tech/lilypad-kokoro-module:<add-commit-hash-here> -i prompt="hello world" -i voice="heart"
```

or through the Anura API

# Notes

- This model does not support creating custom voices or creating a copy of your own voice

# Acknowledgments

- [hexgrad/kokoro model](https://github.com/hexgrad/kokoro)