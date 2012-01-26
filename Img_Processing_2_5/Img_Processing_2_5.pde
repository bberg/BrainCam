//Each photo's data is loaded into the 3D array photos[imageNumber][column (variable)][row (data point)].
//The last photo does not currently get loaded.
//Created a statistics class with each component of each picture defined as an object
  // individual components are properties and the photo[].Stat.statA[] array contains all of the stats for a particular
  // variable (Stat) for an image
  // the photo[].statArray[variable][statistic] array contains all stats for a photo
  //create a front end OR save the generated images.
//The photo class now contains a 2D array with all of the data from the image & the image itself.

int mousePress=0;
int maxSize = 10000;
int maxPhotos = 800;
int maxIndividualPhotoSize = 300;
int maxMod = 10;
Record[] records;
String[] lines;
int[][] dataArray = new int[14][maxSize];
int[][] photoHolder = new int[maxIndividualPhotoSize][14];
String[] referenceArray = new String[maxSize];
String[][] imageDataArray = new String[maxSize][2];
int[][][] photos = new int[maxPhotos][14][maxIndividualPhotoSize];
Photo[] photo;
String[] varName = {"imgRcrdNum", "rcrdNum","timeStamp", "imageNumber", "signalStrength", "attention", "meditation",
            "delta", "theta", "lAlphaA", "hAlpha", "lBeta", "hBeta", "lGamma", "hGamma"};
int recordCount = 0;
PFont body;
int num = 38; // Display this many entries on each screen.
int startingEntry = 0;  // Display from this entry number
int imageTotal = 0;
int imgMin;
int imgMax;
int imgNum = 0;
int prevMinCount;
int clickNumber=0;
import imageadjuster.*;
ImageAdjuster adjust = new ImageAdjuster(this);   // set up the imageadjuster library
int picPointsA[] = new int[maxSize];
int allPointsA[] = new int[maxSize];
int timeStampA[] = new int[maxSize];
int signalStrengthA[] = new int[maxSize];
int attentionA[] = new int[maxSize];
int meditationA[] = new int[maxSize];
int deltaA[] = new int[maxSize];
int thetaA[] = new int[maxSize];
int lAlphaA[] = new int[maxSize];
int hAlphaA[] = new int[maxSize];
int lBetaA[] = new int[maxSize];
int hBetaA[] = new int[maxSize];
int lGammaA[] = new int[maxSize];
int hGammaA[] = new int[maxSize];

  

  Stat allPoints;
  Stat timeStamp;
  Stat signalStrength;
  Stat attention;
  Stat meditation;
  Stat delta;
  Stat theta;
  Stat lAlpha;
  Stat hAlpha;
  Stat lBeta;
  Stat hBeta;
  Stat lGamma;
  Stat hGamma;


void setup() {
  size(1430, 1110);//should be 950
  fill(255);
  noLoop();
  

  
  body = loadFont("TheSans-Plain-12.vlw");
  textFont(body);
  
  lines = loadStrings("LOG.TXT");
  maxSize = lines.length;
  records = new Record[lines.length];
  
  for (int i = 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], ','); // Load data into array
    if (pieces.length == 14) {
      records[recordCount] = new Record(pieces);    // data -> records

      dataArray[0][recordCount] = recordCount;
      dataArray[1][recordCount] = int(pieces[0]);   // data -> 2D array [record][data chunk]
      dataArray[2][recordCount] = int(pieces[1]);
      referenceArray[recordCount] = pieces[2];
      for(int k=3; k<14; k++){
        dataArray[k][recordCount] = int(pieces[k]);
      }
      recordCount++;
    }

    imgMin = dataArray[2][0];
    imgMax = imgMin;
  }
  if (recordCount != records.length) {
    records = (Record[]) subset(records, 0, recordCount);
  }
   photo = new Photo[maxPhotos];
   parseDataArray();
     for (int o = imgNum; o < 201; o++){
    photo[o].transformByConvolution(3,photo[o].convAttn,640,480);
  }
   setGlobalStat();
   attnMedVen(12);
}




