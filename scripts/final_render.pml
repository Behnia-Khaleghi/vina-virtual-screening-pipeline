# --- Clean publication render v2 ---

bg_color white
set ray_opaque_background, 1
set ray_shadows, 0
set antialias, 2
set orthoscopic, on
set depth_cue, 0
set specular, 0.3
set shininess, 25

# Load receptor
load inputs/receptor.pdbqt, rec
hide everything, rec
show cartoon, rec
color gray80, rec
set cartoon_transparency, 0.6

# Load ligand
load inputs/F_pos006_out.pdbqt, lig
hide everything, lig
show sticks, lig
color orange, lig
set stick_radius, 0.22

# Pocket residues only
select pocket, byres (rec within 4.0 of lig)
show sticks, pocket
color marine, pocket

# Hide distant protein parts
hide cartoon, rec and not pocket

# Clean framing
center lig
orient lig
zoom lig, 6
clip slab, 14

ray 2400,1800
png figures/F_pos006_binding.png, dpi=300

quit

