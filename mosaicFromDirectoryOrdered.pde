File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

int xSize = 10;
int ySize = 10;
int imgXSize=150;
int imgYSize=150;
File[] files;

void setup()
{
  size(xSize*imgXSize, ySize*imgYSize);
  String path = sketchPath+"/data/";
  files = listFiles(path);
  noLoop();
}

int getCurrentPos(int x, int y)
{
  return y*xSize + x;
}

void draw()
{

  for (int x = 0; x<xSize; x++)
  {
    for (int y = 0; y<xSize; y++)
    {
      ImgWithMetadata img = new ImgWithMetadata(loadImage(files[getCurrentPos(x, y)].getName()));
      image(img.image, x*imgXSize, y*imgYSize, 150, 150);
    }
  }
  save("zyxzyxzyx"+xSize+"x"+ySize+".png");
}
