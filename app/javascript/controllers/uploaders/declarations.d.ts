export type status = "Error" | "Invalid" | "Pending" | "Uploaded";

export interface parent {
	name: string;
	email: string;
	password: string;
}

export interface student {
	name: string;
	en_name: string;
	student_id: string;
	level: string;
	school_id: string;
	parent_id: string;
	start_date: string;
	quit_date: string;
	birthday: string;
}

export interface teacher {
	name: string;
	email: string;
	password: string;
}

export interface lesson {
	id: string;
	admin_approval: string;
	curriculum_approval: string;
	goal: string;
	internal_notes: string;
	level: string;
	release: string;
	title: string;
	type: string;
	add_difficulty: string;
	example_sentences: string;
	extra_fun: string;
	instructions: string;
	large_groups: string;
	links: string;
	materials: string;
	notes: string;
	outro: string;
	subtype: string;
	topic: string;
	vocab: string;
	intro: string;
	lang_goals: string;
	interesting_fact: string;
	status: string;
	changed_lesson_id: string;
	warning: string;
}
