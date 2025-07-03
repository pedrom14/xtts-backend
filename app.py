from flask import Flask, request, send_file, jsonify
from flask_cors import CORS
from TTS.api import TTS
import uuid
import os

app = Flask(__name__)
CORS(app)

MODEL_PATH = "xtts/xtts_v2"
tts = TTS(model_path=MODEL_PATH, config_path=f"{MODEL_PATH}/config.json", progress_bar=False, gpu=False)

@app.route("/tts", methods=["POST"])
def tts_endpoint():
    try:
        data = request.get_json()
        text = data.get("text")
        language = data.get("language", "pt")

        if not text:
            return jsonify({"error": "Missing 'text'"}), 400

        filename = f"/tmp/{uuid.uuid4().hex}.mp3"
        speaker = tts.speakers[0]  # usa primeiro speaker embutido

        # Geração do TTS
        tts.tts_to_file(text=text, file_path=filename, speaker=speaker, language=language)

        return send_file(filename, mimetype="audio/mpeg")
    
    except Exception as e:
        print("Erro interno:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)



