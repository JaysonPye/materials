import { Controller } from "@hotwired/stimulus";
import Papa from "papaparse";
import { newLessonUploadTable } from "./table.ts";
import { addRow } from "../table.ts";
import { createLesson, updateLesson } from "./api.ts";
import { newUploadSummary } from "../summary.ts";

import type { lesson } from "../declarations.d.ts";

export default class extends Controller<HTMLFormElement> {
    static targets = ["fileInput"];
    static values = {
        action: String,
        headers: Array,
    };

    declare readonly fileInputTarget: HTMLInputElement;
    declare readonly actionValue: "create" | "update";
    declare readonly headersValue: string[];

    async displayLessons(e: SubmitEvent){
        e.preventDefault();
        let csv: string | undefined;
        if (this.fileInputTarget?.files){
            csv = await this.fileInputTarget.files[0].text();
        }
        if (csv === undefined){
            alert("Please select a CSV file");
            return;
        }
        const lessons: lesson[] = await this.parseCSV(csv);

        const main = document.querySelector("main");
        if (main){
            main.innerHTML = newLessonUploadTable(this.headersValue);
            main.prepend(newUploadSummary(lessons.length));
        } else {
            alert("Could not find main element");
            return;
        }

        for (const [i, lesson] of lessons.entries()){
            addRow({
                csvRecord: lesson,
                index: i,
                headers: this.headersValue,
                uploadType: "lesson",
            });
        }

        this.uploadLessons(lessons);
    }

    parseCSV(csv: string): Promise<lesson[]> {
        return new Promise((resolve, reject) => {
            Papa.parse<lesson>(csv, {
                header: true,
                skipEmptyLines: true,
                fastMode: false,
                complete(results) {
                    const jsonFields = [
                        'admin_approval', 
                        'curriculum_approval', 
                        'lang_goals'
                    ];
                    results.data.forEach(row => {
                        jsonFields.forEach(field => {
                            if (typeof row[field] === 'string') {
                                try {
                                    row[field] = JSON.parse(row[field] || '{}');
                                } catch (error) {
                                    console.error(`Failed to parse ${field}:`, error);
                                }
                            }
                        });
                    });
    
                    resolve(results.data);
                },
                error(err: Error) {
                    reject(err);
                },
            });
        });
    }
    
    async uploadLessons(lessons: lesson[]) {
        while (lessons.length > 0) {
            const index = lessons.length - 1;
            const delay = new Promise((resolve) => setTimeout(resolve, 500));
            const lesson = lessons.pop();
            if (lesson === undefined) continue;
            this.actionValue === "create"
                ? await createLesson(lesson, index)
                : await updateLesson(lesson, index);
            await delay;
        }
    }
}
