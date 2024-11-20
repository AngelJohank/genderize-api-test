module main

import genderize { genderize_names }

fn main() {
	genders := genderize_names('angel', 'melissa', 'sumin', 'sora')

	for gender in genders {
		if gender != none {
			println(gender)
		}
	}
}
