### Catting Image

自作のデータセットでMNISTのような画像認識をするための画像を作成するものです。  
画像の切り抜きサイズはデフォルトで64にしてあります。  
変更したい場合はRECT_SIZEの値を変更してください。  
また画像の読み込み、保存先の設定は`LOAD_DATA_PATH`,`SAVE_DATA_PATH`の値を変更して設定してください。    
`z`キーで切り抜きのイベントをオンに、`x`キーで画像のリロード、切り抜きイベントのキャンセル、`c`または`ENTER`キーで画像の保存になります。     
入力フォームについては     
例 : 上(ラベル) -> hoge , 下(番号) -> 00001 この時保存名は hoge-00001.jpgとなります。  
番号の入力については初回のみ必要になります。      

#### 動作環境
* Processing 3.3
