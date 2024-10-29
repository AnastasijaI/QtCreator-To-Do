#include "taskmanager.h"

TaskManager::TaskManager(QObject *parent)
    : QObject(parent) {
}

TaskModel* TaskManager::taskModel() {
    return &m_taskModel;
}

void TaskManager::addTask(const QString &title, const QString &description) {
    m_taskModel.addTask(title, description);
}

void TaskManager::editTask(int index, const QString &title, const QString &description) {
    m_taskModel.editTask(index, title, description);
}

void TaskManager::removeTask(int index) {
    m_taskModel.removeTask(index);
}

void TaskManager::toggleTaskCompletion(int index, bool completed) {
    m_taskModel.toggleTaskCompletion(index, completed);
}

void TaskManager::sortTasksByTitle() {
    m_taskModel.sortTasksByTitle();
}
void TaskManager::refreshModel(){
    m_taskModel.refreshModel();
}