void parseDataArray(){                                    
  int prevMin = 0;
  String ext = ".jpg";
  imageDataArray[imgMin][0] = referenceArray[0];
  imageDataArray[imgMin][1] = "/" + dataArray[2][0] + ext;
    for (int j=1; j<maxSize; j++){                        // (subset() could make this easier)
       if (dataArray[2][j] > dataArray[2][j-1]){          // if we're at the start of a new photo
          if(imgMax < dataArray[2][j]){                   // check for a new maximum image number
              imgMax = dataArray[2][j];
            }
                                                              //setting the photos array(3D)
                                                              
            if (dataArray[2][j-1] == imgMin){                 //then we're between the first and 2nd photos
                  for (int l=0; l<j; l++){
                    for (int k=0; k<14; k++){
                      photos[imgMin][k][l] = dataArray[k][l];  // this is for the first image only
                      photoHolder[l][k] = dataArray[k][l];
                }
              }
              prevMin = j;              // first line of img 2 
                imgNum = imgMin;
                photo[imgNum] = new Photo(photoHolder);
                clearPhotoHolder();
            }
            else{                                              //first time through we will be between img 2 and 3
              for (int l=0; l<j-prevMin; l++){
                for (int k=0; k<14; k++){
                  photos[dataArray[2][j-1]][k][l] = dataArray[k][prevMin+l];
                  photoHolder[l][k] = dataArray[k][prevMin+l];
                }
              }
              prevMin = j;                                     //first line of next image
                  imgNum = dataArray[2][j-1];
                  photo[imgNum] = new Photo(photoHolder);
                  clearPhotoHolder();
            }                                                  //Currently this doesn't pass the last image
                                                               // last image is usually corrupted anyway

         imageDataArray[dataArray[2][j]][0] = referenceArray[dataArray[2][j]];
 //        String[] st = Integer.toString(dataArray[2][j]);
         imageDataArray[dataArray[2][j]][1] = "/" + dataArray[2][j] + ext;
       }
     }
}

void setGlobalStat(){
  for (int l=0; l<14; l++){
    for (int k=0; k<maxSize -1; k++){
         switch(l) {
          case(0): allPointsA[k]= dataArray[l][k]; break;
          case(1): timeStampA[k]= dataArray[l][k]; break;
          case(2): signalStrengthA[k]= dataArray[l][k]; break;
          case(3): attentionA[k]= dataArray[l][k]; break;
          case(4): meditationA[k]= dataArray[l][k]; break;
          case(5): deltaA[k]= dataArray[l][k]; break;
          case(6): thetaA[k]= dataArray[l][k]; break;
          case(7): lAlphaA[k]= dataArray[l][k]; break;
          case(8): hAlphaA[k]= dataArray[l][k]; break;
          case(9): lBetaA[k]= dataArray[l][k]; break;
          case(10): hBetaA[k]= dataArray[l][k]; break;
          case(11): lGammaA[k]= dataArray[l][k]; break;
          case(12): hGammaA[k]= dataArray[l][k]; break;
        }
    }
  }
    allPoints = new Stat(allPointsA, maxSize);
    timeStamp = new Stat(timeStampA, maxSize);
    signalStrength = new Stat(signalStrengthA, maxSize);
    attention = new Stat(attentionA, maxSize);
    meditation = new Stat(meditationA, maxSize);
    delta = new Stat(deltaA, maxSize);
    theta = new Stat(thetaA, maxSize);
    lAlpha = new Stat(lAlphaA, maxSize);
    hAlpha = new Stat(hAlphaA, maxSize);
    lBeta = new Stat(lBetaA, maxSize);
    hBeta = new Stat(hBetaA, maxSize);
    lGamma = new Stat(lGammaA, maxSize);
    hGamma = new Stat(hGammaA, maxSize);
}


void clearPhotoHolder(){
        for (int l=0; l<14; l++){                     // Clear photoHolder
          for (int k=0; k<maxIndividualPhotoSize; k++){
              photoHolder[k][l] = 0;
          }
        }
}

color convolution(int x, int y, int matrixSize, float[][] transformMatrix, PImage picture){
 float rTotal = 0.0;
 float gTotal = 0.0;
 float bTotal = 0.0;
 int offset = matrixSize / 2;
 for (int i = 0; i < matrixSize; i++){
   for (int j = 0; j < matrixSize; j++){
     int xloc = x+i-offset;
     int yloc = y+j-offset;
     int loc = xloc + picture.width*yloc;
     loc = constrain(loc, 0, picture.pixels.length-1);
     rTotal+= (red(picture.pixels[loc])*transformMatrix[i][j]);
     gTotal+= (green(picture.pixels[loc])*transformMatrix[i][j]);
     bTotal+= (blue(picture.pixels[loc])*transformMatrix[i][j]);
   }
 }
 rTotal = constrain(rTotal,0,255);
 gTotal = constrain(gTotal,0,255);
 bTotal = constrain(bTotal,0,255);
 return color(rTotal,gTotal,bTotal);
}



void draw() {
  background(0);
//  text(photo[imgMin+2].signalStrength.fSd,20,20);  
//  text(round(photo[imgMin+2].signalStrength.fSd),120,20);
//  text(photo[imgMin+2].signalStrength.sd,220,20);  
//  drawStats(12,20, 40);
//  drawFirstData(20, 300);
  drawFirst4Images(640, 480, 50);
//  drawRealStats(10,20,20);
//  float[][] convArray = {{-1, -1, -1},{-1,9,-1},{-1, -1, -1}};
  }

