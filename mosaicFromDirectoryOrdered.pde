import java.util.Arrays;
import java.util.List;
import java.io.

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles(new FileNameExtensionFilter("JPEGs","jpeg"));
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

int xSize = 15;
int ySize = 15;
int imgXSize=150;
int imgYSize=150;
File[] files;
ImgWithMetadata[] imgs=new ImgWithMetadata[xSize*ySize];
List<ImgWithMetadata> filteredList;

void setup()
{
  size(xSize*imgXSize, ySize*imgYSize);
  String path = sketchPath+"/data";
  files = listFiles(path);
  noLoop();
  for (int i=0; i<xSize*ySize; i++)
  {
    String filename = files[i].getName();
    try 
    {
      imgs[i] = new ImgWithMetadata(filename);
    }
    catch (Exception e)
    {
      println("Error loading " +  filename);
    }
  }
  filteredList = hpf(80,80,imgs,histogramTypes.SAT);
}



// High Pass Filter: Checks if all histogram values above cutoffPercentage are above cutoffValue
List<ImgWithMetadata> hpf(int cutoffValue, int cutoffPercentage, ImgWithMetadata[] images, histogramTypes histogramType)
{
  ArrayList<ImgWithMetadata> result = new ArrayList<ImgWithMetadata>();
  for (ImgWithMetadata img : images)
  {
    //println("filtering image: " + img.imageFilename);
    println("filtering image: ");
    int lowerBound = 255 - 255 * cutoffPercentage/100;
    int upperBound = 255;
    boolean pass = true;
    for (int i=lowerBound; i<upperBound; i++)
    {
      switch (histogramType)
      {
      case HUE: 
        if (img.histogramSat[i]<cutoffValue) pass = false; 
        break;
      case SAT: 
        if (img.histogramSat[i]<cutoffValue) pass = false; 
        break;
      case BRI: 
        if (img.histogramBri[i]<cutoffValue) pass = false; 
        break;
      }
    }
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

void draw()
{
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
