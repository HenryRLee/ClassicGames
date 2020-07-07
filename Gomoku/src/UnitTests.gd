extends SceneTree

func assertEquals(a, b, message):
	if a != b:
		print(message + " fails")
		print("Actual:" + str(a))
		print("Expected:" + str(b))
	print("")

var AI = load("res://AI.tscn")
const n = 15

func initGrid():
	var grid = []
	for i in range(n):
		var row = []
		for j in range(n):
			row.append(0)
		grid.append(row)
	return grid

func testAiFive():
	var grid
	grid = initGrid()
	grid[4][7] = 1
	grid[5][7] = 1
	grid[6][7] = 1
	grid[7][7] = 1
	grid[8][7] = 1
	assertEquals(AI.instance().analyzeBoard(grid, Vector2(6, 7), 1), 1000, "Test Five")

func testAiOpenFour():
	var grid
	grid = initGrid()
	grid[4][7] = 1
	grid[5][7] = 1
	grid[6][7] = 1
	grid[7][7] = 1
	assertEquals(AI.instance().analyzeBoard(grid, Vector2(6, 7), 1), 110, "Test open four")

func testAiOpenThree():
	var grid
	grid = initGrid()
	grid[4][7] = 1
	grid[5][7] = 1
	grid[6][7] = 1
	assertEquals(AI.instance().analyzeBoard(grid, Vector2(6, 7), 1), 20, "Test open three")

func testAiHalfFour():
	var grid
	grid = initGrid()
	grid[4][7] = -1
	grid[5][7] = 1
	grid[6][7] = 1
	grid[7][7] = 1
	grid[8][7] = 1
	assertEquals(AI.instance().analyzeBoard(grid, Vector2(6, 7), 1), 15, "Test half four")

func testAiHalfFourPlus():
	var grid
	grid = initGrid()
	grid[4][7] = -1
	grid[5][7] = 1
	grid[7][7] = 1
	grid[8][7] = 1
	grid[6][6] = 1
	grid[6][5] = 1
	grid[6][4] = 1
	grid[6][3] = -1
	grid[6][7] = 1
	assertEquals(AI.instance().analyzeBoard(grid, Vector2(6, 7), 1), 110, "Test half four plus")

func _init():
	print("Start unit test")
	testAiOpenThree()
	testAiOpenFour()
	quit()

