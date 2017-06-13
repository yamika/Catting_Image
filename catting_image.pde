import javax.swing.*;
import controlP5.*;
ControlP5 cp5;
//画像のインスタンス
PImage pimage;
PImage cat_img;
PImage buttonImage1,buttonImage2,buttonImage3,buttonImage4;
//選択ファイルの名前を保持する
String getFile = null;
//切り取った画像の保存名に使う
String label = "";
String num = "";
//画像の再ロード時の画面クリアに使う
int old_width=0,old_height=0;
//切り取る四角の座標
int start_x,start_y;
int end_x,end_y;
//切り取る四角の大きさ
final int RECT_SIZE = 64;
//保存先のディレクトリのパス
final String DATA_PATH = "./";
//切り取りのイベント
boolean isCatting = false;
boolean step1,step2 = false;
void setup(){
  stroke(255,0,0);
  strokeWeight(3);
  noFill();
  background(255,255,255);
  size(820,700);
  buttonImage1 = loadImage("loadimage.gif");
  buttonImage2 = loadImage("catout.gif");
  buttonImage3 = loadImage("reload.gif");
  buttonImage4 = loadImage("saveimage.gif");
  image(buttonImage1,700,350);
  image(buttonImage2,700,390);
  image(buttonImage3,700,430);
  image(buttonImage4,700,470);
  //ラベル入力フォーム
  cp5 = new ControlP5(this);
  cp5.addTextfield("label")
        .setPosition(700,210)
        .setSize(100,40)
        .setFont(createFont("arial",13));
  //番号
 cp5.addTextfield("number")
      .setPosition(700,260)
      .setSize(100,40)
      .setFont(createFont("arial",13));
}

void draw(){
  if(getFile != null){
    fileLoader(); 
  } 
  image(buttonImage1,700,350);
  image(buttonImage2,700,390);
  image(buttonImage3,700,430);
  image(buttonImage4,700,470);
}

void mouseClicked(){
  //println(mouseX,mouseY);
  //ファイル選択のイベント
  if(mouseX>=700 && mouseX<=800 && mouseY>=350 && mouseY<=380){
      getFile = getFileName(); 
  } 
  //切り抜きのイベントをオンにする
  else if(mouseX>=700 && mouseX<=800 && mouseY>=390 && mouseY<=420){
      isCatting = true;
      step1 = true;
      println("Catting event : ON");
  }
  //四角の消去
  else if(mouseX>=700 && mouseX<=800 && mouseY>=430 && mouseY<=460){
      stroke(255);
      fill(255);
      //画像をクリアしてから表示
      rect(0,0,pimage.width,pimage.height);
      image(pimage, 0, 0, pimage.width, pimage.height); 
      stroke(255,0,0);
      noFill();
      //イベントをオフにしておく
      isCatting = false;
      step1 = false;
      step2 = false;
      start_x = 0;
      start_y = 0;
      end_x = 0;
      end_y = 0;
      println("Catting event : OFF");
  }
  //保存
  else if(mouseX>=700 && mouseX<=800 && mouseY>=470 && mouseY<=500){
      if(pimage != null && label != null && num != null && isCatting == true){
          label = cp5.get(Textfield.class,"label").getText();
          num = cp5.get(Textfield.class,"number").getText();
          //切り取った画像
          try{          
              cat_img = pimage.get(start_x,start_y,abs(end_x - start_x), abs(end_y-start_y));
              cat_img.resize(RECT_SIZE,RECT_SIZE);
              //画像の保存場所は各自で設定する
              cat_img.save(DATA_PATH+label+"-"+num+".jpg");
              println("Save image");
              start_x = 0;
              start_y = 0;
              end_x = 0;
              end_y = 0;
          }catch(Exception e){
                e.printStackTrace(); 
          }finally{
            isCatting = false;
            step1 = false;
            step2 = false;
            println("Catting event : OFF");
          }
      }
  }
  //切り抜きするための範囲を示す四角を描く
  if(pimage != null){
      if(isCatting && (mouseX>= 0 && mouseX<=pimage.width && mouseY>=0 && mouseY<= pimage.height) ){
        if(step1 == true && step2 == false){
          start_x = mouseX;
          start_y = mouseY;
          point(start_x,start_y);
          println("Start point done");
          step1 = false;
          step2 = true;
        }else if(step1 == false && step2 == true){
          end_x = mouseX;
          end_y = mouseY;
          rect(start_x,start_y,abs(end_x - start_x), abs(end_y-start_y));
          point(end_x,end_y);
          step1 = false;
          step2 = false;
        }
     }
   }
 
}

void fileLoader(){
  //選択ファイルパスの拡張子の文字列を取得する
  String ext = getFile.substring(getFile.lastIndexOf('.') + 1);
  //その文字列を小文字にする
  ext.toLowerCase();
  //文字列末尾がjpg,pngのいずれかであれば 
  if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif") || ext.equals("jpeg")){
    //選択ファイルパスの画像を取り込む
    pimage = loadImage(getFile);
    println("Load : "+ getFile);
    if(pimage.width > 700 || pimage.height > 700){
      pimage.resize(pimage.width/5,pimage.height/5);
    }
    if(old_width == 0 && old_height == 0){
      old_width = pimage.width;
      old_height = pimage.height;
    }
    //イメージ表示 
    stroke(255);
    fill(255);
    //キャンバスを一旦クリアする
    rect(0,0,old_width,old_height);
    image(pimage, 0, 0, pimage.width, pimage.height); 
    //サイズを保持しておく
    old_width = pimage.width;
    old_height = pimage.height;
    stroke(255,0,0);
    noFill();
    //print(pimage.width);
  }
  //選択ファイルパスを空に戻す
  getFile = null; 
}

//ファイル選択画面、選択ファイルパス取得の処理 
String getFileName(){
  //処理タイミングの設定 
  SwingUtilities.invokeLater(new Runnable() { 
      public void run() {
          try {
               //ファイル選択画面表示 
              JFileChooser fc = new JFileChooser(); 
               int returnVal = fc.showOpenDialog(null);
               //「開く」ボタンが押された場合
               if (returnVal == JFileChooser.APPROVE_OPTION) {
                 //選択ファイル取得 
                 File file = fc.getSelectedFile();
                 //選択ファイルのパス取得 
                 getFile = file.getPath(); 
               }else{
                 step1 = false;
                 step2 = false;
                 isCatting = false;
               }
          }
            //上記以外の場合 
           catch (Exception e) {
               //エラー出力 
               e.printStackTrace(); 
           } 
      } 
  });
  //選択ファイルパス取得
  return getFile; 
}