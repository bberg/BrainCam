class Photo {
  import imageadjuster.*;
  int numDataPoints = 0; 
  int imgNumber;
  int[][] photoData = new int[maxIndividualPhotoSize][15];
  float attnArray;
  float[][] convAttn = new float[3][3];
  PImage picture;
  PImage conv;
  int attentionSum = 0;
  int meditationSum = 0;
  int attentionMean = 0;
  int meditationMean = 0;
  int attentionMin = 100;
  int meditationMin = 100;
  int attentionMax = 0;
  int meditationMax = 0;
  int[][] statData = new int[14][8];
  float attnMap;
  float medMap;
  PImage[] modification = new PImage[maxMod];
  int modCounter = 0;
  int picPointsA[] = new int[photoHolder.length];
  int allPointsA[] = new int[photoHolder.length];
  int timeStampA[] = new int[photoHolder.length];
  int signalStrengthA[] = new int[photoHolder.length];
  int attentionA[] = new int[photoHolder.length];
  int meditationA[] = new int[photoHolder.length];
  int deltaA[] = new int[photoHolder.length];
  int thetaA[] = new int[photoHolder.length];
  int lAlphaA[] = new int[photoHolder.length];
  int hAlphaA[] = new int[photoHolder.length];
  int lBetaA[] = new int[photoHolder.length];
  int hBetaA[] = new int[photoHolder.length];
  int lGammaA[] = new int[photoHolder.length];
  int hGammaA[] = new int[photoHolder.length];
  
  Stat picPoints;
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


  public Photo(int[][] photoHolder) {
    for (int l=0; l<photoHolder.length; l++) {
      photoData[l][0] = l;
      for (int k=0; k<14; k++) {
        photoData[l][k + 1] = photoHolder[l][k];          
        switch(k) {
          case(0): picPointsA[l]= photoData[l][k]; break;
          case(1): allPointsA[l]= photoData[l][k]; break;
          case(2): timeStampA[l]= photoData[l][k]; break;
          case(4): signalStrengthA[l]= photoData[l][k]; break;
          case(5): attentionA[l]= photoData[l][k]; break;
          case(6): meditationA[l]= photoData[l][k]; break;
          case(7): deltaA[l]= photoData[l][k]; break;
          case(8): thetaA[l]= photoData[l][k]; break;
          case(9): lAlphaA[l]= photoData[l][k]; break;
          case(10): hAlphaA[l]= photoData[l][k]; break;
          case(11): lBetaA[l]= photoData[l][k]; break;
          case(12): hBetaA[l]= photoData[l][k]; break;
          case(13): lGammaA[l]= photoData[l][k]; break;
          case(14): hGammaA[l]= photoData[l][k]; break;
        }
      } 
      if (photoData[l][2] > 0) numDataPoints++;
    }
    picPoints = new Stat(picPointsA, numDataPoints);
    allPoints = new Stat(allPointsA, numDataPoints);
    timeStamp = new Stat(timeStampA, numDataPoints);
    signalStrength = new Stat(signalStrengthA, numDataPoints);
    attention = new Stat(attentionA, numDataPoints);
    meditation = new Stat(meditationA, numDataPoints);
    delta = new Stat(deltaA, numDataPoints);
    theta = new Stat(thetaA, numDataPoints);
    lAlpha = new Stat(lAlphaA, numDataPoints);
    hAlpha = new Stat(hAlphaA, numDataPoints);
    lBeta = new Stat(lBetaA, numDataPoints);
    hBeta = new Stat(hBetaA, numDataPoints);
    lGamma = new Stat(lGammaA, numDataPoints);
    hGamma = new Stat(hGammaA, numDataPoints);

    for (int i = 0; i <14; i++){
        switch(i){
          case 0: for (int j = 0; j <8; j++)statData[i][j]=picPoints.statA[j]; break;
          case 1: for (int j = 0; j <8; j++)statData[i][j]=allPoints.statA[j]; break;
          case 2: for (int j = 0; j <8; j++)statData[i][j]=timeStamp.statA[j]; break;
          case 3: for (int j = 0; j <8; j++)statData[i][j]=signalStrength.statA[j]; break;
          case 4: for (int j = 0; j <8; j++)statData[i][j]=attention.statA[j]; break;
          case 5: for (int j = 0; j <8; j++)statData[i][j]=meditation.statA[j]; break;
          case 6: for (int j = 0; j <8; j++)statData[i][j]=delta.statA[j]; break;
          case 7: for (int j = 0; j <8; j++)statData[i][j]=theta.statA[j]; break;
          case 8: for (int j = 0; j <8; j++)statData[i][j]=lAlpha.statA[j]; break;
          case 9: for (int j = 0; j <8; j++)statData[i][j]=hAlpha.statA[j]; break;
          case 10: for (int j = 0; j <8; j++)statData[i][j]=lBeta.statA[j]; break;
          case 11: for (int j = 0; j <8; j++)statData[i][j]=hBeta.statA[j]; break;
          case 12: for (int j = 0; j <8; j++)statData[i][j]=lGamma.statA[j]; break;
          case 13: for (int j = 0; j <8; j++)statData[i][j]=hGamma.statA[j]; break;
        }
        
      }

    
    
    
    
    attentionMean = attentionSum/numDataPoints;
    meditationMean = meditationSum/numDataPoints;

    // TODO: create a subclass for each variable that will routinize this
    // this might require a 1D array within the photo class for each variable.
  /*  statData[0] = attentionMean;
    statData[1] = meditationMean;
    statData[2] = attentionSum;
    statData[3] = meditationSum;
    statData[4] = attentionMin;
    statData[5] = meditationMin;
    statData[6] = attentionMax;
    statData[7] = meditationMax;
*/
    medMap = map(meditationMean, 0, 100, 0, 255);
    attnMap = map(attentionMean, 0, 100, 0, 255);
    attnArray = map(attentionMean, 0, 100, -1.2, 0);
    convAttn[0][0] = attnArray;
    convAttn[0][1] = attnArray;
    convAttn[0][2] = attnArray;
    convAttn[1][0] = attnArray;
    convAttn[1][1] = attnArray*-9;
    convAttn[1][2] = attnArray;
    convAttn[2][0] = attnArray;
    convAttn[2][1] = attnArray;
    convAttn[2][2] = attnArray;


    imgNumber = photoData[0][3];

    picture = loadImage(imageDataArray[imgNumber][1]);
  }
  void transformByConvolution(int matrixSize, float[][] transformMatrix, int w, int h) {
    size(w, h);
    loadPixels();
    for (int x = 0; x < picture.width; x++) {
      for (int y = 0; y < picture.height; y++) {
        color c = convolution(x, y, matrixSize, transformMatrix, picture);
        int loc = x+(y*picture.width);
        pixels[loc] = c;
      }
    }

    updatePixels();
    //save("conv_" + imgNumber + ".jpg");
    //      text("5",20,20);
    //    }
    //  }
  }
  PImage adjustWholeImage(PImage input, int mod, int method, float intensity){
    modification[mod] = input;
    switch (method){
     case(0): adjust.contrast(modification[mod], intensity); break; 
     case(1): adjust.brightness(modification[mod], intensity); break;
     case(2): adjust.gamma(modification[mod], intensity); break;
    }
    
   return modification[mod]; 
  }

  PImage vingette(int mod, int method, float intensityC, float intensityE, float minMod, float maxMod) {
    modification[mod] = picture;
    for (int x = 0; x <picture.width; x++) {
      for (int y = 0; y <picture.height; y++) {
       float distToPixel = dist(x, y, picture.width/2, picture.height/2);
       float distToCorner = dist(0, 0, picture.width/2, picture.height/2);
       float percentDist = distToPixel/distToCorner;
         if (percentDist < maxMod && percentDist > minMod){
          switch (method) {
            case(0):
            float var = map(distToPixel, distToCorner*minMod, distToCorner*maxMod, intensityC, intensityE);
            adjust.contrast(modification[mod], x, y, 1, 1, var);
            break;
            case(1):
            float varA = map(distToPixel, distToCorner*minMod, distToCorner*maxMod, intensityC, intensityE);
            adjust.brightness(modification[mod], x, y, 1, 1, varA);
            break;
            case(2):
            float varB = map(distToPixel, distToCorner*minMod, distToCorner*maxMod, intensityC, intensityE);
            adjust.gamma(modification[mod], x, y, 1, 1, varB);
            break;
          }
        }
      }
    }
    return modification[mod];
  }
  
    PImage vingette(int mod, int method, float intensityC, float intensityMid, float intensityE, float minMod, float midMod, float maxMod) {
    modification[mod] = picture;
    for (int x = 0; x <picture.width; x++) {
      for (int y = 0; y <picture.height; y++) {
       float distToPixel = dist(x, y, picture.width/2, picture.height/2);
       float distToCorner = dist(0, 0, picture.width/2, picture.height/2);
       float percentDist = distToPixel/distToCorner;
         if (percentDist < maxMod && percentDist > minMod){
          float percentThru = (distToPixel-distToCorner*minMod)/ (distToCorner*maxMod)-(distToCorner*minMod);   //dist from pixel to min / dist from max to min
          
          switch (method) {
            
            case(0):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.contrast(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.contrast(modification[mod], x, y, 1, 1, var);
            }
            break;
            
            case(1):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.brightness(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.brightness(modification[mod], x, y, 1, 1, var);
            }
            break;

            case(2):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.gamma(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.gamma(modification[mod], x, y, 1, 1, var);
            }
            break;
          }
        }
      }
    }
    return modification[mod];
  }

PImage vingette(int input, int mod, int method, float intensityC, float intensityMid, float intensityE, float minMod, float midMod, float maxMod) {
    modification[mod] = modification[input];
    for (int x = 0; x <picture.width; x++) {
      for (int y = 0; y <picture.height; y++) {
       float distToPixel = dist(x, y, picture.width/2, picture.height/2);
       float distToCorner = dist(0, 0, picture.width/2, picture.height/2);
       float percentDist = distToPixel/distToCorner;
         if (percentDist < maxMod && percentDist > minMod){
          float percentThru = (distToPixel-distToCorner*minMod)/ (distToCorner*maxMod)-(distToCorner*minMod);   //dist from pixel to min / dist from max to min
          
          switch (method) {
            
            case(0):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.contrast(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.contrast(modification[mod], x, y, 1, 1, var);
            }
            break;
            
            case(1):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.brightness(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.brightness(modification[mod], x, y, 1, 1, var);
            }
            break;

            case(2):
            if (percentThru < midMod){
              float var = map(percentThru, minMod, midMod, intensityC, intensityMid);
              adjust.gamma(modification[mod], x, y, 1, 1, var);
            }
            else{
              float var = map(percentThru, midMod, maxMod, intensityMid, intensityE);
              adjust.gamma(modification[mod], x, y, 1, 1, var);
            }
            break;
          }
        }
      }
    }
    return modification[mod];
  }
}
