pragma solidity ^0.8.19;

import "forge-std/Test.sol"; 
import "../src/TaskManager.sol";

contract TaskManagerTest is Test {
    TaskManager public taskManager;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        taskManager = new TaskManager();
    }

    function testAddTask() public {
        taskManager.addTask("Buy Milk", 0);
        taskManager.addTask("Wash Car", 1);

        TaskManager.Task[] memory tasks = taskManager.getMyTasks();

        assertEq(tasks.length, 2);
        assertEq(tasks[0].text, "Buy Milk"); 
        assertEq(tasks[1].text, "Wash Car");
        assertEq(tasks[0].isCompleted, false);
        assertEq(tasks[1].isCompleted, false);
    }

    function testAddTaskInvalidPriority() public { 
        vm.expectRevert("Invalid priority level");
        taskManager.addTask("Buy milk", 99);
    }

    function testCompleteTask() public {
        taskManager.addTask("Buy milk", uint8(TaskManager.Priority.Low));
        taskManager.taskCompleted(0);

        TaskManager.Task[] memory tasks = taskManager.getMyTasks(); 

        assertTrue(tasks[0].isCompleted);
    }

    function testCannotCompleteTaskTwice() public {
        taskManager.addTask("Buy milk", uint8(TaskManager.Priority.Low));
        taskManager.taskCompleted(0);

        vm.expectRevert("Task already completed!");
        taskManager.taskCompleted(0);
    }

    function testCannotCompleteNonExistentTask() public {
        vm.expectRevert("Unable to reach task that doesn't exist.");
        taskManager.taskCompleted(0);
    }

    function testEditTask() public {
        taskManager.addTask("Wash Car", uint8(TaskManager.Priority.Low));
        taskManager.editTask("Clean House", 0);

        TaskManager.Task[] memory tasks = taskManager.getMyTasks();

        assertEq(tasks[0].text, "Clean House");
    }

    function testDeleteTask() public {
        taskManager.addTask("Task 1", uint8(TaskManager.Priority.Low));
        taskManager.addTask("Task 2", uint8(TaskManager.Priority.Low));

        taskManager.deleteTask(0);

        TaskManager.Task[] memory tasks = taskManager.getMyTasks();
        
        assertEq(tasks.length, 1);
        assertEq(tasks[0].text, "Task 2");
    }

    function testGetCompletedTasksCount() public {
        taskManager.addTask("Task 1", uint8(TaskManager.Priority.Low));
        taskManager.addTask("Task 2", uint8(TaskManager.Priority.Low));
        taskManager.addTask("Task 3", uint8(TaskManager.Priority.Low));

        taskManager.taskCompleted(0);
        taskManager.taskCompleted(2);

        uint256 count = taskManager.getCompletedTasksCount();
        assertEq(count, 2);
    }

    function testOnlyOwnerCanResetTasks() public {
        taskManager.addTask("Task 1", uint8(TaskManager.Priority.Low));

        vm.prank(user1);
        vm.expectRevert("Only owner can call this!");
        taskManager.resetTasks(address(this));
    }

    function testOwnerCanResetTasks() public {
        vm.prank(user1);
        taskManager.addTask("Task 1", uint8(TaskManager.Priority.Low));

        taskManager.resetTasks(user1);

        vm.prank(user1);
        TaskManager.Task[] memory tasks = taskManager.getMyTasks();
        assertEq(tasks.length, 0);
    }

    function testMultipleUsersSeparateTasks() public {
        vm.prank(user1);
        taskManager.addTask("User 1 Task", uint8(TaskManager.Priority.Low));

        vm.prank(user2);
        taskManager.addTask("User 2 Task", uint8(TaskManager.Priority.High));

        vm.prank(user1);
        TaskManager.Task[] memory user1Tasks = taskManager.getMyTasks();

        vm.prank(user2);
        TaskManager.Task[] memory user2Tasks = taskManager.getMyTasks();

        assertEq(user1Tasks.length, 1);
        assertEq(user2Tasks.length, 1);
        assertEq(user1Tasks[0].text, "User 1 Task");
        assertEq(user2Tasks[0].text, "User 2 Task");
    }
}