import java.util.Arrays;
import java.util.List;
import java.io.FilenameFilter;
import java.util.Collections;
import java.util.EnumSet;
import static java.util.EnumSet.of;

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


int xSize=4;
int ySize=4;
int cutoffBri = 10;
int percentageBri = 70;
int cutoffSat = 10;
int percentageSat = 60;
int imgXSize=300;
int imgYSize=300;
int filesFound = 0;
File[] files;
ArrayList<ImgWithMetadata> imgs;
List<ImgWithMetadata> filteredList;

void setup()
{
  imgs = new ArrayList<ImgWithMetadata>();
  size(xSize*imgXSize, ySize*imgYSize);
  //String path = sketchPath+"/data";
  String path = "/Users/Nils/PycharmProjects/jsontests/hiresImgs_test";
  files = listFiles(path, ".jpeg");
  for (int i=0; i<files.length; i++)
  {
    String filename = files[i].getName();
    try 
    {
      imgs.add(new ImgWithMetadata(path+"/"+filename));
    }
    catch (Exception e)
    {
      println("Error loading " +  filename);
    }
  }
  //filteredList = hpf(25, 190, imgs, histogramTypes.SAT);
  filteredList = hpf(percentageBri, cutoffBri, hpf(percentageSat, cutoffSat, imgs, histogramTypes.SAT), histogramTypes.BRI);
  filesFound = filteredList.size();
  println("Files after HPF: " + filesFound);
  Collections.sort(filteredList);
}

void mousePressed() {
  background(0);
  if (mouseButton == LEFT) {
    RemoveFromList(mouseX, mouseY);
  } else if (mouseButton == RIGHT) {
    drawMosaic();
  }
}

void RemoveFromList(int x, int y)
{
  filteredList.remove(getPos(x/imgXSize, y/imgYSize));
}

void drawMosaic()
{
  if (filteredList.size()<xSize*ySize) return;
  for (int y = 0; y<ySize; y++)
  {
    for (int x = 0; x<xSize; x++)
    {
      int currentPos = getPos(x, y);
      image(filteredList.get(currentPos).image, x*imgXSize, y*imgYSize, imgXSize, imgYSize);
    }
  }
}


void keyPressed()
{
  if (key=='s') 
  {
    save("hues"+xSize+"x"+ySize+"-bri"+cutoffBri+percentageBri+"-sat"+cutoffSat+percentageSat+"-ff"+filesFound+".png");
  }
}

void draw()
{
  //drawMosaic();
}

