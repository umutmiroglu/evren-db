@tool
class_name EraData
extends Resource

@export_group("Kronoloji")
@export var id: String = ""
@export var era_name: String = ""
@export_range(1, 6) var chronological_order: int = 1

@export_group("Oyunlar ve Tarihsel Kırılma")
@export var related_games: Array[String] = []
@export_multiline var historical_turning_point: String = ""
