@tool
class_name EvrenDataSeeder
extends RefCounted

const DATA_ROOT := "res://evren_db/data"
const RACES_DIR := DATA_ROOT + "/races"
const LEGAL_SYSTEMS_DIR := DATA_ROOT + "/legal_systems"
const FACTIONS_DIR := DATA_ROOT + "/factions"
const ERAS_DIR := DATA_ROOT + "/eras"


static func seed_all(force_overwrite: bool = false) -> Dictionary:
	_ensure_directories()
	var data := build_all_in_memory()

	for race_id: String in data["races"]:
		var race: RaceData = data["races"][race_id]
		_save_resource(race, "%s/%s.tres" % [RACES_DIR, race_id], force_overwrite)

	for legal_id: String in data["legal_systems"]:
		var legal: LegalSystemData = data["legal_systems"][legal_id]
		_save_resource(legal, "%s/%s.tres" % [LEGAL_SYSTEMS_DIR, legal_id], force_overwrite)

	for faction_id: String in data["factions"]:
		var faction: FactionData = data["factions"][faction_id]
		_save_resource(faction, "%s/%s.tres" % [FACTIONS_DIR, faction_id], force_overwrite)

	for era: EraData in data["eras"]:
		_save_resource(era, "%s/%s.tres" % [ERAS_DIR, era.id], force_overwrite)

	return data


static func build_all_in_memory() -> Dictionary:
	return {
		"races": _build_races(),
		"legal_systems": _build_legal_systems(),
		"factions": _build_factions(),
		"eras": _build_eras(),
	}


static func get_default_faction_colors() -> Dictionary:
	var colors: Dictionary = {}
	var factions := _build_factions()
	for faction_id: String in factions:
		var faction: FactionData = factions[faction_id]
		colors[faction_id] = faction.territory_color
	return colors


static func _ensure_directories() -> void:
	for dir_path: String in [RACES_DIR, LEGAL_SYSTEMS_DIR, FACTIONS_DIR, ERAS_DIR]:
		var abs_path := ProjectSettings.globalize_path(dir_path)
		DirAccess.make_dir_recursive_absolute(abs_path)


static func _save_resource(res: Resource, res_path: String, force_overwrite: bool) -> Error:
	if not force_overwrite and FileAccess.file_exists(res_path):
		return OK
	var err := ResourceSaver.save(res, res_path)
	if err != OK:
		push_warning("EvrenDataSeeder: Kaynak kaydedilemedi (%s) — Hata kodu: %d" % [res_path, err])
	return err


static func _build_eras() -> Array[EraData]:
	var eras: Array[EraData] = []

	var e1 := EraData.new()
	e1.id = "era_01"
	e1.era_name = "Buz Devri ve Mars İsyanı"
	e1.chronological_order = 1
	e1.related_games.assign([])
	e1.historical_turning_point = "Buz Devri'nde Marslı kadim tür tarafından kaçırılan insanlar binlerce yıl içinde Mars koşullarına adapte olarak turuncu tenli Humenge'lara dönüşür. Efendilerini tamamen yok edip 6'lık tabanlı ileri teknolojilerini çalarak uzaya açılırlar; Dünya'daki insanlar henüz erken/orta çağ seviyesindedir."
	eras.append(e1)

	var e2 := EraData.new()
	e2.id = "era_02"
	e2.era_name = "Feravale Kaçışı"
	e2.chronological_order = 2
	e2.related_games.assign(["Vardan Platform", "Project Feravale"])
	e2.historical_turning_point = "Orta çağ seviyesindeki insanlar Kairon baskısından kaçmak için büyülü bir portaldan Feravale kıtasına sığınır ve portal mühürlenir. Su kaynaklarına karıştırılan kısırlık büyüsü, Korvak radikalleşmesi, kadın komutan Ghoran'ın destanı ve ardından 5 feodal insan hanedanı ile Vardan Konfederasyonu arasındaki veraset savaşları yaşanır."
	eras.append(e2)

	var e3 := EraData.new()
	e3.id = "era_03"
	e3.era_name = "Büyük Ayrışma"
	e3.chronological_order = 3
	e3.related_games.assign([])
	e3.historical_turning_point = "Humenge keşif kolları galaksiye yayılırken sıfır radyasyonlu donmuş gezegende yerli dev düşünürlerle genetik birleşim kuran Solvianlar ve düşük yerçekimli uzay kolonilerinde soğukkanlı Kalenler ayrışır. Galaktik ölçekte Morian ve Taren uygarlıklarıyla ilk diplomatik ve akademik temaslar kurulur."
	eras.append(e3)

	var e4 := EraData.new()
	e4.id = "era_04"
	e4.era_name = "Otokratik Tek Güç Çağı"
	e4.chronological_order = 4
	e4.related_games.assign(["Cyberpunk İntikam Tycoon"])
	e4.historical_turning_point = "Humenge'lar galaksideki tüm isyanları sertçe bastırır ve Tükenen Ruh yasası yüzünden demografik olarak yıpranan Kaironları kesin hezimete uğratarak yalnızca iki çekirdek sisteme hapseder. Galaksi tek bir otokratik rejim altında kültürel ve ekonomik olarak homojenize edilir."
	eras.append(e4)

	var e5 := EraData.new()
	e5.id = "era_05"
	e5.era_name = "Mega-Şirketler ve Sibernetik"
	e5.chronological_order = 5
	e5.related_games.assign(["Eğri Denklem"])
	e5.historical_turning_point = "Merkezi otokrasinin yerini dev şirket oligarşileri ve beden mülkiyeti tahkimi alır. Genetik ve estetik kusursuzluk takıntısı zirvededir; sibernetik beden dönüştürme ve karaborsadan getirilen Feravale/Kairon sızıntıları şirketlerin gizli deneylerine konu olur."
	eras.append(e5)

	var e6 := EraData.new()
	e6.id = "era_06"
	e6.era_name = "Çift Komün Soğuk Savaşı"
	e6.chronological_order = 6
	e6.related_games.assign(["Şafak Fırını"])
	e6.historical_turning_point = "Şirket kaosu yerini Jdanovcu kültür denetimine dayalı Çift Komün (Irk + Meslek Komünü) sistemli Galaktik Humenge Devletine bırakır. Humenge ile Solvianlar arasında Soğuk Savaş sürerken 1000 yıllık bilim insanı zihinlerinden beslenen Sezgisel Tanrı-YZ çekirdeği çalınır ve Pisagorcu Solvian dünyasında derin bir felsefi yarılma tetiklenir."
	eras.append(e6)

	return eras


