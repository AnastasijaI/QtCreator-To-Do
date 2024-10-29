#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "task.h"

class TaskModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum {
        TitleRole = Qt::UserRole + 1,
        DescriptionRole,
        CompletedRole
    };

    TaskModel(QObject *parent = nullptr);
    ~TaskModel();

    void addTask(const QString &title, const QString &description);
    void editTask(int index, const QString &title, const QString &description);
    void removeTask(int index);
    void toggleTaskCompletion(int index, bool completed);
    void sortTasksByTitle();
    void refreshModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    QHash<int, QByteArray> roleNames() const override;

private:
    QSqlDatabase m_database;
    QList<Task *> m_tasks;

    void loadTasks();
    void saveTaskCompletion(int taskId, bool completed);
    void saveTaskOrder();
};

#endif // TASKMODEL_H
