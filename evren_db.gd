extends Node

signal database_loaded

const RACES_DIR := "res://evren_db/data/races"
const LEGAL_SYSTEMS_DIR := "res://evren_db/data/legal_systems"
const FACTIONS_DIR := "res://evren_db/data/factions"
const ERAS_DIR := "res://evren_db/data/eras"

var races: Dictionary = {}
var legal_systems: Dictionary = {}
var factions: Dictionary = {}
var eras: Array[EraData] = []
var _eras_by_order: Dictionary = {}
var is_loaded: bool = false


func _ready() -> void:
	reload_database()


func reload_database() -> void:
	races.clear()
	legal_systems.clear()
	factions.clear()
	eras.clear()
	_eras_by_order.clear()

	if _is_any_data_dir_empty():
		_seed_initial_data()

	_load_races()
	_load_legal_systems()
	_load_factions()
	_load_eras()

	# Salt-okunur paketlenmiş (exported) ortamda data/ boşsa bellekteki çekirdek veriyi kullan
	if races.is_empty() or legal_systems.is_empty() or factions.is_empty() or eras.is_empty():
		_load_in_memory_fallback()

	eras.sort_custom(func(a: EraData, b: EraData) -> bool:
		return a.chronological_order < b.chronological_order
	)
	for era: EraData in eras:
		_eras_by_order[era.chronological_order] = era

	is_loaded = true
	database_loaded.emit()


func get_race(id: String) -> RaceData:
	if id.is_empty():
		return null
	return races.get(id, null) as RaceData


func get_faction(id: String) -> FactionData:
	if id.is_empty():
		return null
	return factions.get(id, null) as FactionData


func get_legal_system(id: String) -> LegalSystemData:
	if id.is_empty():
		return null
	return legal_systems.get(id, null) as LegalSystemData


func get_era(order: int) -> EraData:
	return _eras_by_order.get(order, null) as EraData


func get_faction_color(id: String) -> Color:
	var faction := get_faction(id)
	if faction == null:
		return Color(0.0, 0.0, 0.0, 0.0)
	return faction.territory_color


func get_all_eras() -> Array[EraData]:
	return eras


func get_origin_type_label(origin_type: RaceData.OriginType) -> String:
	match origin_type:
		RaceData.OriginType.NATIVE_HUMAN:
			return "Temel İnsan Soyu"
		RaceData.OriginType.HUMAN_MUTATION:
			return "İnsan Mutasyonu"
		RaceData.OriginType.HYBRID_FUSION:
			return "Genetik Birleşim (Hibrit)"
		RaceData.OriginType.NON_HUMAN_SENTIENT:
			return "İnsan Dışı İradeli Tür"
	return "Bilinmeyen"


func get_math_base_label(math_base: LegalSystemData.MathBase) -> String:
	match math_base:
		LegalSystemData.MathBase.BASE_10:
			return "10'luk Taban (Mühendislik / Klasik)"
		LegalSystemData.MathBase.BASE_6:
			return "6'lık Taban (Kadim Mars Sistemi)"
		LegalSystemData.MathBase.HYBRID_6_10:
			return "Hibrit 6-10 Matematik"
		LegalSystemData.MathBase.FORMAL_LOGIC:
			return "Biçimsel Mantık / Aksiyomatik"
		LegalSystemData.MathBase.NON_NUMERIC:
			return "Sayısal Olmayan (Nitel / Ruhsal / Sözlü)"
	return "Bilinmeyen"


