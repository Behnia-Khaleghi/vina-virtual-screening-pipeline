bg_color white
set ray_opaque_background, off
set ray_shadows, 0
set antialias, 2
set stick_radius, 0.18
set sphere_scale, 0.25
set cartoon_transparency, 0.2

# Load receptor
load receptor.pdbqt, rec
hide everything, rec
show cartoon, rec
color gray70, rec

# Load ligand
load 03_docking/out/F_pos006_out.pdbqt, lig
hide everything, lig
show sticks, lig
color tv_orange, lig

# Select pocket residues (within 4A)
select pocket, byres (rec within 4.0 of lig)
show sticks, pocket
color marine, pocket

# Nice view 
orient lig
zoom lig, 8

show surface, rec within 6 of lig
set transparency, 0.5

bg_color white
set depth_cue, 0
set ray_shadows, off

ray 2400,1800
png figures/F_pos006_binding.png, dpi=300

quit
