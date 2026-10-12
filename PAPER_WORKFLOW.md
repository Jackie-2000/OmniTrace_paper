# OmniTrace paper: workflow, rules, progress

Read this file first in every session that touches the paper. Update "Progress" and "Open items" at the end of the session.

## Rules (from the author)

1. **The author edits the paper remotely (Overleaf, synced through git) and the assistant builds on that. Never write from an old version.**
   - This folder is its own git repository (`origin` = `Jackie-2000/OmniTrace_paper`, branch `main`, linked to Overleaf). It is ignored by the code repository.
   - At the start of every session: `git pull --rebase` (commit or stash local work first), then read what the author changed since the last assistant commit: `git log --stat` and `git diff <last assistant commit>..HEAD`.
   - Read each changed file in full and build on it. Do not restore earlier wording, structure, numbers or figures that the author changed or removed (example: the author set the title on 2026-10-12; keep it).
   - **At the end of every session, after the paper compiles: commit and push** (`git add -A && git commit && git push origin main`). Do not leave finished work unpushed. If the push is rejected, pull with rebase, resolve in favor of the author's text, recompile, and push again.
2. **It is a paper, not a technical report.** Lead with the idea, the research questions and the method. Numbers support an idea; they are not the content. The abstract and introduction carry the idea and the novelty and use few numbers.
3. **Illustrate.** The main text needs figures. Result charts are generated here (matplotlib). Diagrams and qualitative figures that need drawing get a placeholder box and a detailed caption; the author draws them.
   - Palette: `BFDFD2 51999F 4198AC 7BC0CD DBCB92 ECB66C EA9E58 ED8D5A` (OmniTrace = `ED8D5A`).
   - Prefer the results that favor the method, presented fairly (same questions, intervals shown, weak cells stated in the limitations).
4. **Related work** covers the second-pass reading list (`knowledge/related_work.md`): context attribution for LLMs, multimodal attribution, stated temporal evidence, evaluation. Not the old encoder-era interpretability list.
5. **Section 3** stays compact. No separate "why not X" subsection: design arguments live inside the subsection that introduces the choice.
6. **Main text shows only what a research question needs.** Everything else goes to the appendix. A table or figure in the main text must be tied to an RQ below.
7. **Writing order when revising:** experiments and analysis first, then introduction, conclusion, limitations, and the abstract last. Related work is independent.
8. **Wording:** plain words, short sentences, no heavy vocabulary. Format: ACL two-column, 8 pages of main text; limitations, references and appendix do not count.
9. If a result is missing for the story (mostly analyses), tell the author; do not write around it.

## Research questions and where they are answered

| RQ | Question | Main-text evidence |
|---|---|---|
| RQ1 | Do the units read from one generation pass matter causally, in every modality? | Fig. `fig_curves` (both models), sentence columns of Table `tab:baselines` |
| RQ2 | How much of the faithfulness of perturbation methods does one pass recover, and at what cost? | Table `tab:baselines`, Fig. `fig_cost` |
| RQ3 | Does the model cite what it uses? | Fig. `fig_stated`, self-citation rows of Table `tab:baselines` |
| RQ4 | Does one fixed setting transfer to another model? | MiniCPM row of Table `tab:baselines`, Fig. `fig_curves`; variants in the appendix |
| Analysis | What does attention capture and miss? | Fig. `fig_example`, Table `tab:agreement`; size bias, granularity, flagging in the appendix |

## Files

| File | Content | Source |
|---|---|---|
| `sec/0_abstract.tex` … `sec/7_appendix.tex`, `sec/limitation.tex` | text | hand-written |
| `media/table/gen_*.tex` | result tables | `bash analysis/run_paper_models.sh` (do not edit by hand) |
| `media/figure/fig_*.pdf` | result figures | `bash analysis/run_paper_figures.sh` (do not edit by hand; numbers in `analysis/out/paper/fig_numbers.md`) |
| `media/table/stats.tex`, tables inside `sec/5_analysis.tex` and the appendix | small tables | hand-copied from `analysis/out/qwen2.5-omni-7b/*.md` |
| `main.bib`, `related.bib` | references | `related.bib` = copy of `knowledge/related_work.bib`; entries marked VERIFY are not cited |
| old v1 files (`media/table/algo.tex`, `main_res.tex`, `sec/appendix/*`, …) | not included any more | keep or delete, author's choice |

