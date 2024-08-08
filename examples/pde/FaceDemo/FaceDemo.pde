import oscP5.*;
import ddf.minim.*; // minim req to gen audio
import xyscope.*;   // import XYscope
import java.util.Collections;
import java.util.Comparator;

import javax.sound.midi.*;  //MIDIのためのライブラリ
import ddf.minim.*; // minim req to gen audio
import ddf.minim.ugens.*; // freq from pitch

FacemeshClient client;
XYscope xy;         // create XYscope instance
float scaleFactor = 1.0; // スケールファクターを定義
ArrayList<PVector> facePoints;

MidiControl midiControl = new MidiControl();

///---変数宣言---///
boolean midiSetupDone = false; // MIDIのセットアップが完了したかどうかのフラグ
int keyTranspose = -2;  //デバッグ用、キー操作によるピッチ変更
boolean keyBool = false;

void setup() {
  size(600, 400);
  //colorMode(HSB, 360, 100, 100);
  client = new FacemeshClient(7500);
  //XYScopeの初期化
  xy = new XYscope(this, "");
  xy.limitPath(2); // remove box around whole thing
  facePoints = new ArrayList<PVector>();

  keyTranspose = -2;      //MIDIピッチ初期化（デバッグ用）
}

void draw() {
  background(55);
  List<Face> faces = client.getFaces();
  float centerX = width / 2;
  float centerY = height / 2;

  //XYScope関連の処理
  facePoints.clear();
  
  for (int i = 0; i < faces.size(); i++) {
    Face face = faces.get(i);
    
    // draw skeleton
    strokeWeight(2);
    stroke(map(i, 0, faces.size(), 0, 360), 80, 100);
    noFill();
    
    for (int j = 0; j < FACE_CONNECTIONS.length; j += 2) {
      KeyPoint a = face.keypoints[FACE_CONNECTIONS[j]];
      KeyPoint b = face.keypoints[FACE_CONNECTIONS[j+1]];
      float ax = (a.x - 0.5) * width * scaleFactor + centerX;
      float ay = (a.y - 0.5) * height * scaleFactor + centerY;
      float bx = (b.x - 0.5) * width * scaleFactor + centerX;
      float by = (b.y - 0.5) * height * scaleFactor + centerY;
      line(ax, ay, bx, by);

      //XYscopeの座標を格納
      facePoints.add(new PVector(ax, ay));
      facePoints.add(new PVector(bx, by));
    }
    
    /*
    // 【デバッグ】インデックス番号を表示する
    fill(255);
    textSize(12);
    for (int k = 0; k < face.keypoints.length; k++) {
      KeyPoint kp = face.keypoints[k];
      float kx = (kp.x - 0.5) * width * scaleFactor + centerX;
      float ky = (kp.y - 0.5) * height * scaleFactor + centerY;
      fill (255);
      text(k, kx, ky);
    }
    */

    /*
     // draw circles with intensity
    noStroke();
    fill(map(i, 0, faces.size(), 0, 360), 80, 100);
    for (KeyPoint kp : face.keypoints) {
      float kx = (kp.x - 0.5) * width * scaleFactor + centerX;
      float ky = (kp.y - 0.5) * height * scaleFactor + centerY;
      circle(kx, ky, kp.z * 100 * scaleFactor);
    }
    */

  
    // clear waves like refreshing background
  xy.clearWaves();
  // convert face points to waves
  if (facePoints.size() > 0) {
    xy.beginShape();
    for (PVector point : facePoints) {
      xy.vertex(point.x, point.y);
    }
    xy.endShape();
  }
  // build audio from shapes
  xy.buildWaves();
  // draw XY analytics
  xy.drawXY();
  
  }
  
  //デバッグ用テクスト表示
  /*
  fill(255);
  text("Detected " + faces.size() + " Face!", 10, 20);
  */

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