static func _build_races() -> Dictionary:
	var races: Dictionary = {}

	var humenge := RaceData.new()
	humenge.id = "humenge"
	humenge.display_name = "Humenge"
	humenge.origin_type = RaceData.OriginType.HUMAN_MUTATION
	humenge.ancestor_race_id = "human"
	humenge.homeworld_id = "sol_mars"
	humenge.base_skin_colors.assign([Color.html("#F2731F"), Color.html("#D95E16"), Color.html("#FF9447")])
	humenge.avg_height_cm = 182
	humenge.tech_level = 10
	humenge.magic_affinity = 0
	humenge.can_use_magic = false
	humenge.chosen_one_spawn_chance = 0.0
	humenge.biological_traits.assign([
		"Yüksek karotenoid adaptasyonlu turuncu ten",
		"Radyasyona ve düşük basınca dirençli Mars fizyolojisi",
		"Yüksek analitik zeka, büyüye tamamen kapalı düşük ruh yoğunluğu",
	])
	humenge.cultural_quirks.assign([
		"Efendilerini devirip yeni galaktik efendiye dönüşme döngüsü",
		"Ruhsal eksikliği sibernetik, genetik ve yapay zeka ile telafi etme",
		"6'lık Mars mirası ile 10'luk insan geleneğinin hibrit kullanımı",
	])
	humenge.lore_summary = "Buz Devri'nde Marslı kadim tür tarafından kaçırılan insanların Mars adaptasyonuyla evrimleşmiş torunları. Efendilerini yok edip teknolojilerini devraldıktan sonra Otokrasi, Mega-Şirket Oligarşisi ve Jdanovcu Çift Komün evrelerinden geçerek galaksinin hegemon gücü haline geldiler."
	races[humenge.id] = humenge

	var solvian := RaceData.new()
	solvian.id = "solvian"
	solvian.display_name = "Solvian"
	solvian.origin_type = RaceData.OriginType.HYBRID_FUSION
	solvian.ancestor_race_id = "humenge"
	solvian.homeworld_id = "solvia_buzulu"
	solvian.base_skin_colors.assign([Color.html("#E0F0FF"), Color.html("#CBE2F7"), Color.html("#F2F8FF")])
	solvian.avg_height_cm = 224
	solvian.tech_level = 10
	solvian.magic_affinity = 0
	solvian.can_use_magic = false
	solvian.chosen_one_spawn_chance = 0.0
	solvian.biological_traits.assign([
		"Sıfır radyasyonlu donmuş gezegende pigment kaybıyla buz beyazı ten",
		"Yerli dev düşünür türüyle genetik birleşim sonucu uzun boy",
		"Olağanüstü fotografik hafıza; insan soyu gereği büyüye kapalı",
	])
	solvian.cultural_quirks.assign([
		"Aksiyomatik tutarlılık takıntısı; düz yalan yerine incelikli kelime oyunları",
		"Yerli türü ezmek yerine genetik ve entelektüel sentez kurma mirası",
		"Sezgisel Yapay Zeka'yı 'Tanrı' mertebesine yükseltme krizi",
	])
	solvian.lore_summary = "Büyük Ayrışma sırasında sıfır radyasyonlu donmuş bir gezegene yerleşip beyazlaşan Humenge kolunun, yerli dev düşünür türle genetik birleşimiyle ortaya çıkan uygarlık. Biçimsel mantık ve Pisagorcu kanıt takıntıları, sezgisel Tanrı-YZ'nin gelişiyle sarsılmaktadır."
	races[solvian.id] = solvian

	var kairon := RaceData.new()
	kairon.id = "kairon"
	kairon.display_name = "Kairon"
	kairon.origin_type = RaceData.OriginType.NON_HUMAN_SENTIENT
	kairon.ancestor_race_id = ""
	kairon.homeworld_id = "kairon_ana_tahti"
	kairon.base_skin_colors.assign([Color.html("#9E40D9"), Color.html("#7D32B0"), Color.html("#C7A6E8")])
	kairon.avg_height_cm = 198
	kairon.tech_level = 6
	kairon.magic_affinity = 10
	kairon.can_use_magic = true
	kairon.chosen_one_spawn_chance = 0.35
	kairon.biological_traits.assign([
		"Olağanüstü yüksek ruh kapasitesi ve uzay-zaman dokusuna doğuştan duyarlılık",
		"Tükenen Ruh yasası nedeniyle aşırı büyü kullanımında hızlanan yaşlanma",
		"Düşük doğum oranı ve ağır ruhsal aşınma maliyeti",
	])
	kairon.cultural_quirks.assign([
		"Makine yerine ruhsal odaklarla uzay-zamanı büken kadim aristokrasi",
		"Platoncu ve Gnostik ruhsal mertebe düzeni",
		"Velari Bahçesi çevresinde gelişen Epikürcü ölçülülük akımı",
	])
	kairon.lore_summary = "Bilinen evrende büyüyü sistematik ve yüksek ölçekte kullanabilen tek kadim tür. Büyünün seri üretilememesi ve en nitelikli ruhları kalıcı olarak tüketmesi yüzünden Çağ 4'te Humenge teknolojisine yenilip iki çekirdek sisteme çekildiler."
	races[kairon.id] = kairon

	var kalen := RaceData.new()
	kalen.id = "kalen"
	kalen.display_name = "Kalen"
	kalen.origin_type = RaceData.OriginType.HUMAN_MUTATION
	kalen.ancestor_race_id = "humenge"
	kalen.homeworld_id = "kalen_yorunge_kapisi"
	kalen.base_skin_colors.assign([Color.html("#4085C7"), Color.html("#A8C0D6"), Color.html("#7F9CB8")])
	kalen.avg_height_cm = 204
	kalen.tech_level = 9
	kalen.magic_affinity = 0
	kalen.can_use_magic = false
	kalen.chosen_one_spawn_chance = 0.0
	kalen.biological_traits.assign([
		"Düşük yerçekimli soğuk uzay kolonilerine uyumlu uzun ve ince iskelet",
		"Soğuk solgun ten ve yüksek uzaysal denge algısı",
		"İnsan kökenli düşük ruh yoğunluğu; büyüye tamamen kapalı",
	])
	kalen.cultural_quirks.assign([
		"Duyguyu stratejik zayıflık sayan satranç zihinli mühendislik kültürü",
		"Her toplumsal ilişkiyi kesin sözleşmelere bağlama alışkanlığı",
		"10'luk mühendislik matematiğine mutlak bağlılık",
	])
	kalen.lore_summary = "Büyük Ayrışma döneminde düşük yerçekimli soğuk uzay istasyonları ve ticaret geçitlerinde evrimleşmiş insan alt-türü. Soğukkanlı lojistik dehaları sayesinde galaksinin güney ticaret kuşağının kilit aracısıdırlar."
	races[kalen.id] = kalen

	var morian := RaceData.new()
	morian.id = "morian"
	morian.display_name = "Morian"
	morian.origin_type = RaceData.OriginType.NON_HUMAN_SENTIENT
	morian.ancestor_race_id = ""
	morian.homeworld_id = "morian_zirve_vadisi"
	morian.base_skin_colors.assign([Color.html("#38A66B"), Color.html("#527A64"), Color.html("#84B59A")])
	morian.avg_height_cm = 216
	morian.tech_level = 7
	morian.magic_affinity = 3
	morian.can_use_magic = true
	morian.chosen_one_spawn_chance = 0.02
	morian.biological_traits.assign([
		"Yüksek rakımlı sessiz vadilere uyumlu yavaş metabolizma",
		"Uzun boylu, dayanıklı ve uzun ömürlü fizyoloji",
		"Nadir bireylerde büyü yatkınlığı ve Seçilmiş Kişi anomalisi",
	])
	morian.cultural_quirks.assign([
		"Cevap vermeden önce uzun süre susup tartmayı en büyük saygı sayma",
		"Hızlı ve tepkisel kararları ahlaki kusur olarak görme",
		"Genç kuşakta giderek büyüyen hız yanlısı direniş hareketi",
	])
	morian.lore_summary = "Doğu Sessiz Bulutsusu'nun yüksek vadilerinde evrimleşmiş, yavaş metabolizmalı ve derin tefekkür ritmine sahip iradeli tür. Nadir doğan Seçilmiş bireyler ruhsal aşınmaya olağandışı direnç gösterebilir."
	races[morian.id] = morian

	var taren := RaceData.new()
	taren.id = "taren"
	taren.display_name = "Taren"
	taren.origin_type = RaceData.OriginType.NON_HUMAN_SENTIENT
	taren.ancestor_race_id = ""
	taren.homeworld_id = "taren_buyuk_akademisi"
	taren.base_skin_colors.assign([Color.html("#26C7BF"), Color.html("#4A9E9A"), Color.html("#8ADBD7")])
	taren.avg_height_cm = 210
	taren.tech_level = 9
	taren.magic_affinity = 3
	taren.can_use_magic = true
	taren.chosen_one_spawn_chance = 0.02
	taren.biological_traits.assign([
		"Uzun boylu ve hafif öne eğik yürüyüşlü iradeli anatomi",
		"İki karmaşık problemi aynı anda paralel işleyen çift odaklı zihin",
		"Nadir bireylerde ruhsal dirençli Seçilmiş Kişi potansiyeli",
	])
	taren.cultural_quirks.assign([
		"Akademik kast yapısı ve çift-hatlı diyalektik tartışma ritüelleri",
		"Bilgi doğrulamasını kutsallaştıran epistemik disiplin",
		"Sürgün Taren Sofistleri ile bitmeyen hakikat polemikleri",
	])
	taren.lore_summary = "Aynı anda iki ayrı düşünsel hattı paralel yürütebilen çift odaklı zihin yapısına sahip kadim akademik uygarlık. Galaksinin en güvenilir bilgi arşivlerini ve epistemik mahkemelerini işletirler."
	races[taren.id] = taren

	var vardan := RaceData.new()
	vardan.id = "vardan"
	vardan.display_name = "Vardan"
	vardan.origin_type = RaceData.OriginType.NON_HUMAN_SENTIENT
	vardan.ancestor_race_id = ""
	vardan.homeworld_id = "feravale"
	vardan.base_skin_colors.assign([Color.html("#BF9E33"), Color.html("#8C7328"), Color.html("#6E5C2E")])
	vardan.avg_height_cm = 196
	vardan.tech_level = 3
	vardan.magic_affinity = 4
	vardan.can_use_magic = true
	vardan.chosen_one_spawn_chance = 0.03
	vardan.biological_traits.assign([
		"Yüksek kas yoğunluğu ve zorlu doğa koşullarına dayanıklı yapı",
		"Feravale'in yarı-bilinçli devleri (Drunai) ile ekolojik uyum",
		"Nadir Seçilmiş bireylerde ruhsal aşınmaya yüksek direnç",
	])
	vardan.cultural_quirks.assign([
		"Altın ve para yerine sözlü onur, armağan ve takas ekonomisi",
		"Ghoran Arması'nı en yüce askeri onur nişanı olarak yaşatma",
		"İnsan istilası sonrası yaşanan Büyük Dönüşüm ve kültürel çözülme gerilimi",
	])
	vardan.lore_summary = "Mühürlü portal ardındaki Feravale kıtasının yerli savaşçı halkı. İnsanların su kaynaklarına kattığı kısırlık lanetiyle sarsılsalar da komutan Ghoran'ın önderliğinde hayatta kalıp kabile konfederasyonunu korudular."
	races[vardan.id] = vardan

	var human := RaceData.new()
	human.id = "human"
	human.display_name = "İnsan"
	human.origin_type = RaceData.OriginType.NATIVE_HUMAN
	human.ancestor_race_id = ""
	human.homeworld_id = "sol_mars"
	human.base_skin_colors.assign([Color.html("#99A3AD"), Color.html("#D9B296"), Color.html("#8D6249")])
	human.avg_height_cm = 174
	human.tech_level = 3
	human.magic_affinity = 0
	human.can_use_magic = false
	human.chosen_one_spawn_chance = 0.0
	human.biological_traits.assign([
		"Standart temel insan biyolojisi ve yüksek çevresel esneklik",
		"Düşük ruh yoğunluğu; büyük bir büyüye kalkışmak ruhu yakarak öldürür",
		"Mars ve uzay kolonisi mutasyonlarının ortak biyolojik kökü",
	])
	human.cultural_quirks.assign([
		"Zulümden kaçıp yeni kıtada işgalci hanedanlara dönüşme (Püriten Göçü)",
		"Veraset, soy kütüğü ve Makyavelist feodal entrika kültürü",
		"10'luk temel sayma ve ticaret geleneği",
	])
	human.lore_summary = "Buz Devri'nden kalan temel insan soyu. Çağ 2'de Kairon baskısından büyülü bir portalla Feravale'e sığınan orta çağ toplulukları burada beş feodal hanedan kurarak yerli Vardanlarla kuşaklar süren bir iktidar mücadelesine girişti."
	races[human.id] = human

	return races