func get_philosophy_label(philosophy: LegalSystemData.LegalPhilosophy) -> String:
	match philosophy:
		LegalSystemData.LegalPhilosophy.CONTRACT_POSITIVISM:
			return "Deterministik Sözleşme Pozitivizmi"
		LegalSystemData.LegalPhilosophy.CONTEMPLATIVE_STOIC:
			return "Tefekkür ve Sessizlik Stoacılığı"
		LegalSystemData.LegalPhilosophy.DIALECTIC_EPISTEMIC:
			return "Çift-Hatlı Epistemik Diyalektik"
		LegalSystemData.LegalPhilosophy.SPIRITUAL_HIERARCHY:
			return "Ruhsal Hiyerarşi Hukuku"
		LegalSystemData.LegalPhilosophy.AXIOMATIC_PYTHAGOREAN:
			return "Aksiyomatik Pisagorculuk"
		LegalSystemData.LegalPhilosophy.DUAL_COMMUNE_IDEOLOGY:
			return "Jdanovcu Çift Komün İdeolojisi"
		LegalSystemData.LegalPhilosophy.CORPORATE_ARBITRATION:
			return "Mega-Şirket Tahkimi"
		LegalSystemData.LegalPhilosophy.AUTOCRATIC_DECREE:
			return "Otokratik Ferman Düzeni"
		LegalSystemData.LegalPhilosophy.FEUDAL_CUSTOMARY:
			return "Feodal / Sözlü Örfi Hukuk"
	return "Bilinmeyen"


func get_structure_type_label(structure: FactionData.StructureType) -> String:
	match structure:
		FactionData.StructureType.FEUDAL_HOUSE:
			return "Feodal Hanedanlar"
		FactionData.StructureType.TRIBAL_CONFEDERATION:
			return "Kabile Konfederasyonu"
		FactionData.StructureType.MEGACORP:
			return "Mega-Şirket Oligarşisi"
		FactionData.StructureType.DUAL_COMMUNE:
			return "Çift Komün Devleti"
		FactionData.StructureType.AUTOCRACY:
			return "Merkezi Otokrasi"
		FactionData.StructureType.CONFEDERATION:
			return "Konfederasyon"
		FactionData.StructureType.ACADEMY:
			return "Akademik Kast / Akademi"
		FactionData.StructureType.CONCLAVE:
			return "Konklav"
	return "Bilinmeyen"


func _is_any_data_dir_empty() -> bool:
	for dir_path: String in [RACES_DIR, LEGAL_SYSTEMS_DIR, FACTIONS_DIR, ERAS_DIR]:
		if _list_tres_files(dir_path).is_empty():
			return true
	return false


func _seed_initial_data() -> void:
	EvrenDataSeeder.seed_all(false)


func _load_in_memory_fallback() -> void:
	var data: Dictionary = EvrenDataSeeder.build_all_in_memory()
	if races.is_empty():
		races = data.get("races", {})
	if legal_systems.is_empty():
		legal_systems = data.get("legal_systems", {})
	if factions.is_empty():
		factions = data.get("factions", {})
	if eras.is_empty():
		var fallback_eras: Array = data.get("eras", [])
		for era_item in fallback_eras:
			if era_item is EraData:
				eras.append(era_item)


func _list_tres_files(dir_path: String) -> PackedStringArray:
	var files := PackedStringArray()
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return files
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir():
			var clean_name := file_name.trim_suffix(".remap")
			if clean_name.ends_with(".tres"):
				var full_path := dir_path.path_join(clean_name)
				if not files.has(full_path):
					files.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	return files


func _load_races() -> void:
	for path: String in _list_tres_files(RACES_DIR):
		var res := ResourceLoader.load(path)
		if res is RaceData and not res.id.is_empty():
			races[res.id] = res


func _load_legal_systems() -> void:
	for path: String in _list_tres_files(LEGAL_SYSTEMS_DIR):
		var res := ResourceLoader.load(path)
		if res is LegalSystemData and not res.id.is_empty():
			legal_systems[res.id] = res


func _load_factions() -> void:
	for path: String in _list_tres_files(FACTIONS_DIR):
		var res := ResourceLoader.load(path)
		if res is FactionData and not res.id.is_empty():
			factions[res.id] = res


func _load_eras() -> void:
	for path: String in _list_tres_files(ERAS_DIR):
		var res := ResourceLoader.load(path)
		if res is EraData and not res.id.is_empty():
			eras.append(res)
