@tool
class_name RaceData
extends Resource

enum OriginType {
	NATIVE_HUMAN,
	HUMAN_MUTATION,
	HYBRID_FUSION,
	NON_HUMAN_SENTIENT,
}

@export_group("Kimlik ve Köken")
@export var id: String = ""
@export var display_name: String = ""
@export var origin_type: OriginType = OriginType.NATIVE_HUMAN
@export var ancestor_race_id: String = ""
@export var homeworld_id: String = ""

@export_group("Biyoloji ve Fizik")
@export var base_skin_colors: Array[Color] = []
@export var avg_height_cm: int = 175
@export var biological_traits: Array[String] = []

@export_group("Teknoloji ve Büyü")
@export_range(1, 10) var tech_level: int = 5
@export_range(0, 10) var magic_affinity: int = 0
@export var can_use_magic: bool = false
@export_range(0.0, 1.0, 0.01) var chosen_one_spawn_chance: float = 0.0

@export_group("Kültür ve Lore")
@export var cultural_quirks: Array[String] = []
@export_multiline var lore_summary: String = ""
