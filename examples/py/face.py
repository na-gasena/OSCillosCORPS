import argparse

import cv2
import mediapipe as mp
from mediapipe.framework.formats import landmark_pb2
from pythonosc import udp_client
from pythonosc.osc_message_builder import OscMessageBuilder

from examples.py.utils import add_default_args, get_video_input

OSC_ADDRESS = "/mediapipe/facemesh"

# 必要なランドマークのインデックス
IMPORTANT_LANDMARKS = set([
  # 左目
  #263, 249, 390, 373, 374, 380, 381, 382, 362, 466, 388, 387, 386, 385, 384, 398,
  # 左目（間引き）
  263, 390, 374, 381, 362, 388, 386, 384,
  # 左虹彩
  #474, 475, 476, 477,
  # 左眉毛
  #276, 283, 282, 295, 285, 300, 293, 334, 296, 336,
  # 左眉毛(間引き)
  276, 282, 285, 296,
  # 右目
  #33, 7, 163, 144, 145, 153, 154, 155, 133, 246, 161, 160, 159, 158, 157, 173,
  # 右目
  33, 163, 145, 154, 133, 161, 159, 157,
  # 右虹彩
  #469, 470, 471, 472,
  # 右眉毛
  #46, 53, 52, 65, 55, 70, 63, 105, 66, 107,
  # 右眉毛(間引き)
  46, 52, 55, 66,
  # 唇
  #61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291, 185, 40, 39, 37, 0, 267, 269, 270, 409, 78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308, 191, 80, 81, 82, 13, 312, 311, 310, 415,
  # 唇(間引き)
  61, 91, 84, 314, 321, 291, 40, 37, 267, 270, 78, 88, 87, 317, 318, 308, 80, 82, 312, 310,
  # 鼻
  1, 2, 98, 327, 168, 6, 195, 5, 4,
  # 顔の輪郭
  #10, 338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288, 397, 365, 379, 378, 400, 377, 152, 148, 176, 149, 150, 136, 172, 58, 132, 93, 234, 127, 162, 21, 54, 103, 67, 109
  # 顔の輪郭(間引き)
  10, 338, 332, 251, 356, 323, 288, 365, 378, 377, 148, 149, 136, 58, 93, 127, 21, 103, 109
])

# ランドマークのインデックスの総数を計算
total_landmarks = len(IMPORTANT_LANDMARKS)
print(total_landmarks)

def send_face_landmarks(client: udp_client, detections: [landmark_pb2.NormalizedLandmarkList]):
    if detections is None:
        client.send_message(OSC_ADDRESS, 0)
        return

    #print("detections: " + str(detections))  # デバッグ用

    # OSCメッセージの生成と送信
    builder = OscMessageBuilder(address=OSC_ADDRESS)
    builder.add_arg(len(detections))
    for detection in detections:
        for idx, landmark in enumerate(detection.landmark):
            if idx in IMPORTANT_LANDMARKS:
                builder.add_arg(landmark.x)
                builder.add_arg(landmark.y)
                builder.add_arg(landmark.z)
                builder.add_arg(landmark.visibility)
    msg = builder.build()
    client.send(msg)

def main():
    # 引数の読み込み
    parser = argparse.ArgumentParser()
    add_default_args(parser)
    args = parser.parse_args()

    # OSCクライアントの作成
    client = udp_client.SimpleUDPClient(args.ip, args.port)

    mp_drawing = mp.solutions.drawing_utils
    mp_face_mesh = mp.solutions.face_mesh

    face_mesh = mp_face_mesh.FaceMesh(
        min_detection_confidence=0.5, min_tracking_confidence=0.5)
    cap = cv2.VideoCapture(get_video_input(args.input))
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            break

        # 画像を水平反転し、BGRからRGBに変換
        image = cv2.cvtColor(cv2.flip(image, 1), cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
        results = face_mesh.process(image)

        send_face_landmarks(client, results.multi_face_landmarks)

        # 画像にランドマークを描画
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        if results.multi_face_landmarks:
            for face_landmarks in results.multi_face_landmarks:
                for idx, landmark in enumerate(face_landmarks.landmark):
                    if idx in IMPORTANT_LANDMARKS:
                        mp_drawing.draw_landmarks(
                            image, face_landmarks, connections=None,
                            landmark_drawing_spec=mp_drawing.DrawingSpec(thickness=1, circle_radius=1))
        cv2.imshow('MediaPipe OSC FaceMesh', image)
        if cv2.waitKey(5) & 0xFF == 27:
            break
    face_mesh.close()
    cap.release()

if __name__ == "__main__":
    main()