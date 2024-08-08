![oscilloscorps_1_1](https://github.com/user-attachments/assets/10eee61f-74a4-4caf-a2bb-2356bd1591ee)
![analogOSC_1](https://github.com/user-attachments/assets/61c95f2c-5acd-49ce-b3d9-47421c1738c9)


 # 概要
MediaPipeを使用 (Python) してカメラからの映像を取得、それをリアルタイムで解析、OSC通信でProcessingに送り、オシロスコープの波形に変換して表示するプロトタイプです。
<br>また、MIDIデータを読み込み、波形に合成演奏させることも可能です。



![pose_1_1](https://github.com/user-attachments/assets/1833540b-c579-43ca-b89b-81b9776ebc52)![pose_2_1](https://github.com/user-attachments/assets/329c29df-3f9c-4a29-8baa-b9fdd16f2922)

![face_1_1](https://github.com/user-attachments/assets/6c043331-07bb-4af3-bd43-dbb996edee9e)![face_2_1](https://github.com/user-attachments/assets/ed3a4e7c-427c-4681-b7ea-e4918ad72a1b)
![hands_1_1](https://github.com/user-attachments/assets/a47865a3-ce2a-47fb-9ff5-6228bac712bd)![hands_2](https://github.com/user-attachments/assets/ad4c5104-4f79-417f-8d0a-9f00298aa53d)

 # インストールと実行
<dl>
  <dt> Pythonの仮想環境を作成（任意）し、以下のコマンドを実行</dt>
  <dt>実行に必要なライブラリの取り込み</dt>
</dl>

> `python install -r requirements.txt`

<br>
<dl>
  <dt>プログラムの実行</dt>

> `python face.py --input 2`
  <dd>--input　は使用するカメラの指定</dd>
  <dd>環境に合わせて指定する必要あり</dd>
  <br>

 > Processingを起動して、FaceDemo.pdeを実行

  <dd>Processingで必要なライブラリ：TODO</dd>
  <br>
  <dt>またはbatファイルを使用して、一括実行</dt>

</dl>

> `./examples/bat/pyprorun_face.bat`

<dl>    <dd>processing-java.exeのファイルパスを指定する必要あり</dd>

<br>

# UNDER CONSTRUCTION



