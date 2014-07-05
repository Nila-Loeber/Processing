import java.util.Arrays;
import java.util.List;
import java.io.FilenameFilter;

File[] listFiles(String dir, final String allowedExt) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(allowedExt);
      }
    }
    );
    println("Files found: " + files.length);
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// High Pass Filter: Checks if cutoffPercentage of pixels are above cutoffValue
List<ImgWithMetadata> hpf(int cutoffPercentage, int cutoffValue, List<ImgWithMetadata> images, histogramTypes histogramType)
{

  ArrayList<ImgWithMetadata> result = new ArrayList<ImgWithMetadata>();
  for (ImgWithMetadata img : images)
  {
    int totalPixels = img.image.pixels.length;
    int numPixelsAboveCutoff=0;
    int lowerBound = cutoffValue;
    int upperBound = 255;
    println(String.format("filtering image: %s. lower bound: %d", img.imageFilename, lowerBound) );
    for (int i=lowerBound; i<upperBound; i++)
    {
      switch (histogramType)
      {
        case HUE: 
          numPixelsAboveCutoff+=img.histogramHue[i];
          break;
      case SAT: 
        //println(img.histogramSat[i]);
        numPixelsAboveCutoff+=img.histogramSat[i];
        break;
      case BRI: 
        numPixelsAboveCutoff+=img.histogramBri[i]; 
        break;
      }
    }

    float percentageOfPixelsAboveCutoff = ((float)numPixelsAboveCutoff / totalPixels * 100);
    println(String.format("totalPixels: %d - numPixelsAboveCutoff: %d - percentageOfPixelsAboveCutoff: %f", totalPixels, numPixelsAboveCutoff, percentageOfPixelsAboveCutoff));
    boolean pass = percentageOfPixelsAboveCutoff > cutoffPercentage;
    if (pass) result.add(img);
  }  
  return result;
}


int getCurrentPos(int x, int y)
{
  return y*xSize + x;
}

int getPos(int x, int y)
{
  return y*ySize+x;
}


int xSize =5;
int ySize = 5;
int imgXSize=150;
int imgYSize=150;
File[] files;
ArrayList<ImgWithMetadata> imgs;
List<ImgWithMetadata> filteredList;

void setup()
{
  imgs = new ArrayList<ImgWithMetadata>();
  size(xSize*imgXSize, ySize*imgYSize);
  String path = sketchPath+"/data";
  files = listFiles(path, ".jpeg");
  noLoop();
  for (int i=0; i<files.length; i++)
  {
    String filename = files[i].getName();
    try 
    {
      imgs.add(new ImgWithMetadata(filename));
    }
    catch (Exception e)
    {
      println("Error loading " +  filename);
    }
  }
  filteredList = hpf(70, 150, imgs, histogramTypes.SAT);
  println("Files after HPF: " + filteredList.size());
}




void draw()
{
  if (filteredList.size()<xSize*ySize) return;
  for (int y = 0; y<ySize; y++)
  {
    for (int x = 0; x<xSize; x++)
    {
      int currentPos = getPos(x, y);
      image(filteredList.get(currentPos).image, x*imgXSize, y*imgYSize, 150, 150);
      // println(currentPos + " : " + imgs[currentPos].hue);
    }
  }
  save("hues"+xSize+"x"+ySize+".png");
}

