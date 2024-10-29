#include "task.h"

Task::Task(QObject *parent)
    : QObject(parent), m_id(0), m_title(""), m_description(""), m_completed(false)
{
}

Task::Task(int id, const QString &title, const QString &description, bool completed, QObject *parent)
    : QObject(parent), m_id(id), m_title(title), m_description(description), m_completed(completed)
{
}

QString Task::title() const
{
    return m_title;
}

void Task::setTitle(const QString &title)
{
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

QString Task::description() const
{
    return m_description;
}

void Task::setDescription(const QString &description)
{
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

bool Task::completed() const
{
    return m_completed;
}

void Task::setCompleted(bool completed)
{
    if (m_completed != completed) {
        m_completed = completed;
        emit completedChanged();
    }
}

int Task::id() const
{
    return m_id;
}