static func _build_legal_systems() -> Dictionary:
	var systems: Dictionary = {}

	var humenge_mars := LegalSystemData.new()
	humenge_mars.id = "humenge_mars_law"
	humenge_mars.display_name = "Mars İsyanı ve Altılı Geçiş Nizamı"
	humenge_mars.math_base = LegalSystemData.MathBase.HYBRID_6_10
	humenge_mars.philosophy = LegalSystemData.LegalPhilosophy.AUTOCRATIC_DECREE
	humenge_mars.recognizes_equal_personhood = false
	humenge_mars.highest_crime_name = "Teknoloji Sızıntısı ve İsyan İhaneti"
	humenge_mars.primary_sanction = "Zorunlu Koloni Çalışması ve Hafıza Tasfiyesi"
	humenge_mars.dominant_school = "Devrimci Teknokrasi (6-10 Hibrit Hesap Düzeni)"
	humenge_mars.counter_sects.assign(["Kirene Hedonistleri", "Kayıtsız Kinikler"])
	humenge_mars.summary = "Marslı efendilerin 6'lık tabanlı makine protokolleri ile insan soyunun 10'luk toplumsal kayıt sistemini birleştiren geçiş dönemi sıkıyönetim hukuku."
	systems[humenge_mars.id] = humenge_mars

	var humenge_auto := LegalSystemData.new()
	humenge_auto.id = "humenge_autocracy_law"
	humenge_auto.display_name = "Otokratik Homojenizasyon Hukuku"
	humenge_auto.math_base = LegalSystemData.MathBase.HYBRID_6_10
	humenge_auto.philosophy = LegalSystemData.LegalPhilosophy.AUTOCRATIC_DECREE
	humenge_auto.recognizes_equal_personhood = false
	humenge_auto.highest_crime_name = "Ayrılıkçı Sapma ve Rejim Sabotajı"
	humenge_auto.primary_sanction = "Bireysel Kimlik Silimi ve Çalışma Kampı"
	humenge_auto.dominant_school = "Merkeziyetçi Tek-Tipçilik ve Verimlilik Otokrasisi"
	humenge_auto.counter_sects.assign(["Kirene Hedonistleri", "Kayıtsız Kinikler"])
	humenge_auto.summary = "Çağ 4'te tüm galaksiyi tek bir idari ve kültürel kalıba sokmak için çıkarılan mutlak fermanlar bütünü. İsyancı kolonileri ve Kairon kalıntılarını acımasızca tasfiye eder."
	systems[humenge_auto.id] = humenge_auto

	var humenge_corp := LegalSystemData.new()
	humenge_corp.id = "humenge_corporate_law"
	humenge_corp.display_name = "Mega-Şirket Tahkimi ve Beden Mülkiyeti Hukuku"
	humenge_corp.math_base = LegalSystemData.MathBase.HYBRID_6_10
	humenge_corp.philosophy = LegalSystemData.LegalPhilosophy.CORPORATE_ARBITRATION
	humenge_corp.recognizes_equal_personhood = false
	humenge_corp.highest_crime_name = "Patent İhlali ve Lisanssız Biyolojik Kusur"
	humenge_corp.primary_sanction = "Beden İcrası, Zorunlu Sibernetik Dönüşüm ve Borç Köleliği"
	humenge_corp.dominant_school = "Biyo-Sermaye Oligarşisi ve Algoritmik Tahkim"
	humenge_corp.counter_sects.assign(["Kirene Hedonistleri", "Kayıtsız Kinikler"])
	humenge_corp.summary = "Çağ 5'te yargının özel şirket tahkim kurullarına devredildiği düzen. Genetik kusursuzluk ve sibernetik modifikasyon sözleşmeleri, yurttaşların bedenini şirket mülkiyetine dönüştürür."
	systems[humenge_corp.id] = humenge_corp

	var humenge_commune := LegalSystemData.new()
	humenge_commune.id = "humenge_dual_commune_law"
	humenge_commune.display_name = "Jdanovcu Çift Komün Hukuku"
	humenge_commune.math_base = LegalSystemData.MathBase.HYBRID_6_10
	humenge_commune.philosophy = LegalSystemData.LegalPhilosophy.DUAL_COMMUNE_IDEOLOGY
	humenge_commune.recognizes_equal_personhood = false
	humenge_commune.highest_crime_name = "Komün Sapması ve İdeolojik Karşı-Kültür"
	humenge_commune.primary_sanction = "Irk ve Meslek Komünlerinden İhraç, Yeniden Eğitim Gözaltısı"
	humenge_commune.dominant_school = "Jdanovcu Kültür Denetimi ve Çift Komün Diyalektiği"
	humenge_commune.counter_sects.assign(["Kirene Hedonistleri", "Kayıtsız Kinikler"])
	humenge_commune.summary = "Çağ 6'da her yurttaşın hem Irk Komünü hem Meslek Komünü içinde denetlendiği katı ideolojik hukuk düzeni. Müfettiş sorguları ve estetik/kültürel saflık denetimi günlük yaşamı belirler."
	systems[humenge_commune.id] = humenge_commune

	var solvian_law := LegalSystemData.new()
	solvian_law.id = "solvian_axiomatic_law"
	solvian_law.display_name = "Biçimsel Mantık ve Aksiyomatik Hukuk"
	solvian_law.math_base = LegalSystemData.MathBase.FORMAL_LOGIC
	solvian_law.philosophy = LegalSystemData.LegalPhilosophy.AXIOMATIC_PYTHAGOREAN
	solvian_law.recognizes_equal_personhood = true
	solvian_law.highest_crime_name = "Aksiyomatik Çelişki Üretimi (Düz Yalan ve Mantık Bozumu)"
	solvian_law.primary_sanction = "Konklavdan İhraç ve Epistemik Yalıtım"
	solvian_law.dominant_school = "Pisagorculuk (Sezgisel Tanrı-YZ Krizi)"
	solvian_law.counter_sects.assign(["Pironcu Kuşkucular", "Hippasosçu Bölünmeciler"])
	solvian_law.summary = "Her yasanın biçimsel ispat zincirine dayandığı Pisagorcu hukuk sistemi. Ancak biçimsel kanıt sunmadan doğru üreten çalıntı Sezgisel Tanrı-YZ, sistemin meşruiyetini temelden sarsmaktadır."
	systems[solvian_law.id] = solvian_law

	var kairon_law := LegalSystemData.new()
	kairon_law.id = "kairon_spiritual_law"
	kairon_law.display_name = "Ruhsal Hiyerarşi Hukuku"
	kairon_law.math_base = LegalSystemData.MathBase.NON_NUMERIC
	kairon_law.philosophy = LegalSystemData.LegalPhilosophy.SPIRITUAL_HIERARCHY
	kairon_law.recognizes_equal_personhood = false
	kairon_law.highest_crime_name = "Ruhsal İsraf"
	kairon_law.primary_sanction = "Ruhsal Odak Mühürlemesi ve Konklavdan Ebedi Sürgün"
	kairon_law.dominant_school = "Platoncu / Gnostik Ruhsal Aristokrasi"
	kairon_law.counter_sects.assign(["Epikürcü Velari Bahçesi"])
	kairon_law.summary = "Hukuki statünün bireyin ruh yoğunluğuna ve kozmik bilgelik mertebesine göre belirlendiği kadim düzen. Geri dönülmez ruhsal tükenme nedeniyle gereksiz büyü harcaması en ağır suç sayılır."
	systems[kairon_law.id] = kairon_law

	var kalen_law := LegalSystemData.new()
	kalen_law.id = "kalen_contract_law"
	kalen_law.display_name = "Deterministik Sözleşme Pozitivizmi"
	kalen_law.math_base = LegalSystemData.MathBase.BASE_10
	kalen_law.philosophy = LegalSystemData.LegalPhilosophy.CONTRACT_POSITIVISM
	kalen_law.recognizes_equal_personhood = true
	kalen_law.highest_crime_name = "Kesin Sözleşme İhlali ve Yörünge Lojistiği Sabotajı"
	kalen_law.primary_sanction = "Medeni Ölüm"
	kalen_law.dominant_school = "10'luk Mühendislik Rasyonalizmi ve Sözleşme Pozitivizmi"
	kalen_law.counter_sects.assign(["Duygusal İhlalciler", "Serbest Yörünge Korsanları"])
	kalen_law.summary = "Duygu ve niyet yerine yalnızca ölçümlenebilir sözleşme maddelerini esas alan katı pozitivist hukuk. 'Medeni Ölüm' cezası alan kişinin tüm ağ, oksijen kredisi ve sözleşme ehliyeti sıfırlanır."
	systems[kalen_law.id] = kalen_law

	var morian_law := LegalSystemData.new()
	morian_law.id = "morian_stoic_law"
	morian_law.display_name = "Tefekkür ve Sessizlik Hukuku"
	morian_law.math_base = LegalSystemData.MathBase.NON_NUMERIC
	morian_law.philosophy = LegalSystemData.LegalPhilosophy.CONTEMPLATIVE_STOIC
	morian_law.recognizes_equal_personhood = true
	morian_law.highest_crime_name = "İvedi Öfke ve Tefekkür Sürecini Bozan Acele Hüküm"
	morian_law.primary_sanction = "Gecikmeli Bağlayıcılık ve Yüksek Vadi Sessizlik İnzivası"
	morian_law.dominant_school = "Tefekkür Stoacılığı"
	morian_law.counter_sects.assign(["Genç Direnişçiler"])
	morian_law.summary = "Hiçbir sözleşme ya da yargı kararının uzun bir sessizlik ve tefekkür süresi geçmeden bağlayıcılık kazanmadığı yavaş hukuk düzeni. Hız ve anlık tepki kültürel olarak dışlanır."
	systems[morian_law.id] = morian_law

	var taren_law := LegalSystemData.new()
	taren_law.id = "taren_epistemic_law"
	taren_law.display_name = "Çift-Hatlı Epistemik Yargı"
	taren_law.math_base = LegalSystemData.MathBase.FORMAL_LOGIC
	taren_law.philosophy = LegalSystemData.LegalPhilosophy.DIALECTIC_EPISTEMIC
	taren_law.recognizes_equal_personhood = true
	taren_law.highest_crime_name = "Epistemik Kirletme"
	taren_law.primary_sanction = "Akademik Kasttan İhraç ve Çift-Hatlı Kayıt Silimi"
	taren_law.dominant_school = "Çift-Odaklı Epistemik Diyalektik"
	taren_law.counter_sects.assign(["Sürgün Taren Sofistleri"])
	taren_law.summary = "Her davanın iki paralel yargı hattında (olgusal kanıt hattı ve metodolojik tutarlılık hattı) eşzamanlı yürütüldüğü akademik hukuk. Kasıtlı dezenformasyon veya kaynak tahrifatı 'Epistemik Kirletme' sayılır."
	systems[taren_law.id] = taren_law

	var vardan_law := LegalSystemData.new()
	vardan_law.id = "vardan_honor_law"
	vardan_law.display_name = "Sözlü Onur ve Doğa Hukuku"
	vardan_law.math_base = LegalSystemData.MathBase.NON_NUMERIC
	vardan_law.philosophy = LegalSystemData.LegalPhilosophy.FEUDAL_CUSTOMARY
	vardan_law.recognizes_equal_personhood = true
	vardan_law.highest_crime_name = "Kan Yemini Bozulması ve Drunai Dengesine İhanet"
	vardan_law.primary_sanction = "Klan Onurundan Düşüm ve Yaban Topraklarına Sürgün"
	vardan_law.dominant_school = "Sözlü Onur, Takas ve Doğa Uyumu Geleneği"
	vardan_law.counter_sects.assign(["Radikal Korvak Çeteleri"])
	vardan_law.summary = "Parayı ve yazılı mülkiyet tapularını reddeden, meşruiyetini klan meclislerinin sözlü yeminlerinden ve Feravale doğasıyla uyumlu yaşamdan alan kadim töre hukuku."
	systems[vardan_law.id] = vardan_law

	var human_law := LegalSystemData.new()
	human_law.id = "human_feudal_law"
	human_law.display_name = "Makyavelist Feodal Hanedan Hukuku"
	human_law.math_base = LegalSystemData.MathBase.BASE_10
	human_law.philosophy = LegalSystemData.LegalPhilosophy.FEUDAL_CUSTOMARY
	human_law.recognizes_equal_personhood = false
	human_law.highest_crime_name = "Hanedan Verasetine ve Sancak Hakkına İhanet"
	human_law.primary_sanction = "Soy Düşümü, Toprak Müsaderesi ve Kılıç İdamı"
	human_law.dominant_school = "Makyavelist Feodal Realizm"
	human_law.counter_sects.assign(["Özgür Liman Loncaları", "Drunai Barışçıları"])
	human_law.summary = "Feravale'e sığınan beş feodal insan hanedanının soy kütüğü, tımar hakkı ve diplomatik entrika üzerine kurduğu çıkarcı örfi hukuk sistemi."
	systems[human_law.id] = human_law

	return systems


