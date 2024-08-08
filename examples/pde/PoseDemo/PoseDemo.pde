import oscP5.*;
import ddf.minim.*; // minim req to gen audio
import xyscope.*;   // import XYscope
import java.util.Collections;
import java.util.Comparator;

import javax.sound.midi.*;  //MIDIのためのライブラリ
import ddf.minim.*; // minim req to gen audio
import ddf.minim.ugens.*; // freq from pitch

///---クラスの読み込み---///
XYscope xy;         // create XYscope instance
PoseClient client;
ArrayList<PVector> skeletonPoints;

MidiControl midiControl = new MidiControl();

///---変数宣言---///
boolean midiSetupDone = false; // MIDIのセットアップが完了したかどうかのフラグ
int keyTranspose = -2;  //デバッグ用、キー操作によるピッチ変更
boolean keyBool = false;


void setup() {
  size(512, 512, P3D);
  //colorMode(HSB, 360, 100, 100);
  client = new PoseClient(7500);
  xy = new XYscope(this, "");
  xy.limitPath(2); // remove box around whole thing
  skeletonPoints = new ArrayList<PVector>();

  keyTranspose = -2;      //MIDIピッチ初期化（デバッグ用）
}



///------------処理-----------------///
void draw() {
  background(0);

    

  ///---MediaPipe管理（OSC受信データ処理）---///
  if (client.poseCount > 0) {
    skeletonPoints.clear();
    // draw skeleton
    strokeWeight(4);
    noFill();
    for (int i = 0; i < POSE_CONNECTIONS.length; i += 2) {
      KeyPoint a = client.pose.keypoints[POSE_CONNECTIONS[i]];
      KeyPoint b = client.pose.keypoints[POSE_CONNECTIONS[i+1]];
      //stroke(map(i, 0, POSE_CONNECTIONS.length, 0, 360), 80, 100);
      line(a.x * width, a.y * height, b.x * width, b.y * height);
      skeletonPoints.add(new PVector(a.x * width, a.y * height));
      skeletonPoints.add(new PVector(b.x * width, b.y * height));
    }
  
    // draw pose keypoints
    for (KeyPoint kp : client.pose.keypoints) {
      noStroke();
      fill(0);
      circle(kp.x * width, kp.y * height, 10);
    }

  }

  
  /// --- XYscopeの処理 --- ///
  // clear waves like refreshing background
  xy.clearWaves();
  // convert skeleton points to waves
  if (skeletonPoints.size() > 0) {
    xy.beginShape();
    for (PVector point : skeletonPoints) {
      xy.vertex(point.x, point.y);
    }
    xy.endShape();
  }
  // build audio from shapes
  xy.buildWaves();
  // draw XY analytics
  xy.drawXY();



  ///--- MIDI管理--- ///
  if (!midiSetupDone) {
        //setupMidiをコメントアウトすればMIDIオフになる
        midiControl.setupMidi(midiControl.midiTrack); //MIDIのセットアップ
        midiSetupDone = true;
    }

    //キーボード上下キーでトランスポーズを変更
    if (keyPressed) {
        if (!keyBool) {
            if (keyCode == UP) {
                keyTranspose += 1;
            } else if (keyCode == DOWN) {
                keyTranspose -= 1;
            }
        }
        
        keyBool = true;
        
        keyTranspose = constrain(keyTranspose, -7, 4);
        midiControl.midiTranspose = keyTranspose;
    }
}



void keyReleased() {
    if ((keyCode == UP) || (keyCode == DOWN)) {
        keyBool = false;
    }
}