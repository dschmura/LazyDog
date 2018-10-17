# Set colors to umich named style

# https://lsa.umich.edu/content/dam/lsa-site-assets/images/images/logos-colors/LSA-Dept-color-palette-options.png
prepend_to_file "app/javascript/#{app_name}/stylesheets/_variables.sass" do
<<-SASS
// BEGIN OF UMICH RECOMMENDED COLORS AND FONTS

$angell_hall_ash: #a79d96
$ann_arbor_amethyst: #702490
$arboretum_blue: #006ab8
$archway_ivy: #7e732f
$blue: #0257aa
$bone: #E4DCD3
$burton_tower_beige: #9b9a6d
$canham_pool_blue: #587abc
$dark_grey: #333333
$deep_blue: #002a5b
$grey: #555555
$heather_blue: #465d85
$hill_brown: #7a121c
$law_quad_stone: #655a52
$lsa_orange: #cc6600
$matthaei_violet: #575294
$observatory_white: #e4e1df
$pea_soup: #886b01
$puma_black: #111b23
$rackham_roof_green: #83b2a8
$rich_heather_blue: #40658f
$ross_school_orange: #ec8000
$semi_deep_blue: #027494
$tappan_red: #b51e0a
$taubman_teal: #00b2b1
$the_rock_gray: #989c97
$um_blue: #00274c
$um_maize: #ffcb05
$umma_tan: #cfc096
$wave_field_green: #bab500

// LSA extra
$huron_river_green: #0c5832
$south_forrest_green: #18453b
$spring_term_green: #00743c

// Fonts reccomended by umich
// https://vpcomm.umich.edu/brand/style-guide/design-principles/typography
// serif
$georgia: 'Georgia'
$times_new_roman: 'Times New Roman'

// sans serif
$arial: 'Arial'
$lucida_grande: 'Lucida Grande'

// web specific
$verdana: 'Verdana'
$tahoma: 'Tahoma'

// END OF UMICH RECOMMENDED COLORS AND FONTS

SASS
end