void keyPressed(){
      clickNumber++;
  drawFirst4Images(640, 480, 50);
  redraw();
}

void drawRealStats(int numI, int x, int y){
  for (int i=imgMin; i<imgMin+numI; i++){
    for (int j=0; j<7; j++){
      text(photo[i].meditation.statA[j], x + 40*j, y + 20*(i-imgMin));
    }
  }  
}


void drawStats(int numberOfPhotos, int x,int y){
  for (int j=imgMin; j<imgMin+numberOfPhotos; j++){
    for (int k=0; k<14; k++){
     for (int i = 0;i <8; i++){
     text(photo[j].statData[k][i], x+i*100,y+ 20*(k)+300*(j-imgMin));
     }

/*
     text(photo[j].numDataPoints, x + i*50, y + 20*(j-imgMin)); i++;
     text(photo[j].attentionMean, x + i*50, y + 20*(j-imgMin)); i++;
     text(photo[j].meditationMean, x + i*50, y + 20*(j-imgMin)); i++;
     text(photo[j].attentionMin, x + i*50, y + 20*(j-imgMin)); i++;
     text(photo[j].attentionMax, x + i*50, y + 20*(j-imgMin)); i++;
     text(photo[j].meditationMin, x + i*50, y + 20*(j-imgMin)); i++;
     */
    }
  }
}

void attnMedVen(int num){
  for (int i=imgMin; i< imgMin+num; i++){
//  photo[i].adjustWholeImage(photo[i].picture, 2, 1, photo[i].meditation.map100Mean(-1,1));
  photo[i].vingette(1,1,0,0,photo[i].meditation.mapRelMean(0,-1.3),0,photo[i].meditation.mapRelMean(1,.3),1);
  photo[i].vingette(1,0,0,photo[i].attention.map100Mean(1,7),1,photo[i].attention.map100Mean(1,-.25),0,photo[i].meditation.map100Mean(0,1),1);
//  photo[i].vingette(2,1,2,photo[i].attention.map100Mean(0,5),1,photo[i].attention.map100Mean(1,-1),0,photo[i].meditation.map100Mean(0,1),1);
  }
}
  

void drawFirst4Images(int w, int h, int s){
  size(2*w + 3*s, 2*h +3*s);
  for (int i = imgMin+clickNumber ;i < imgMin +2+clickNumber; i++){
    
//    tint(photo[i].attnMap, photo[i].medMap, 127);

  image(photo[i].modification[0],s + (s+w)*(i-imgMin-clickNumber),s,w,h);
//  image(photo[i].vingette(2,1,0,1.5,1,.75,0,.7,1),s + (s+w)*(i-imgMin-clickNumber),s,w,h);
  }
  for (int i = imgMin+2+clickNumber ;i < imgMin +4+clickNumber; i++){
   // tint(photo[i].attnMap, photo[i].medMap, 127);
    image(photo[i].modification[0],s + (s+w)*(i-imgMin-2-clickNumber),(2*s)+h,w,h);
  }
}

void drawSecond4Images(){
  for (int i = imgMin +4;i < imgMin +6; i++){
    tint(photo[i].attnMap, photo[i].medMap, 127);
  image(photo[i].picture,50 + 450*(i-imgMin-4),50,400,300);
  }
  for (int i = imgMin+6 ;i < imgMin +8; i++){
    tint(photo[i].attnMap, photo[i].medMap, 127);
    image(photo[i].picture,50 + 450*(i-imgMin-6),50+350,400,300);
  }
}

void drawData(int n, int x, int y){ 
 for (int i = imgMin +n ; i < imgMin +n + 1; i++){
    for (int k = 0; k < photo[i].photoData.length; k++){
      for (int j = 0; j < 15; j++){
        text(photo[i].photoData[k][j], x + j*50, y + (i-imgMin)*5*20 + k*20);
      }
    }
 }
} 


void drawThreeD(){
  for (int i = imgMin; i < imgMin+10; i++){                      //Display chunks of the 3D Array
    for (int k = 0; k < 4; k++){
      for (int j = 0; j < 14; j++){
        text(photos[i][j][k], 20 + j*50, 20 + (i-imgMin)*4*20 + k*20);
      }
    }
  }
}

  
/*      for (int i=imgMin; i <= imgMax; i++){                //Display the 2D Array
      text(i,20,20 + 20*(i-105),0);
      text(imageDataArray[i][0],40,20 + 20*(i-imgMin),0);
      text(imageDataArray[i][1],110,20 + 20*(i-imgMin),0);
      }
            for (int i=0; i < 14; i++){
              for(int j=0; j < dataArray[0].length; j++){
                text(dataArray[i][j],20 + i*50, 200 + j*20);
    }
  }*/




