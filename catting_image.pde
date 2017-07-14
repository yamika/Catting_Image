import javax.swing.*;
import controlP5.*;
import java.util.*;
ControlP5 cp5;

//画像のインスタンス
PImage pimage;
PImage cat_img;
//ファイルのパスを保持する
String File_paths[];
//パスのリスト表示用
String View_File_paths[];
// 現在表示されている画像のパス
String Current_img_path = null;
//切り取った画像の保存名に使う
String label = "";
String num = "";
//画像の再ロード時の画面クリアに使う
int old_width=0,old_height=0;
//切り取る四角の座標
int start_x,start_y;
int end_x,end_y;
int SAVE_NUM = 0;
//切り取る四角の大きさ
final int RECT_SIZE = 64;
//読み込みディレクトリのパス
final String LOAD_DATA_PATH ="/Users/read_dir";
//保存先のディレクトリのパス
final String SAVE_DATA_PATH = "/Users/save_dir" + "/";
//切り取りのイベント
boolean isCatting = false;
boolean step1,step2 = false;
void setup(){
  stroke(255,0,0);
  strokeWeight(3);
  noFill();
  background(255,255,255);
  size(820,700);
  Loadfolder();
  //ラベル入力フォーム
  cp5 = new ControlP5(this);
  cp5.addTextfield("label")
        .setPosition(700,500)
        .setSize(100,40)
        .setFont(createFont("arial",13));
  //番号
 cp5.addTextfield("number")
      .setPosition(700,560)
      .setSize(100,40)
      .setFont(createFont("arial",13));

//画像フォルダの一覧リスト
List<String> l = Arrays.asList(View_File_paths);

cp5.addScrollableList("dropdown")
   .setPosition(690, 50)
   .setSize(120, 400)
   .setBarHeight(30)
   .setItemHeight(30)
   .setFont(createFont("arial",11))
   .addItems(l);
}

void draw(){
}

void keyPressed(){
  if(key == 'Z' || key == 'z'){
    //切り抜きイベントをオンにする
      isCatting = true;
      step1 = true;
      println("Catting event : ON");   
  }else if(key == 'X' || key == 'x'){
    //画像のリロードと切り抜きイベントのオフ
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
  }else if(key == ENTER  || key == 'C' || key == 'c'){
          if(pimage != null && label != null && num != null && isCatting == true){
          label = cp5.get(Textfield.class,"label").getText();
          if(SAVE_NUM == 0){
            //SAVE_NUMを番号入力フォームの値で初期化
            //以降の保存時の番号は初期化の値を++1した番号になる
            num = cp5.get(Textfield.class,"number").getText();
            SAVE_NUM = Integer.parseInt(num);
          }else{
            SAVE_NUM++;
          }
          num = Integer.toString(SAVE_NUM);
          //切り取った画像
          try{          
              cat_img = pimage.get(start_x,start_y,abs(end_x - start_x), abs(end_y-start_y));
              cat_img.resize(RECT_SIZE,RECT_SIZE);
              //画像の保存場所は各自で設定する
              cat_img.save(SAVE_DATA_PATH+label+"-"+num+".jpg");
              println("Save image" + SAVE_DATA_PATH+label+"-"+num+".jpg");
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
            //画像と短形のクリア
            stroke(255);
            fill(255);
            rect(0,0,pimage.width,pimage.height);
            image(pimage, 0, 0, pimage.width, pimage.height); 
            stroke(255,0,0);
            noFill();
            println("Catting event : OFF");
          }
      }
  }
}
void mouseClicked(){
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

void Loadfolder(){
  File f = new File(LOAD_DATA_PATH);
  File[] getFile = f.listFiles();
  File_paths = new String[getFile.length];
  View_File_paths = new String[getFile.length];
  String s = "";
  for(int i = 0; i < getFile.length; i++){
      s = getFile[i].getPath();
      String ext = s.substring(s.lastIndexOf('.') + 1);
      ext.toLowerCase();
      if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif") || ext.equals("jpeg") ||  ext.equals("JPG") ||  ext.equals("PNG")){
            File_paths[i] = s;
            View_File_paths[i] = s.substring(s.lastIndexOf('/'));
      }else{
          File_paths[i] = "Failed";
          View_File_paths[i] = "Failed";     
      }
  }
}

void dropdown(int n) {
  Current_img_path = File_paths[n];
  
  println(Current_img_path);
  if(!Current_img_path.equals("Failed")){
    //選択ファイルパスの画像を取り込む
    pimage = loadImage(Current_img_path);
    println("Load : "+ Current_img_path);
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
  }
}