Build: `pdflatex main && bibtex main && pdflatex main && pdflatex main`. Check: no undefined references, limitations start on page 8 or at the top of page 9.

After a sync of `runs/` (AT2, a larger Qwen, …): `bash analysis/run_all.sh` (tables), `bash analysis/run_paper_figures.sh` (figures), recompile, then update the sentences that quote numbers (search the `.tex` files for the old value).

## Figures the author draws (placeholders in the text)

**Figure 1 (teaser), full width.** Three panels, left to right.
- *Left, "Input":* one prompt holding three kinds of sources: a video strip cut into one-second cells with a time axis; an audio waveform cut the same way; a document pool shown as a few text passages `[1] [2] [3]` and two images (a chart, a table). A question below.
- *Middle, "One generation pass":* the decoder writing one sentence. From the highlighted sentence, a fan of thin lines (late-layer attention) lands on the sources; over each source unit a small bar shows the summed mass. Bars over second 14-16 of the video and over one chart are tall and outlined in orange (`ED8D5A`): these are the labelled units. A caption-size note: "sum attention mass per unit, label the units that stand out within their modality".
- *Right, "Output":* the response with each sentence followed by its evidence: `video 14-16 s`, `image 2, text 3`, `audio 3-5 s`, and one sentence marked "no source" (abstains).
- *Bottom strip, "Tested, not assumed":* the same video strip with seconds 14-16 blacked out, an arrow to a falling log-probability bar; next to it the same test with random seconds and a small drop. Optional small inset: the model's own citation `[2.0-4.0s]` pointing to a different place than the orange cells ("stated ≠ used").
- The existing `media/figure/Teaser.pdf` is the v1 figure (shows "Attention, Gradients" and v1 datasets); it is commented out in `main.tex`.

**Optional richer version of the qualitative figure (`fig_example.pdf` is generated and already in the text).** Same heat map, with four or five video frames above the time axis (one inside the human-evidence span, one inside a labelled interval), and the model's self-citation for the same question drawn as a third strip.

## Progress

- 2026-10-12 (a): v2 rewrite of all sections from the v1 draft; generated tables; 8 pages.
- 2026-10-12 (b), pushed: author feedback applied: idea-led abstract and introduction; RQ-organized experiments; evaluation protocol moved to the start of the experiments; "why mass" merged into Section 3.2; the two-model variants table moved to the appendix and the MiniCPM row merged into the main table; four generated figures in the main text (`fig_curves`, `fig_cost`, `fig_stated`, `fig_example`) and one in the appendix (`fig_transfer`); teaser replaced by a placeholder with a design brief.

## Open items

- Title: the author's title ("A Unified Framework for Generation-Time Source Attribution in Omni-Modal LLMs") is in place; the abstract and introduction say "single-pass" and "training-free" more than "unified framework" or "generation-time". Align the wording if the author wants the title's terms to lead.

- AT2 results (running on Qwen2.5-Omni-7B): the row and the point in `fig_cost` appear by themselves; then add the AT2 sentence in `sec/4_exp.tex` (marked by a comment) and remove "AT2 is not yet included" from the limitations.
- Larger Qwen (on hold): add it to `MODELS` in `analysis/paper_models.py`; it becomes one more row in the main table and one more line style in `fig_curves`.
- Figure 1 to be drawn by the author (brief above).
- Check the 2026 arXiv entries in `related.bib` before submission.
- Results that would strengthen the story if available (ask the author): baselines on MiniCPM-o 4.5; audio evidence spans for MMAU (human agreement on audio); a video run with the audio track on (audio vs visual reliance).
