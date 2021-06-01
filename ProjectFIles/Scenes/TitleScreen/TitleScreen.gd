extends CanvasLayer


var current_page
var title_pages := {
	"TITLE": preload("res://Scenes/TitleScreen/TitleControl.tscn"),
	"CONTROLS": preload("res://Scenes/TitleScreen/Controls/ControlsControl.tscn"),
	"SCORE": preload("res://Scenes/TitleScreen/ScoreControl/ScoreControl.tscn")
}


func _ready():
	Globals.TitleScreen = self
	change_page("TITLE")


func change_page(page: String):
	if current_page and is_instance_valid(current_page):
		current_page.queue_free()
	
	if page != "HIDE":
		current_page = title_pages.get(page).instance()
		add_child(current_page)
