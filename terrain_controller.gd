extends Node3D
class_name TerrainController
## This makes the conveyor belt function
## A random set of blocks is chosen and loaded in
## The game continuously consistently moves in the positive Z direction
## When the block set is behind the player, a new one is loaded and added to the end of the conveyor belt

## Holds all the information for all of the blocks
var TerrainBlocks: Array = []
## the terrain blocks you can currently see
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 15.0
## Keep only 4 sets of blocks loaded
@export var num_terrain_blocks = 4
## Path to file holding the terrain block scenes
@export_dir var terrian_blocks_path = "res://Terrain_Folders"

## Getting the sets of blocks and initiating them into the game
func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	_init_blocks(num_terrain_blocks)

## Keep everything from falling into the void
func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

## Adds a certain amount of blocks
## pick the random set of blocks
## The next terrain must attach perfectly to the original
## Each block is added to the scene and the data is collected.
func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			_append_to_far_edge(terrain_belt[block_index-1], block)
		add_child(block)
		terrain_belt.append(block)

## move the blocks forward along the Z-Axis at a set velocity
func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta
		
## The position of the terrain in the game
	if terrain_belt[0].position.z >= terrain_belt[0].mesh.size.y/2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()
## Ensures that new random blocks are loaded and connect seamlessly from one to the next
		var block = TerrainBlocks.pick_random().instantiate()
		_append_to_far_edge(last_terrain, block)
		add_child(block)
		terrain_belt.append(block)
		first_terrain.queue_free()

## This ensures that everything is connected without overlaps
func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2

## This opens a directory that contains all the blocks
## It looks through the files and loads each scene
## This stores the data in all then directory
func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path))

	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass
