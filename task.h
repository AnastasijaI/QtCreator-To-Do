#ifndef TASK_H
#define TASK_H

#include <QObject>

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(bool completed READ completed WRITE setCompleted NOTIFY completedChanged)

public:
    explicit Task(QObject *parent = nullptr);
    Task(int id, const QString &title, const QString &description, bool completed, QObject *parent = nullptr); // Updated constructor

    QString title() const;
    void setTitle(const QString &title);

    QString description() const;
    void setDescription(const QString &description);

    bool completed() const;
    void setCompleted(bool completed);

    int id() const;

signals:
    void titleChanged();
    void descriptionChanged();
    void completedChanged();

private:
    int m_id;
    QString m_title;
    QString m_description;
    bool m_completed;
};

#endif // TASK_H

