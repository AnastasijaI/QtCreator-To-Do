#include "taskmodel.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName("C:/Users/aneil/baseForQml/database.db");

    if (!m_database.open()) {
        qDebug() << "Error: connection with database failed";
    } else {
        qDebug() << "Database: connection ok";

        QSqlQuery query;
        QString createTable = "CREATE TABLE IF NOT EXISTS tasks ("
                              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                              "title TEXT NOT NULL, "
                              "description TEXT, "
                              "completed INTEGER NOT NULL)";
        if (!query.exec(createTable)) {
            qDebug() << "Error: could not create table";
        }

        loadTasks();
    }
}

TaskModel::~TaskModel()
{
    for(int i=0; i<m_tasks.size(); ++i){

        QSqlQuery query;
        query.prepare("DELETE FROM tasks WHERE id = ?");
        query.addBindValue(m_tasks.at(i)->id());
        query.exec();


    }

    for(int i=0; i<m_tasks.size(); ++i){
        QSqlQuery query;
        query.prepare("INSERT INTO tasks (title, description, completed) VALUES (?, ?, ?)");
        query.addBindValue(m_tasks.at(i)->title());
        query.addBindValue(m_tasks.at(i)->description());
        query.addBindValue(m_tasks.at(i)->completed());

        query.exec();
    }
}

void TaskModel::loadTasks() {
    QSqlQuery query("SELECT id, title, description, completed FROM tasks");
    while (query.next()) {
        int id = query.value(0).toInt();
        QString title = query.value(1).toString();
        QString description = query.value(2).toString();
        bool completed = query.value(3).toBool();
        //qDebug() << "COP" << completed;
        m_tasks.append(new Task(id, title, description, completed, this));
    }
}

void TaskModel::addTask(const QString &title, const QString &description) {
    if (title.trimmed().isEmpty()) {
        return;
    }
    QSqlQuery query;
    query.prepare("INSERT INTO tasks (title, description, completed) VALUES (?, ?, ?)");
    query.addBindValue(title);
    query.addBindValue(description);
    query.addBindValue(0);

    if (!query.exec()) {
        qDebug() << "Error: could not insert task";
        return;
    }

    int id = query.lastInsertId().toInt();
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_tasks.append(new Task(id, title, description, false, this));
    endInsertRows();
}

void TaskModel::editTask(int index, const QString &title, const QString &description) {
    if (index < 0 || index >= m_tasks.count()) {
        return;
    }
    Task *task = m_tasks[index];

    QSqlQuery query;
    query.prepare("UPDATE tasks SET title = ?, description = ? WHERE id = ?");
    query.addBindValue(title);
    query.addBindValue(description);
    query.addBindValue(task->id());

    if (!query.exec()) {
        qDebug() << "Error: could not update task";
        return;
    }

    task->setTitle(title);
    task->setDescription(description);

    emit dataChanged(this->index(index), this->index(index), {TitleRole, DescriptionRole});
}

void TaskModel::removeTask(int index) {
    if (index < 0 || index >= m_tasks.count()) {
        return;
    }

    Task *task = m_tasks[index];

    QSqlQuery query;
    query.prepare("DELETE FROM tasks WHERE id = ?");
    query.addBindValue(task->id());

    if (!query.exec()) {
        qDebug() << "Error: could not delete task";
        return;
    }

    beginRemoveRows(QModelIndex(), index, index);
    delete m_tasks[index];
    m_tasks.removeAt(index);
    endRemoveRows();
}

void TaskModel::toggleTaskCompletion(int index, bool completed) {
    if (index < 0 || index >= m_tasks.count()) {
        return;
    }

    m_tasks[index]->setCompleted(completed);
    QSqlQuery query;
    query.prepare("UPDATE tasks SET completed = ? WHERE id = ?");
    query.addBindValue(m_tasks[index]->completed());
    query.addBindValue(m_tasks[index]->id());

    if (!query.exec()) {
        qDebug() << "Error: could not update task completion";
        return;
    }

    emit dataChanged(this->index(index), this->index(index), {CompletedRole});
}

void TaskModel::sortTasksByTitle() {
    beginResetModel();

    QList<Task*> originalOrder = m_tasks;

    std::sort(m_tasks.begin(), m_tasks.end(), [this](Task* a, Task* b) {
        return a->title().toLower() < b->title().toLower();
    });

    int changes = 0;
    for (int i = 0; i < m_tasks.size(); ++i) {
        if (m_tasks[i] != originalOrder[i]) {
            ++changes;
        }
    }

    if(changes == 0){
        std::sort(m_tasks.begin(), m_tasks.end(), [this](Task* a, Task* b) {
            return a->title().toLower() > b->title().toLower();
        });
    }

    endResetModel();
}

int TaskModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    return m_tasks.count();
}

QVariant TaskModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_tasks.count()) {
        return QVariant();
    }

    const Task *task = m_tasks[index.row()];

    switch (role) {
    case TitleRole:
        return task->title();
    case DescriptionRole:
        return task->description();
    case CompletedRole:
        return task->completed();
    default:
        return QVariant();
    }
}

bool TaskModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || index.row() >= m_tasks.count()) {
        return false;
    }

    Task *task = m_tasks[index.row()];

    switch (role) {
    case TitleRole:
        task->setTitle(value.toString());
        break;
    case DescriptionRole:
        task->setDescription(value.toString());
        break;
    case CompletedRole:
        task->setCompleted(value.toBool());
        break;
    default:
        return false;
    }

    emit dataChanged(index, index, {role});
    return true;
}

void  TaskModel::refreshModel(){
    beginResetModel();
    endResetModel();
}

QHash<int, QByteArray> TaskModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[DescriptionRole] = "description";
    roles[CompletedRole] = "completed";
    return roles;
}