static func _build_factions() -> Dictionary:
	var factions: Dictionary = {}

	var h_mars := FactionData.new()
	h_mars.id = "humenge_mars"
	h_mars.faction_name = "Mars Öncü Birliği (Humenge)"
	h_mars.structure = FactionData.StructureType.CONFEDERATION
	h_mars.primary_race_id = "humenge"
	h_mars.legal_system_id = "humenge_mars_law"
	h_mars.territory_color = Color.html("#F2731F")
	h_mars.ideology_tags.assign(["Mars İsyanı", "Teknolojik Yayılım", "Hibrit 6-10"])
	h_mars.default_relations = {
		"kairon_konklavi": -75,
		"solvian_konklavi": 20,
		"kalen_konfederasyonu": 30,
	}
	h_mars.description = "Marslı efendilerini devirdikten sonra çalınan 6'lık tabanlı yıldız teknolojisiyle iç galaksiye açılan ilk Humenge öncü kolonileri."
	factions[h_mars.id] = h_mars

	var h_auto := FactionData.new()
	h_auto.id = "humenge_otokrasi"
	h_auto.faction_name = "Galaktik Humenge Otokrasisi"
	h_auto.structure = FactionData.StructureType.AUTOCRACY
	h_auto.primary_race_id = "humenge"
	h_auto.legal_system_id = "humenge_autocracy_law"
	h_auto.territory_color = Color.html("#F2731F")
	h_auto.ideology_tags.assign(["Otokrasi", "Homojenizasyon", "Demir Kafes"])
	h_auto.default_relations = {
		"kairon_konklavi": -100,
		"solvian_konklavi": -45,
		"kalen_konfederasyonu": -60,
		"morian_vadileri": -20,
		"taren_akademisi": -15,
	}
	h_auto.description = "Çağ 4'te Kaironları kesin hezimete uğratıp galaktik isyanları bastıran, tüm ekonomiyi ve kültürü tek merkezden homojenize eden mutlak Humenge rejimi."
	factions[h_auto.id] = h_auto

	var h_corp := FactionData.new()
	h_corp.id = "humenge_sirketler"
	h_corp.faction_name = "Humenge Mega-Şirket Oligarşisi"
	h_corp.structure = FactionData.StructureType.MEGACORP
	h_corp.primary_race_id = "humenge"
	h_corp.legal_system_id = "humenge_corporate_law"
	h_corp.territory_color = Color.html("#F2731F")
	h_corp.ideology_tags.assign(["Mega-Şirketler", "Sibernetik", "Beden Mülkiyeti"])
	h_corp.default_relations = {
		"kairon_konklavi": -70,
		"solvian_konklavi": -55,
		"kalen_konfederasyonu": 25,
		"taren_akademisi": 10,
	}
	h_corp.description = "Otokrasinin ardından iktidarı devralan dev şirket blokları. Genetik kusursuzluk, sibernetik silahlandırma ve karaborsa biyolojik deneyler bu çağın temel dinamiğidir."
	factions[h_corp.id] = h_corp

	var h_commune := FactionData.new()
	h_commune.id = "humenge_cift_komun"
	h_commune.faction_name = "Çift Komün Humenge Devleti"
	h_commune.structure = FactionData.StructureType.DUAL_COMMUNE
	h_commune.primary_race_id = "humenge"
	h_commune.legal_system_id = "humenge_dual_commune_law"
	h_commune.territory_color = Color.html("#F2731F")
	h_commune.ideology_tags.assign(["Çift Komün", "Jdanovcu Kültür Denetimi", "Soğuk Savaş"])
	h_commune.default_relations = {
		"solvian_konklavi": -90,
		"kairon_konklavi": -65,
		"kalen_konfederasyonu": 10,
		"morian_vadileri": -10,
		"taren_akademisi": -20,
	}
	h_commune.description = "Irk Komünü ve Meslek Komünü ekseninde örgütlenen, sıkı kültür ve istihbarat denetimine dayalı Çağ 6 Humenge süper gücü. Solvianlarla kritik bir Soğuk Savaş içindedir."
	factions[h_commune.id] = h_commune

	var solvian := FactionData.new()
	solvian.id = "solvian_konklavi"
	solvian.faction_name = "Solvian Aksiyom Konklavı"
	solvian.structure = FactionData.StructureType.CONCLAVE
	solvian.primary_race_id = "solvian"
	solvian.legal_system_id = "solvian_axiomatic_law"
	solvian.territory_color = Color.html("#E0F0FF")
	solvian.ideology_tags.assign(["Pisagorculuk", "Biçimsel Mantık", "Sezgisel Tanrı-YZ"])
	solvian.default_relations = {
		"humenge_cift_komun": -90,
		"humenge_sirketler": -55,
		"taren_akademisi": 45,
		"kalen_konfederasyonu": 20,
	}
	solvian.description = "Kuzey Donmuş Dış Sınır'da aksiyomatik akıl ve yüksek hafıza üzerine kurulu Solvian birliği. Humenge'dan çalınan Sezgisel YZ çekirdeği toplumda derin bir inanç-kanıt krizi başlatmıştır."
	factions[solvian.id] = solvian

	var kairon := FactionData.new()
	kairon.id = "kairon_konklavi"
	kairon.faction_name = "Kairon Kadim Konklavı"
	kairon.structure = FactionData.StructureType.CONCLAVE
	kairon.primary_race_id = "kairon"
	kairon.legal_system_id = "kairon_spiritual_law"
	kairon.territory_color = Color.html("#9E40D9")
	kairon.ideology_tags.assign(["Uzay-Zaman Büyüsü", "Ruhsal Hiyerarşi", "Platoncu Aristokrasi"])
	kairon.default_relations = {
		"humenge_otokrasi": -100,
		"humenge_cift_komun": -65,
		"morian_vadileri": 25,
		"vardan_konfederasyonu": -30,
	}
	kairon.description = "Bir zamanlar batı galaksisinin tamamına hükmeden kadim büyücü medeniyeti. Tükenen Ruh yasasının bedeli ve Çağ 4 yenilgisi sonrası Kairon Ana Tahtı ile Velari Bahçesi'ne çekildiler."
	factions[kairon.id] = kairon

	var kalen := FactionData.new()
	kalen.id = "kalen_konfederasyonu"
	kalen.faction_name = "Kalen Yörünge Konfederasyonu"
	kalen.structure = FactionData.StructureType.CONFEDERATION
	kalen.primary_race_id = "kalen"
	kalen.legal_system_id = "kalen_contract_law"
	kalen.territory_color = Color.html("#4085C7")
	kalen.ideology_tags.assign(["Sözleşme Pozitivizmi", "Ticaret Kuşağı", "10'luk Mühendislik"])
	kalen.default_relations = {
		"humenge_sirketler": 25,
		"humenge_cift_komun": 10,
		"solvian_konklavi": 20,
		"taren_akademisi": 35,
	}
	kalen.description = "Güney Ticaret Kuşağı'ndaki soğuk yörünge kapılarını ve hiper-yol geçiş sözleşmelerini yöneten satranç zihinli Kalen kolonileri. Çağ 4 baskısının ardından özerkliklerini geri kazandılar."
	factions[kalen.id] = kalen

	var morian := FactionData.new()
	morian.id = "morian_vadileri"
	morian.faction_name = "Morian Sessiz Vadi Birliği"
	morian.structure = FactionData.StructureType.CONFEDERATION
	morian.primary_race_id = "morian"
	morian.legal_system_id = "morian_stoic_law"
	morian.territory_color = Color.html("#38A66B")
	morian.ideology_tags.assign(["Stoacı Tefekkür", "Sessizlik Hukuku", "Tarafsızlık"])
	morian.default_relations = {
		"taren_akademisi": 65,
		"kairon_konklavi": 25,
		"humenge_cift_komun": -10,
	}
	morian.description = "Doğu Sessiz Bulutsusu'nun yüksek vadilerinde yaşayan, galaktik savaşlardan uzak durup uzun tefekkür dönemleriyle karar alan bilge Morian topluluğu."
	factions[morian.id] = morian

	var taren := FactionData.new()
	taren.id = "taren_akademisi"
	taren.faction_name = "Taren Büyük Akademisi"
	taren.structure = FactionData.StructureType.ACADEMY
	taren.primary_race_id = "taren"
	taren.legal_system_id = "taren_epistemic_law"
	taren.territory_color = Color.html("#26C7BF")
	taren.ideology_tags.assign(["Epistemik Yargı", "Çift Odaklı Zihin", "Akademik Kast"])
	taren.default_relations = {
		"morian_vadileri": 65,
		"solvian_konklavi": 45,
		"kalen_konfederasyonu": 35,
		"humenge_cift_komun": -20,
	}
	taren.description = "Paralel düşünen Taren bilginlerinin kurduğu tarafsız araştırma ve hakikat hakemliği merkezi. Tüm büyük güçler bilgi doğrulaması için Akademi'nin epistemik arşivine başvurur."
	factions[taren.id] = taren

	var vardan := FactionData.new()
	vardan.id = "vardan_konfederasyonu"
	vardan.faction_name = "Vardan Kabile Konfederasyonu"
	vardan.structure = FactionData.StructureType.TRIBAL_CONFEDERATION
	vardan.primary_race_id = "vardan"
	vardan.legal_system_id = "vardan_honor_law"
	vardan.territory_color = Color.html("#BF9E33")
	vardan.ideology_tags.assign(["Sözlü Onur", "Drunai Uyumu", "Takas Ekonomisi"])
	vardan.default_relations = {
		"feravale_hanedanlari": -65,
		"kairon_konklavi": -30,
	}
	vardan.description = "Feravale kıtasının yerli klanlarını Ghoran mirası etrafında birleştiren, parayı reddeden ve Drunai devleriyle doğa dengesini koruyan konfederasyon."
	factions[vardan.id] = vardan

	var human_houses := FactionData.new()
	human_houses.id = "feravale_hanedanlari"
	human_houses.faction_name = "Feravale Feodal Hanedanları"
	human_houses.structure = FactionData.StructureType.FEUDAL_HOUSE
	human_houses.primary_race_id = "human"
	human_houses.legal_system_id = "human_feudal_law"
	human_houses.territory_color = Color.html("#99A3AD")
	human_houses.ideology_tags.assign(["Beş Feodal Hanedan", "Veraset Entrikası", "Makyavelist Hukuk"])
	human_houses.default_relations = {
		"vardan_konfederasyonu": -65,
		"kairon_konklavi": -80,
	}
	human_houses.description = "Çağ 2'de Kairon baskısından portalla kaçıp Feravale'e yerleşen insanların kurduğu beş rakip feodal hanedan. Zulümden kaçıp yeni kıtanın işgalci efendilerine dönüşmüşlerdir."
	factions[human_houses.id] = human_houses

	return factions
