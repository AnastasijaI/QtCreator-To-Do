#ifndef TASKMANAGER_H
#define TASKMANAGER_H

#include <QObject>
#include "taskmodel.h"

class TaskManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(TaskModel* taskModel READ taskModel CONSTANT)

public:
    explicit TaskManager(QObject *parent = nullptr);

    TaskModel* taskModel();

public slots:
    Q_INVOKABLE void addTask(const QString &title, const QString &description);
    Q_INVOKABLE void editTask(int index, const QString &title, const QString &description);
    Q_INVOKABLE void removeTask(int index);
    Q_INVOKABLE void toggleTaskCompletion(int index, bool completed);
    Q_INVOKABLE void sortTasksByTitle();
    Q_INVOKABLE void refreshModel();

private:
    TaskModel m_taskModel;
};

#endif // TASKMANAGER_H
