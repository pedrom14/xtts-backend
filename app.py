from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import os
import uuid
from TTS.api import TTS

app = Flask(__name__)
CORS(app)

# Caminho do modelo
MODEL_PATH = "xtts/xtts_v2/"
tts = TTS(model_path=MODEL_PATH, config_path=f"{MODEL_PATH}/config.json", progress_bar=False, gpu=False)

@app.route("/tts", methods=["POST"])
def generate_tts():
    data = request.json
    text = data.get("text")
    language = data.get("language", "pt")
    speaker = tts.speakers[0] if tts.speakers else None

    if not text:
        return jsonify({"error": "Texto não fornecido"}), 400
    if not speaker:
        return jsonify({"error": "Nenhum speaker disponível"}), 500

    # Caminhos temporários
    tmp_id = uuid.uuid4().hex
    wav_path = f"/tmp/xtts_{tmp_id}.wav"
    mp3_path = f"/tmp/xtts_{tmp_id}.mp3"

    try:
        # Gera o áudio .wav
        tts.tts_to_file(
            text=text,
            file_path=wav_path,
            speaker=speaker,
            language=language
        )

        # Converte para .mp3 com ffmpeg
        os.system(f"ffmpeg -y -i {wav_path} -codec:a libmp3lame -qscale:a 2 {mp3_path}")
        os.remove(wav_path)

        # Envia o arquivo .mp3 e limpa
        response = send_file(mp3_path, mimetype="audio/mpeg")
        os.remove(mp3_path)
        return response

    except Exception as e:
        print("Erro ao gerar TTS:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


