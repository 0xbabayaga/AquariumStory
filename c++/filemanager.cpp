#include "filemanager.h"

FileManager::FileManager(QString dir)
{
    workingDirectory = dir;
}

FileManager::~FileManager()
{

}

bool FileManager::scanDirectory(QString fileExt)
{
    QDir scanDir(workingDirectory);
    QStringList imgList = scanDir.entryList(QStringList() << fileExt << fileExt.toUpper(), QDir::Files);

    fileList.clear();

    for (int i = 0; i < imgList.size(); i++)
    {
        FileObj *obj = new FileObj(imgList.at(i), workingDirectory + "/" + imgList.at(i), 0, 0);
        fileList.append(obj);
    }

    return true;
}
