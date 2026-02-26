# --- Clean publication render v2 ---

bg_color white
set ray_opaque_background, 1
set orthoscopic, on
set depth_cue, 0

# Lighting
set ambient, 0.35
set direct, 0.6
set specular, 0.4
set shininess, 50
set reflect, 0.1
set ray_shadows, 1
set antialias, 2

# Load receptor
load inputs/receptor.pdbqt, rec
hide everything, rec
show cartoon, rec
color gray85, rec
set cartoon_transparency, 0.75

# Load ligand
load inputs/F_pos006_out.pdbqt, lig
hide everything, lig
show sticks, lig
color orange, lig
set stick_radius, 0.28, lig

# Pocket residues
select pocket, byres (rec within 4.0 of lig)
show sticks, pocket
color marine, pocket
set stick_radius, 0.18, pocket

# Pocket surface (subtle)
show surface, pocket
set transparency, 0.65, pocket
color lightblue, pocket

# Hydrogen bonds
dist hbonds, lig, pocket, 3.2
set dash_color, black
set dash_width, 2
hide labels, hbonds

# Clean framing
hide cartoon, rec and not pocket
center lig
orient lig
zoom lig, 6
clip slab, 14

# Render high quality
ray 2600,2000
png figures/F_pos006_binding.png, dpi=300

quit
