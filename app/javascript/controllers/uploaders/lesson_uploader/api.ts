import { patch, post } from "@rails/request.js";
import type { lesson } from "../declarations.d.ts";

export async function createLesson(
    lesson: lesson,
    index: number,
) {
    return await post(`/lesson_uploads`, {
        body: {
            index: index,
            lesson_upload: {
                id: lesson.id,
                admin_approval: lesson.admin_approval,
                curriculum_approval: lesson.curriculum_approval,
                goal: lesson.goal,
                internal_notes: lesson.internal_notes,
                level: lesson.level,
                released: lesson.released,
                title: lesson.title,
                type: lesson.type,
                creator_id: lesson.creator_id,
                assigned_editor_id: lesson.assigned_editor_id,
                created_at: lesson.created_at,
                updated_at: lesson.updated_at,
                add_difficulty: lesson.add_difficulty,
                example_sentences: lesson.example_sentences,
                extra_fun: lesson.extra_fun,
                instructions: lesson.instructions,
                large_groups: lesson.large_groups,
                links: lesson.links,
                materials: lesson.materials,
                notes: lesson.notes,
                outro: lesson.outro,
                subtype: lesson.subtype,
                topic: lesson.topic,
                vocab: lesson.vocab,
                intro: lesson.intro,
                lang_goals: lesson.lang_goals,
                interesting_fact: lesson.interesting_fact,
                status: lesson.status,
                changed_lesson_id: lesson.changed_lesson_id,
                warning: lesson.warning,
            },
        },
        responseKind: "turbo-stream",
    });
}


export async function updateLesson(
    lesson: lesson,
    index: number,
) {
    return await patch(`/lesson_uploads`,{
    body: {
        index: index,
        lesson_upload: {
            id: lesson.id,
            admin_approval: lesson.admin_approval,
            curriculum_approval: lesson.curriculum_approval,
            goal: lesson.goal,
            internal_notes: lesson.internal_notes,
            level: lesson.level,
            released: lesson.released,
            title: lesson.title,
            type: lesson.type,
            creator_id: lesson.creator_id,
            assigned_editor_id: lesson.assigned_editor_id,
            created_at: lesson.created_at,
            updated_at: lesson.updated_at,
            add_difficulty: lesson.add_difficulty,
            example_sentences: lesson.example_sentences,
            extra_fun: lesson.extra_fun,
            instructions: lesson.instructions,
            large_groups: lesson.large_groups,
            links: lesson.links,
            materials: lesson.materials,
            notes: lesson.notes,
            outro: lesson.outro,
            subtype: lesson.subtype,
            topic: lesson.topic,
            vocab: lesson.vocab,
            intro: lesson.intro,
            lang_goals: lesson.lang_goals,
            interesting_fact: lesson.interesting_fact,
            status: lesson.status,
            changed_lesson_id: lesson.changed_lesson_id,
            warning: lesson.warning,
        },
    },
        responseKind: "turbo-stream",
    });
}
