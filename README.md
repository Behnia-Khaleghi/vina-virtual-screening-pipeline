# Virtual Screening Docking Pipeline (AutoDock Vina + RDKit + Meeko)

## Overview
This repository contains an end-to-end molecular docking workflow:
- Ligand preparation with RDKit
- PDBQT conversion (Meeko)
- Batch docking using AutoDock Vina
- Ranking and result summarization (CSV)
- Binding pose visualization with PyMOL

## Outputs
- Ranked docking results: `data_summary/results.csv`
- Binding pose figure (top ligand): `figures/F_pos006_binding.png`
- PyMOL render script: `scripts/final_render.pml`

## Key Result
Top-ranked ligand: **F_pos006**  
Best binding affinity: **~ -6.9 kcal/mol** (Vina)

## Reproduce (minimal)
Inputs are stored in `inputs/`.
Example:
- receptor: `inputs/receptor.pdbqt`
- best pose: `inputs/F_pos006_out.pdbqt`

## Folder structure
- `inputs/` minimal reproducible inputs
- `scripts/` helper scripts (PyMOL)
- `figures/` generated images
- `data_summary/` CSV rankings
- `report/` report PDF/notes (optional)
