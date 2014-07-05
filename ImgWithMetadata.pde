public class ImgWithMetadata 
{
  PImage image;
  String imageFilename;
  int[] histogramHue=new int[256];
  int[] histogramSat=new int[256];
  int[] histogramBri=new int[256];

  ImgWithMetadata(String filename)
  {
    PImage img = loadImage(filename);
    image=img;
    imageFilename = filename;
    buildHistograms();
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
}

