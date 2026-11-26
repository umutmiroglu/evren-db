@tool
class_name LegalSystemData
extends Resource

enum MathBase {
	BASE_10,
	BASE_6,
	HYBRID_6_10,
	FORMAL_LOGIC,
	NON_NUMERIC,
}

enum LegalPhilosophy {
	CONTRACT_POSITIVISM,
	CONTEMPLATIVE_STOIC,
	DIALECTIC_EPISTEMIC,
	SPIRITUAL_HIERARCHY,
	AXIOMATIC_PYTHAGOREAN,
	DUAL_COMMUNE_IDEOLOGY,
	CORPORATE_ARBITRATION,
	AUTOCRATIC_DECREE,
	FEUDAL_CUSTOMARY,
}

@export_group("Kimlik")
@export var id: String = ""
@export var display_name: String = ""

@export_group("Matematik ve Felsefe")
@export var math_base: MathBase = MathBase.BASE_10
@export var philosophy: LegalPhilosophy = LegalPhilosophy.FEUDAL_CUSTOMARY
@export var recognizes_equal_personhood: bool = true

@export_group("Suç ve Yaptırım")
@export var highest_crime_name: String = ""
@export var primary_sanction: String = ""

@export_group("Ekoller ve Özet")
@export var dominant_school: String = ""
@export var counter_sects: Array[String] = []
@export_multiline var summary: String = ""
