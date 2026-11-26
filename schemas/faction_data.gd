@tool
class_name FactionData
extends Resource

enum StructureType {
	FEUDAL_HOUSE,
	TRIBAL_CONFEDERATION,
	MEGACORP,
	DUAL_COMMUNE,
	AUTOCRACY,
	CONFEDERATION,
	ACADEMY,
	CONCLAVE,
}

@export_group("Kimlik ve Yönetim Yapısı")
@export var id: String = ""
@export var faction_name: String = ""
@export var structure: StructureType = StructureType.CONFEDERATION

@export_group("Bağlantılar ve Harita Rengi")
@export var primary_race_id: String = ""
@export var legal_system_id: String = ""
@export var territory_color: Color = Color.WHITE

@export_group("İdeoloji ve Diplomasi")
@export var ideology_tags: Array[String] = []
@export var default_relations: Dictionary = {}
@export_multiline var description: String = ""
