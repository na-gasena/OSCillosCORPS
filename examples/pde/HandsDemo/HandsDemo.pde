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
HandsClient client;
ArrayList<PVector> skeletonPoints;

MidiControl midiControl = new MidiControl();

///---変数宣言---///
boolean midiSetupDone = false; // MIDIのセットアップが完了したかどうかのフラグ
int keyTranspose = -2;  //デバッグ用、キー操作によるピッチ変更
boolean keyBool = false;



void setup() {
  size(512, 512, P3D);
  //colorMode(HSB, 360, 100, 100);
  client = new HandsClient(7500);
  xy = new XYscope(this, "");
  xy.limitPath(2); // remove box around whole thing
  skeletonPoints = new ArrayList<PVector>();

  keyTranspose = -2;      //MIDIピッチ初期化（デバッグ用）

}

void draw() {
  background(55);
  skeletonPoints.clear();


  List<Hand> hands = client.getHands();
  for (int i = 0; i < hands.size(); i++) {
    Hand hand = hands.get(i); //ここで左右の手のどちらかを取得している
    
    // draw skeleton
    strokeWeight(4);
    stroke(map(i, 0, hands.size(), 0, 360), 80, 100);
    noFill();
    
    for(int j = 0; j < HAND_CONNECTIONS.length; j += 2) {
      KeyPoint a = hand.keypoints[HAND_CONNECTIONS[j]];
      KeyPoint b = hand.keypoints[HAND_CONNECTIONS[j+1]];
      line(a.x * width, a.y * height, b.x * width, b.y * height);
      skeletonPoints.add(new PVector(b.x * width, b.y * height));
    }
    
    // draw circles with intensity
    noStroke();
    fill(map(i, 0, hands.size(), 0, 360), 80, 100);
    for (KeyPoint kp : hand.keypoints) {
      circle(kp.x * width, kp.y * height, kp.z * 100);
      // println("OSC msg <hand keypoint>" + kp); //デバッグ
    }
  }
    // println("--------------<hand keypoint END>----------------"); //デバッグ



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
  
  fill(255);
  text("Detected " + hands.size() + " Hand!", 10, 20);
}

void keyReleased() {
    if ((keyCode == UP) || (keyCode == DOWN)) {
        keyBool = false;
    }
}