extends Node

static func can_run_particles():
	if !is_web():
		return true
		
	if !runs_javascript():
		return false
		
	return !is_chrome()
	
static func is_web():
	return OS.get_name() == "HTML5"
	
static func runs_javascript():
	return OS.has_feature('JavaScript')
	
static func is_chrome():
	return JavaScript.eval("navigator.userAgent.indexOf('AppleWebKit/') !== -1")