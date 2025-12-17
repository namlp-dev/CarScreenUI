#include "filescanner.h"
#include <QDebug>
#include <QDirIterator>

FileScanner::FileScanner(QObject *parent)
    : QObject{parent}
{}

QStringList FileScanner::scanForMp3(const QUrl &folderUrl)
{
    QStringList mp3Files;

    // Chuyển đổi URL (file:///C:/Music) sang đường dẫn cục bộ (C:/Music)
    QString localPath = folderUrl.toLocalFile();

    if (localPath.isEmpty()) {
        qWarning() << "Invalid folder path:" << folderUrl;
        return mp3Files;
    }

    qDebug() << "Scanning folder:" << localPath;

    // Bộ lọc chỉ lấy file .mp3
    QStringList filters;
    filters << "*.mp3";

    // Dùng Iterator để quét thư mục (bao gồm cả thư mục con nếu muốn, ở đây tôi quét cạn)
    QDirIterator it(localPath, filters, QDir::Files, QDirIterator::NoIteratorFlags);

    while (it.hasNext()) {
        QString filePath = it.next();
        // Chuyển đường dẫn file thành URL để MediaPlayer hiểu (file:///...)
        mp3Files.append(QUrl::fromLocalFile(filePath).toString());
    }

    qDebug() << "Found" << mp3Files.count() << "files.";
    return mp3Files;
}
