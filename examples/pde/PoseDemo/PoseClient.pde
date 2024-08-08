import oscP5.*;

public final int KEY_POINT_COUNT = 33; //キーポイントの総数 (33 = Full Body / 25 = Upper Body)

class PoseClient {
  private OscP5 osc;

  public volatile int poseCount = 0;
  public volatile Pose pose;

  public PoseClient(int port) {
    pose = new Pose();
    osc = new OscP5(this, port);
  }

  private synchronized void oscEvent(OscMessage msg) {
    if (msg.checkAddrPattern("/mediapipe/pose")) {
      updatePose(pose, msg);
      return;
    }
  }

  private void updatePose(Pose pose, OscMessage msg) {
    poseCount = msg.get(0).intValue();

    if (poseCount == 0) return;


    for (int i = 0; i < KEY_POINT_COUNT; i++) {
      int index =  1 + (i * 4);
      pose.keypoints[i].x = msg.get(index++).floatValue();
      pose.keypoints[i].y = msg.get(index++).floatValue();
      pose.keypoints[i].z = msg.get(index++).floatValue();
      pose.keypoints[i].visibility = msg.get(index++).floatValue();
    }
  }
}

class Pose {
  KeyPoint[] keypoints;

  public Pose() {
    keypoints = new KeyPoint[KEY_POINT_COUNT];
    for (int i = 0; i < keypoints.length; i++) {
      keypoints[i] = new KeyPoint();
    }
  }
}

class KeyPoint extends PVector {
  float visibility = 0.0;
}

// keypoint definition
public final int NOSE = 0;
public final int RIGHT_EYE_INNER = 1;
public final int RIGHT_EYE = 2;
public final int RIGHT_EYE_OUTER = 3;
public final int LEFT_EYE_INNER = 4;
public final int LEFT_EYE = 5;
public final int LEFT_EYE_OUTER = 6;
public final int RIGHT_EAR = 7;
public final int LEFT_EAR = 8;
public final int MOUTH_RIGHT = 9;
public final int MOUTH_LEFT = 10;
public final int RIGHT_SHOULDER = 11;
public final int LEFT_SHOULDER = 12;
public final int RIGHT_ELBOW = 13;
public final int LEFT_ELBOW = 14;
public final int RIGHT_WRIST = 15;
public final int LEFT_WRIST = 16;
public final int RIGHT_PINKY = 17;
public final int LEFT_PINKY = 18;
public final int RIGHT_INDEX = 19;
public final int LEFT_INDEX = 20;
public final int RIGHT_THUMB = 21;
public final int LEFT_THUMB = 22;
public final int RIGHT_HIP = 23;
public final int LEFT_HIP = 24;
public final int RIGHT_KNEE = 25;
public final int LEFT_KNEE = 26;
public final int RIGHT_ANKLE = 27;
public final int LEFT_ANKLE = 28;
public final int RIGHT_HEEL = 29;
public final int LEFT_HEEL = 30;
public final int RIGHT_FOOT_INDEX = 31;
public final int LEFT_FOOT_INDEX = 32;

public final int[] POSE_CONNECTIONS = {
  NOSE, RIGHT_EYE_INNER, 
  RIGHT_EYE_INNER, RIGHT_EYE, 
  RIGHT_EYE, RIGHT_EYE_OUTER, 
  RIGHT_EYE_OUTER, RIGHT_EAR, 
  NOSE, LEFT_EYE_INNER, 
  LEFT_EYE_INNER, LEFT_EYE, 
  LEFT_EYE, LEFT_EYE_OUTER, 
  LEFT_EYE_OUTER, LEFT_EAR, 
  MOUTH_RIGHT, MOUTH_LEFT, 
  RIGHT_SHOULDER, LEFT_SHOULDER, 
  RIGHT_SHOULDER, RIGHT_ELBOW, 
  RIGHT_ELBOW, RIGHT_WRIST, 
  RIGHT_WRIST, RIGHT_PINKY, 
  RIGHT_WRIST, RIGHT_INDEX, 
  RIGHT_WRIST, RIGHT_THUMB, 
  RIGHT_PINKY, RIGHT_INDEX, 
  LEFT_SHOULDER, LEFT_ELBOW, 
  LEFT_ELBOW, LEFT_WRIST, 
  LEFT_WRIST, LEFT_PINKY, 
  LEFT_WRIST, LEFT_INDEX, 
  LEFT_WRIST, LEFT_THUMB, 
  LEFT_PINKY, LEFT_INDEX, 
  RIGHT_SHOULDER, RIGHT_HIP, 
  LEFT_SHOULDER, LEFT_HIP, 
  RIGHT_HIP, LEFT_HIP,
  RIGHT_HIP, RIGHT_KNEE,
  LEFT_HIP, LEFT_KNEE,
  RIGHT_KNEE, RIGHT_ANKLE,
  LEFT_KNEE, LEFT_ANKLE,
  RIGHT_ANKLE, RIGHT_HEEL,
  LEFT_ANKLE, LEFT_HEEL,
  RIGHT_ANKLE, RIGHT_FOOT_INDEX,
  LEFT_ANKLE, LEFT_FOOT_INDEX,
  RIGHT_HEEL, RIGHT_FOOT_INDEX,
  LEFT_HEEL, LEFT_FOOT_INDEX
};
