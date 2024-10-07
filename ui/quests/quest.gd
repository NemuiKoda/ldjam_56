class_name Quest extends QuestManager

func start_quest() -> void:
	if quest_status == QuestStatus.available:
		quest_status = QuestStatus.started
		quest_box.visible = true
		quest_title.text = quest_name
		quest_content.text = quest_description
		
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		quest_status = QuestStatus.reached_goal
		quest_content.text = quest_goal_text
		
func finish_quest() -> void:
	if quest_status == QuestStatus.reached_goal:
		quest_status = QuestStatus.finished
		quest_box.visible = false
		