//BELOW THIS LINE IS BS//
/*        text(imageDataArray[105],40,20 + 40,0);
  text(106,20,20 + 20,0);
        text(imageDataArray[106],40,20 + 40,0);
                text(106,20,20 + 20,0);
        text(imageDataArray[107],40,20 + 60,0);
                text(106,20,20 + 20,0);
        text(imageDataArray[108],40,20 + 80,0);
                text(106,20,20 + 20,0);
        text(imageDataArray[109],40,20 + 100,0);
                text(imageDataArray[110],40,20 + 40,0);
                        text(imageDataArray[111],40,20 + 40,0);
                                                text(imageDataArray[111],40,20 + 40,0);
  */                      
//      }

        
//        if (dataArray[2][i] > dataArray[2][i-1]){
//      text(i,20,20 + 20*i,0);
//      text(referenceArray[i],40,20 + 20*i/20,0);
//      text(dataArray[2][i],110,20 + 20*i,0);


  /*
  for (int i=0; i < 14; i++){
    for(int j=0; j < dataArray[0].length; j++){
      text(dataArray[i][j],20 + i*50, 100 + j*20);
    }
  }*/
  
/*  text(min(Record[].imageNumber));
  for (int i = 0; i < num; i++) {
    int thisEntry = startingEntry + i;
    if (thisEntry < recordCount) {
    text(records[thisEntry].imageFile + " > " + records[thisEntry].imageNumber + " > " + records[thisEntry].timeStamp

+ " > " +      records[thisEntry].signalStrength + " > " + records[thisEntry].attention
+ " > " +      records[thisEntry].meditation + " > " + records[thisEntry].delta
+ " > " +      records[thisEntry].theta + " > " + records[thisEntry].lAlpha
+ " > " +      records[thisEntry].hAlpha + " > " + records[thisEntry].lBeta
+ " > " +      records[thisEntry].hBeta + " > " + records[thisEntry].lGamma
+ " > " +      records[thisEntry].hGamma, 20, 20 + i*20);
    }
  }
  */

/*
void mousePressed() {
      for (int i=0; i < 14; i++){
        for(int j=0; j < dataArray[0].length; j++){
          text(dataArray[i][j],20 + i*50, 100 + j*20);
    }
  }
}
*/
  
/*  startingEntry += num; 
  if (startingEntry > records.length) {
    startingEntry = 0;  // go back to the beginning
  } 
  redraw();

}  */

/*void refArray(){
    int[][] dataArray = new int[max(records[])][14]
    for int(i = 0; i < max(records[]); i++){
      dataArray[i][0] = 
      dataArray[i][1] =
      dataArray[i][2] =
      dataArray[i][3] =
      dataArray[i][4] =
      dataArray[i][5] =
      dataArray[i][6] =
      dataArray[i][7] =
      dataArray[i][8] =
      dataArray[i][9] =
      dataArray[i][10] =
      dataArray[i][11] =
      dataArray[i][12] =
      dataArray[i][13] =
      

  
void loadImages(){
  for(i = min(imageNumberA[]); i = max(imageNumberA[]); i++);      // image numbers must be sequential
}
  
  */  
  
/*  
  String prevImgEntry = "";
  String prevNumber = "";
  for (int thisImgEntry = 0; thisImgEntry < recordCount; thisImgEntry++){
    if (!records[thisImgEntry].imageFile.equals(prevImgEntry)){


      char[] imgNumber = new char[4];
      imgNumber[0] = records[thisImgEntry].imageFile.charAt(2);
      imgNumber[1] = records[thisImgEntry].imageFile.charAt(3);
      imgNumber[2] = records[thisImgEntry].imageFile.charAt(4);
      imgNumber[3] = records[thisImgEntry].imageFile.charAt(5);
      imgNumber[4] = records[thisImgEntry].imageFile.charAt(6);
      String imageNumber1 = new String(imgNumber);
      String[] imageNumber = {new String(imgNumber)};
      records[thisImgEntry].num = Integer.parseInt(imageNumber1);    //  this is redundant, but might need the number as eitehr an int
      records[thisImgEntry].imageNum = imageNumber1;                 //  or string in the future
      String[] ext = {".txt"};
      String[] imgLoc = concat(imageNumber, ext);
      images[1] = loadImage(imgLoc);
    }
      prevImgEntry = records[thisImgEntry].imageFile;
    }
    
  }
  
  */
  
