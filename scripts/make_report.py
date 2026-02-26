import os
import pandas as pd
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, Table, TableStyle
from reportlab.lib import colors
from reportlab.lib.utils import ImageReader

TITLE = "Reproducible Virtual Screening Pipeline using AutoDock Vina"
SUBTITLE = "End-to-end ligand prep, docking, ranking, and binding pose visualization"
TARGET = "Unknown receptor (PDBQT provided)"
TOP_LIGAND = "F_pos006"
TOP_AFFINITY = "-6.908 kcal/mol (Vina)"

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESULTS_CSV = os.path.join(BASE_DIR, "data_summary", "results.csv")
FIG_PATH = os.path.join(BASE_DIR, "figures", "F_pos006_binding.png")
OUT_PDF = os.path.join(BASE_DIR, "report", "Reproducible_Vina_Screening_Report.pdf")

os.makedirs(os.path.join(BASE_DIR, "report"), exist_ok=True)

def load_results():
    if not os.path.exists(RESULTS_CSV):
        return None
    df = pd.read_csv(RESULTS_CSV)
    if "affinity" in df.columns:
        df["affinity_num"] = pd.to_numeric(df["affinity"], errors="coerce")
        df = df.sort_values("affinity_num", ascending=True)
    return df

def build_pdf():
    styles = getSampleStyleSheet()
    doc = SimpleDocTemplate(
        OUT_PDF,
        pagesize=A4,
        leftMargin=2*cm,
        rightMargin=2*cm,
        topMargin=2*cm,
        bottomMargin=2*cm
    )

    story = []

    story.append(Paragraph(f"<b>{TITLE}</b>", styles["Title"]))
    story.append(Paragraph(SUBTITLE, styles["Normal"]))
    story.append(Spacer(1, 0.5*cm))

    story.append(Paragraph("<b>Objective</b>", styles["Heading2"]))
    story.append(Paragraph(
        "Build a reproducible pipeline that prepares ligands, converts structures to PDBQT, "
        "runs batch docking with AutoDock Vina, ranks candidates, and visualizes top binding poses.",
        styles["Normal"]
    ))
    story.append(Spacer(1, 0.5*cm))

    story.append(Paragraph("<b>Key Result</b>", styles["Heading2"]))
    story.append(Paragraph(
        f"Top-ranked ligand: <b>{TOP_LIGAND}</b><br/>Best docking score: <b>{TOP_AFFINITY}</b>",
        styles["Normal"]
    ))
    story.append(Spacer(1, 0.5*cm))

    # -------- Figure block (safe scaling) --------
    if os.path.exists(FIG_PATH):
        story.append(Paragraph("<b>Figure 1.</b> Top docking pose (PyMOL render).", styles["Normal"]))
        story.append(Spacer(1, 0.3*cm))

        img_reader = ImageReader(FIG_PATH)
        iw, ih = img_reader.getSize()

        max_width = 15 * cm
        max_height = 12 * cm

        aspect = ih / float(iw)

        width = max_width
        height = width * aspect

        if height > max_height:
            height = max_height
            width = height / aspect

        img = Image(FIG_PATH, width=width, height=height)
        story.append(img)
        story.append(Spacer(1, 0.7*cm))
    else:
        story.append(Paragraph("Figure not found.", styles["Normal"]))
        story.append(Spacer(1, 0.5*cm))

    # -------- Table block --------
    df = load_results()
    story.append(Paragraph("<b>Top Ranked Ligands</b>", styles["Heading2"]))
    story.append(Spacer(1, 0.3*cm))

    if df is not None and len(df) > 0:
        view = df[["ligand", "affinity"]].head(10)
        data = [["Ligand", "Affinity (kcal/mol)"]] + view.values.tolist()

        table = Table(data, colWidths=[8*cm, 5*cm])
        table.setStyle(TableStyle([
            ("BACKGROUND", (0,0), (-1,0), colors.lightgrey),
            ("GRID", (0,0), (-1,-1), 0.5, colors.grey),
            ("ALIGN", (1,1), (1,-1), "CENTER"),
            ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
        ]))

        story.append(table)
    else:
        story.append(Paragraph("results.csv not found.", styles["Normal"]))

    story.append(Spacer(1, 1*cm))

    story.append(Paragraph("<b>Reproducibility</b>", styles["Heading2"]))
    story.append(Paragraph(
        "All scripts and minimal inputs are provided in this repository. "
        "Docking can be reproduced by rerunning the batch docking stage "
        "and regenerating results.csv.",
        styles["Normal"]
    ))

    doc.build(story)
    print("PDF generated at:", OUT_PDF)

if __name__ == "__main__":
    build_pdf()
