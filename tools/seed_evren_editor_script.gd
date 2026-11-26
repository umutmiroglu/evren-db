@tool
extends EditorScript

## Godot Script Editor içinden (File > Run / Ctrl+Shift+X) tüm başlangıç
## .tres kayıtlarını yeniden üretmek için kullanılır.
func _run() -> void:
	var result: Dictionary = EvrenDataSeeder.seed_all(true)
	print("EvrenDB seed tamamlandı -> Irk: %d | Hukuk: %d | Fraksiyon: %d | Çağ: %d" % [
		result["races"].size(),
		result["legal_systems"].size(),
		result["factions"].size(),
		result["eras"].size(),
	])

	if Engine.has_singleton(&"EditorInterface"):
		var editor_interface := Engine.get_singleton(&"EditorInterface")
		if editor_interface and editor_interface.has_method("get_resource_filesystem"):
			editor_interface.get_resource_filesystem().scan()
