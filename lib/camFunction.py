import base64
import cv2
import numpy as np
import os
import datetime
from flask import Flask, jsonify, request

app = Flask(__name__)

save_dir = "lib/images"
os.makedirs(save_dir, exist_ok=True)

@app.route("/take_photo", methods=["POST"])
def take_photo():
    print("Recebendo solicitação para tirar foto...")
    data = request.get_json()
    base64_image = data.get("image")
    
    if base64_image:
        try:
            image_data = base64.b64decode(base64_image)
            np_image = np.frombuffer(image_data, np.uint8)
            img = cv2.imdecode(np_image, cv2.IMREAD_COLOR)
            
            filename = os.path.join(save_dir, f"foto_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.jpg")
            
            cv2.imwrite(filename, img, [int(cv2.IMWRITE_JPEG_QUALITY), 95])
            
            print(f"Foto salva com sucesso em {filename}")
            return jsonify({"status": "Foto tirada com sucesso", "filename": filename})
        except Exception as e:
            print(f"Erro ao salvar foto: {e}")
            return jsonify({"status": "Erro ao processar imagem"}), 500
    else:
        print("Imagem não encontrada na solicitação.")
        return jsonify({"status": "Erro ao processar imagem"}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
