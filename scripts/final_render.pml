# --- Clean publication render v2 ---

bg_color white
set ray_opaque_background, 1
set orthoscopic, on
set depth_cue, 0

# Lighting
set ambient, 0.35
set direct, 0.6
set specular, 0.25
set shininess, 20
set ray_shadows, 1
set antialias, 2

# Load receptor
load inputs/receptor.pdbqt, rec
hide everything, rec
show cartoon, rec and not pocket
set cartoon_transparency, 0.85
color gray90, rec

# Load ligand
load inputs/F_pos006_out.pdbqt, lig
hide everything, lig
show sticks, lig
color orange, lig
set stick_radius, 0.32, lig
set specular, 0.35, lig

# Pocket residues
select pocket, byres (rec within 4.0 of lig)
show sticks, pocket
color marine, pocket
set stick_radius, 0.18, pocket

# Pocket surface (subtle)
show surface, pocket
set transparency, 0.80, pocket
color gray75, pocket
set two_sided_lighting, on
set ambient_occlusion_mode, 2
set ambient_occlusion_scale, 10

# Hydrogen bonds
dist hbonds, lig, pocket, 3.2
set dash_color, gray40
set dash_width, 1.5
hide labels, hbonds

# Clean framing
hide cartoon, rec and not pocket
center lig
orient lig
turn y, 10
turn x, -5
zoom lig, 6
clip slab, 14

# Render high quality
ray 2600,2000
png figures/F_pos006_binding.png, dpi=300

quit
