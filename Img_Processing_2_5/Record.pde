class Record {
  int timeStamp;
  int imageNumber;
  String imageFile;
  int signalStrength;
  int attention;
  int meditation;
  int delta;
  int theta;
  int lAlpha;
  int hAlpha;
  int lBeta;
  int hBeta;
  int lGamma;
  int hGamma;
  int num;
  String imageNum;


  public Record(String[] pieces) {
    timeStamp = int(pieces[0]);
    imageNumber = int(pieces[1]);
    imageFile = pieces[2];
    signalStrength = int(pieces[3]);
    attention = int(pieces[4]);
    meditation = int(pieces[5]);
    delta = int(pieces[6]);
    theta = int(pieces[7]);
    lAlpha = int(pieces[8]);
    hAlpha = int(pieces[9]);
    lBeta = int(pieces[10]);
    hBeta = int(pieces[11]);
    lGamma = int(pieces[12]);
    hGamma = int(pieces[13]);
  }  
}
