module genderize

import json
import net.http

const genderize_api = 'https://api.genderize.io?name='

pub struct GenderizeResponse {
pub:
	name        string
	gender      ?Gender
	probability f64
	count       u32
}

pub enum Gender {
	male
	female
}

pub fn genderize_names(names ...string) []?GenderizeResponse {
	mut tasks := []thread ?GenderizeResponse{cap: names.len}
	mut responses := []?GenderizeResponse{cap: names.len}

	for name in names {
		tasks << spawn genderize_name(name)
	}

	for task in tasks {
		responses << task.wait()
	}

	return responses
}

pub fn genderize_name(name string) ?GenderizeResponse {
	query := genderize_api + name

	res := http.get(query) or {
		eprintln('error in genderize_name(${name}): ${err}')
		return none
	}

	if res.status().is_error() {
		println('genderize api error: ${res.status_msg}')
		return none
	}

	return json.decode(GenderizeResponse, res.body) or {
		eprintln('error decoding GenderizeResponse, this should never happen')
		exit(0)
	}
}
