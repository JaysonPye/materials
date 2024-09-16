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

export interface approval {
	id: number;
	name: string;
}

export interface lesson {
	id: string;
	admin_approval: approval[]; 
	curriculum_approval: approval[];
	goal: string;
	internal_notes: string;
	level: string;
	released: boolean;
	title: string;
	type: string;
	creator_id: string;
	assigned_editor_id: string;
	created_at: string;
	updated_at: string;
	add_difficulty: string[];
	example_sentences: string[];
	extra_fun: string[];
	instructions: string[];
	large_groups: string[];
    links: Record<string, string>;
	materials: string[];
	notes: string[];
	outro: string[];
	subtype: string;
	topic: string | null;
	vocab: string[];
	intro: string[];
    lang_goals: langGoals;
    interesting_fact: string | null;
    status: string;
    changed_lesson_id: string | null;
    warning: string | null;
}

export interface langGoals {
    sky: string[];
    land: string[];
    galaxy: string[];
}