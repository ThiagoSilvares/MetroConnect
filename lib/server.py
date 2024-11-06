import base64
import cv2
import face_recognition
import numpy as np
from flask import Flask, request, jsonify

app = Flask(__name__)

known_face_encodings = []
known_face_names = []

# Carregar imagens e codificações
known_person1_image = face_recognition.load_image_file("lib/images/ThiagoSilvares.jpg")
known_person2_image = face_recognition.load_image_file("lib/images/MarianaRusso.jpg")
known_person1_encoding = face_recognition.face_encodings(known_person1_image)[0]
known_person2_encoding = face_recognition.face_encodings(known_person2_image)[0]

known_face_encodings.extend([known_person1_encoding, known_person2_encoding])
known_face_names.extend(["Thiago Silvares", "Mariana Russo"])

@app.route('/recognize', methods=['POST'])
def recognize_face():
    data = request.get_json()

    # Receber a imagem em base64
    img_data = base64.b64decode(data['image'])
    np_img = np.frombuffer(img_data, dtype=np.uint8)
    frame = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    face_locations = face_recognition.face_locations(frame)
    face_encodings = face_recognition.face_encodings(frame, face_locations)

    recognized_faces = []
    for face_encoding in face_encodings:
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        if True in matches:
            first_match_index = matches.index(True)
            recognized_faces.append(known_face_names[first_match_index])

    return jsonify({'recognized_faces': recognized_faces})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
