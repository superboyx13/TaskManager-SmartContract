//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract TaskManager {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //data type used to show a fixed set of named constants.
    enum Priority {Low, Medium, High}

    //Group related data
    struct Task { 
        string text;
        bool isCompleted;
        Priority level;
        uint256 createdAt;
    }

    event TaskAdded(string addedTask);
    event TaskCompleted(uint256 completedTask);
    event TaskEdited(string editedTask);
    event TasksRemoved();

    // mapping each address to a dynamic list of it's own tasks
    mapping(address => Task[]) public userTasks;

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can call this!");
        _;
    }

    // Takes a single string as its task
    function addTask(string memory _userTasks, uint8 _taskPriority) public {
        require(_taskPriority <= uint8(Priority.High), "Invalid priority level");


            userTasks[msg.sender].push(Task({
            text: _userTasks,
            isCompleted: false,
            level: Priority(_taskPriority),
            createdAt: block.timestamp
            
        }));

        emit TaskAdded(_userTasks);
    }

    //Uses _userIndex to pinpoint the users index of the task
    //require() is used as a condition if the user tries to access a task that doesn't exist.
    function taskCompleted(uint256 _userIndex) public {
        require(_userIndex < userTasks[msg.sender].length, "Unable to reach task that doesn't exist.");
        require(!userTasks[msg.sender][_userIndex].isCompleted, "Task already completed!"); // creates no duplications if task is completed.

        userTasks[msg.sender][_userIndex].isCompleted = true;
        emit TaskCompleted(_userIndex);
    }

    // retrieves the users tasks list.
    function getMyTasks() public view returns(Task[] memory){
        return userTasks[msg.sender];
    }

    //Only owner can resets the users task list.
    function resetTasks(address _user) public onlyOwner {
        delete userTasks[_user];
        emit TasksRemoved();

    }

    // Gets the total count of users completed tasks.
    function getCompletedTasksCount() public view returns(uint256) {
        uint256 count = 0;
        Task[] memory tasks = userTasks[msg.sender];

        for(uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].isCompleted) { 
                count++;
            }
        }

        return count;
    }

    function editTask(string memory _editedTask, uint256 _userIndex) public {
        require(_userIndex < userTasks[msg.sender].length, "Task doesn't exist");
        require(!userTasks[msg.sender][_userIndex].isCompleted, "Can't edit completed task");

        userTasks[msg.sender][_userIndex].text = _editedTask;
        emit TaskEdited(_editedTask);

    }

    function deleteTask(uint256 _userIndex) public {
        require(_userIndex < userTasks[msg.sender].length, "Task doesn't exist");

        uint256 lastIndex = userTasks[msg.sender].length -1;
        userTasks[msg.sender][_userIndex] = userTasks[msg.sender][lastIndex];

        userTasks[msg.sender].pop();

        emit TasksRemoved();
    }

    function getIncompletedTasksCount() public view returns(uint256) {
        uint256 count = 0; 
        Task[] memory tasks = userTasks[msg.sender];

        for (uint256 i = 0; i < tasks.length; i++) {
            if(!tasks[i].isCompleted) {
                count++;
            }
        }

        return count;

    }

}