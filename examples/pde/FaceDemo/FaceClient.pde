import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public final int KEY_POINT_COUNT = 80; // 顔のランドマークの数

class FacemeshClient {
  private OscP5 osc;
  private List<Face> faces;

  public FacemeshClient(int port) {
    faces = new CopyOnWriteArrayList<Face>();
    osc = new OscP5(this, port);
  }

  public synchronized List<Face> getFaces() {
    return faces;
  }

  private void oscEvent(OscMessage msg) {
    if (msg.checkAddrPattern("/mediapipe/facemesh")) {
      updateFaces(faces, msg);
    }
  }

  private synchronized void updateFaces(List<Face> faces, OscMessage msg) {
    int faceCount = msg.get(0).intValue();
    if (faceCount != faces.size()) {
      faces.clear();
      for (int i = 0; i < faceCount; i++) {
        faces.add(new Face());
      }
    }
    for (int f = 0; f < faceCount; f++) {
      int offset = 1 + (f * KEY_POINT_COUNT * 4);
      Face face = faces.get(f);
      for (int i = 0; i < KEY_POINT_COUNT; i++) {
        int index = offset + (i * 4);
        face.keypoints[i].x = msg.get(index++).floatValue();
        face.keypoints[i].y = msg.get(index++).floatValue();
        face.keypoints[i].z = msg.get(index++).floatValue();
        face.keypoints[i].visibility = msg.get(index++).floatValue();
      }
    }
  }
}

class Face {
  KeyPoint[] keypoints;

  public Face() {
    keypoints = new KeyPoint[KEY_POINT_COUNT];
    for (int i = 0; i < keypoints.length; i++) {
      keypoints[i] = new KeyPoint();
    }
  }
}

class KeyPoint extends PVector {
  float visibility;
}

public final int[] FACE_CONNECTIONS = {
  //顔輪郭
  5,60,
  60,59,
  59,40,
  40,61,
  61,57,
  57,47,
  47,63,
  63,66,
  66,65,
  65,31,
  31,32,
  32,29,
  29,13,
  13,23,
  23,27,
  27,6,
  6,25,
  25,26,
  26,5,
  //左眉
  46,49,
  49,45,
  45,44,
  //右眉
  12,15,
  15,11,
  11,10,
  //左目
  62,68,
  68,69,
  69,70,
  70,41,
  41,71,
  71,64,
  64,67,
  67,62,
  //右目
  28,34,
  34,35,
  35,36,
  36,7,
  7,37,
  37,30,
  30,33,
  33,28,
  //鼻
  38,4,
  4,39,
  39,3,
  3,2,
  2,0,
  0,1,
  1,24,
  24,0,
  1,58,
  58,0,
  58,38,
  24,38,
  //口
  14,9,
  9,8,
  8,42,
  42,43,
  43,48,
  48,56,
  56,53,
  53,19,
  19,22,
  22,14,
  14,16,
  16,17,
  17,18,
  18,52,
  52,51,
  51,50,
  50,55,
  55,54,
  54,20,
  20,21,
  21,16,
  48,50
};