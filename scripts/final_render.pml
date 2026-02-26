# --- clean publication render (PyMOL) ---

# Quality
bg_color white
set ray_opaque_background, on
set ray_shadows, 0
set antialias, 2
set stick_radius, 0.18
set sphere_scale, 0.25
set cartoon_transparency, 0.35
set orthoscopic, on
set depth_cue, 0
set specular, 0.2
set shininess, 20

# Load receptor
load inputs/receptor.pdbqt, rec
hide everything, rec
show cartoon, rec
color gray70, rec

# Load ligand (top pose)
load inputs/F_pos006_out.pdbqt, lig
hide everything, lig
show sticks, lig
color tv_orange, lig

# Pocket selection (4 Å around ligand)
select pocket, byres (rec within 4.0 of lig)
show sticks, pocket
color marine, pocket

# View: focus on pocket (tight + centered)
center lig
orient pocket
zoom pocket, 7
clip slab, 18

# Render
ray 2400,1800
png figures/F_pos006_binding.png, dpi=300

quit
