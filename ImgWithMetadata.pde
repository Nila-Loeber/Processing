public class ImgWithMetadata implements Comparable
{
  PImage image;
  int hue;

  ImgWithMetadata(PImage pImage)
  {
    image=pImage;
    hue=determineHue(image);
  }

  int compareTo(Object o)
  {
    ImgWithMetadata other=(ImgWithMetadata)o;
    if (other.hue>hue)  
      return -1;
    if (other.hue==hue)
      return 0;
    else
      return 1;
  }

  private int determineHue(PImage image)
  {
    int[] hues=new int[256];
    for (int i=0; i<image.pixels.length; i++)
    {

      int hue = int(hue(image.pixels[i]));
      //println(i + ": " + hue);
      hues[hue]++;
    }
    int maxCount = max(hues);
    int dominantHue=0;
    for (int i=0; i<hues.length; i++)
    {
      if (hues[i]==maxCount) dominantHue = i;
    }
    return dominantHue;
  }
}
