#ifndef FILESCANNER_H
#define FILESCANNER_H

#include <QObject>
#include <QUrl>

class FileScanner : public QObject
{
    Q_OBJECT
public:
    explicit FileScanner(QObject *parent = nullptr);

    // Hàm này sẽ được gọi từ QML
    Q_INVOKABLE QStringList scanForMediaFiles(const QUrl &folderUrl);
};

#endif // FILESCANNER_H
