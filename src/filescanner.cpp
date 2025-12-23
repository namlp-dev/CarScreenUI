#include "filescanner.h"
#include <QDebug>
#include <QDirIterator>

FileScanner::FileScanner(QObject *parent)
    : QObject(parent)
{}

QStringList FileScanner::scanForMediaFiles(const QUrl &folderUrl)
{
    QStringList mediaFiles;

    // [BƯỚC QUAN TRỌNG NHẤT]: Chuyển URL (file://...) sang Local Path (C:/...)
    // Code mới trước đó thiếu bước này nên không tìm thấy đường dẫn
    QString localPath = folderUrl.toLocalFile();

    if (localPath.isEmpty()) {
        qWarning() << "Invalid folder path or not a local file:" << folderUrl;
        return mediaFiles;
    }

    qDebug() << "Scanning local path:" << localPath;

    // Bộ lọc hỗ trợ cả Nhạc và Video
    QStringList filters;
    filters << "*.mp3" << "*.wav" << "*.mp4";

    // Quét thư mục
    QDirIterator it(localPath,
                    filters,
                    QDir::Files | QDir::NoDotAndDotDot,
                    QDirIterator::Subdirectories);

    while (it.hasNext()) {
        QString filePath = it.next();

        // Chuyển ngược lại thành URL để QML MediaPlayer có thể phát được
        mediaFiles << QUrl::fromLocalFile(filePath).toString();
    }

    qDebug() << "Found" << mediaFiles.count() << "files.";
    return mediaFiles;
}
