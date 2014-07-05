public class ImgWithMetadata 
{
  PImage image;
  String imageFilename;
  int[] histogramHue=new int[256];
  int[] histogramSat=new int[256];
  int[] histogramBri=new int[256];
  int dominantHue;

  ImgWithMetadata(String filename)
  {
    PImage img = loadImage(filename);
    image=img;
    imageFilename = filename;
    buildHistograms();
    dominantHue = calcDominantHue();
  }

  void buildHistograms()
  {
    for (int i=0; i<image.pixels.length; i++)
    {
      int pixel=image.pixels[i];
      int hue = int(hue(pixel));
      histogramHue[hue]++;
      int sat = int(saturation(pixel));
      histogramSat[sat]++;
      int bri = int(brightness(pixel));
      histogramBri[bri]++;
    }
  }
  
  int compareTo(Object o)
  {
    ImgWithMetadata other=(ImgWithMetadata)o;
    if (other.dominantHue>dominantHue)  
      return -1;
    if (other.dominantHue==dominantHue)
      return 0;
    else
      return 1;
  }

  private int calcDominantHue()
  {
    int maxCount = max(histogramHue);
    int dominantHue=0;
    for (int i=0; i<histogramHue.length; i++)
    {
      if (histogramHue[i]==maxCount) dominantHue = i;
    }
    return dominantHue;
  }
  
}

