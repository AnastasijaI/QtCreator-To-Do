# To-Do List Application

## Introduction
This is a simple to-do list application developed using Qt5 and QML with a C++ backend. It allows users to add, edit, delete, and mark tasks as completed.

## Requirements
- Qt5 (including QtQuick and QtQuick.Controls modules)
- qmake (for building the project)
- C++ compiler 

## Building the Application
1. Clone the repository.
2. Open the project in Qt Creator.
3. Configure the project for your target environment.
4. Build the project.

## Running the Application
- Run the application directly from Qt Creator by clicking the Run button.
- Alternatively, execute the generated binary located in the build directory.

## Features
- **Add New Tasks**
    - Users can add new tasks by entering a description in the input field and clicking the "Add Task" button.
    - The "Ok" button remains disabled until a title is entered.
    - Tasks are displayed in a list with their descriptions, but descriptions are visible only when you click on the blue square.
    - You can leave the description empty, but when you click on the blue square it will show "..no description". Also, you can add a description later even if you did not enter it from the beginning.
    
- **Edit Existing Tasks**
    - Users can edit the description and the title of an existing task.
    - Click the edit icon next to the task to open the edit dialog.
    - The edit dialog will be pre-filled with the current title and description of the task.	
    - Modify the task description and save the changes.

- **Delete Tasks**
    - Users can remove tasks from the list.
    - Click the delete icon next to the task to delete it.
    - The task is removed from the list immediately.

- **Mark Tasks as Completed or Uncompleted**
    - Users can mark tasks as completed by checking the checkbox next to the task description.
    - Completed tasks are visually indicated by having their description text crossed out.
    - Users can uncheck the checkbox to mark tasks as uncompleted.

- **Drag and drop**
    - Users can reorder tasks by dragging and dropping them.
    - To initiate drag and drop, press and hold on a task item. A blue rectangle will appear indicating the task is ready to be moved.
    - Drag the task to the desired position and release it to drop.

- **Sort Tasks**
    - Users can sort tasks by title in ascending or descending order.
    - Each click on the "Sort by Title" button toggles the sorting order between ascending and descending.

## C++ Backend
- Task: A class representing a single task with properties for description and completion status.
- TaskModel: A QAbstractListModel subclass managing a list of Task objects. It provides functionality to add, edit, remove, and toggle task completion.
- TaskManager: A QObject class exposing TaskModel and various task-related operations to QML.
