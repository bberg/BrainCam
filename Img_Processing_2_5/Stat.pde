class Stat{
int minimum;
int maximum;
int range;
float fMean;
int mean;
int sum = 0;
int ss = 0;
float fSd;
int sd;
int median;
int numDataPoints;
int[] statA = new int[8];
  
  
  public Stat(int[] stat, int numDataPoints){
    
    for (int i=0; i <numDataPoints; i++){
      if (i==0) minimum = stat[i];
      if (i==0) maximum = stat[i];
      if (i < minimum) minimum = stat[i];
      if (i > maximum) maximum = stat[i];
      sum += stat[i];
    }
    
    range = maximum - minimum;
    fMean = sum/numDataPoints;
    mean = round(fMean);
    median = stat[(numDataPoints+1)/2];

    for (int i=0; i <numDataPoints; i++){
      ss+= pow(stat[i]-mean, 2);
    }
    fSd = sqrt(ss/numDataPoints);
    sd = round(fSd);
    statA[0] = numDataPoints;
    statA[1] = minimum;
    statA[2] = maximum;
    statA[3] = range;
    statA[4] = mean;
    statA[5] = median;
    statA[6] = ss;
    statA[7] = sd;
  }
  float mapRelMean(float low, float high){
  return map(fMean, minimum, maximum, low, high);
  } 
  float map100Mean(float low, float high){
  return map(fMean, 0, 100, low, high);
  }
}
