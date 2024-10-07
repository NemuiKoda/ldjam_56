class_name QuestManager extends Node2D

@onready var quest_box: CanvasLayer = UiManager.get_node("QuestBox")
@onready var quest_title: Label = UiManager.get_node("QuestBox/Background/MarginContainer/QuestBox/QuestTitle")
@onready var quest_content: Label = UiManager.get_node("QuestBox/Background/MarginContainer/QuestBox/QuestContent")
@onready var player = get_node("/root/World/Player")

@export_group("Quest Settings")
@export var quest_name: String
@export var quest_description: String
@export var quest_goal_text: String

enum QuestStatus{
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status: QuestStatus = QuestStatus.available

@export_group("Reward Settings")
@export var reward_amount: int
