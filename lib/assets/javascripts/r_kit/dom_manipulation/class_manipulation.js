RKit.prototype.hasClass = function(element, class_name){
	return element.className.match(new RegExp('(\\s|^)' + class_name + '(\\s|$)'));
}

RKit.prototype.addClass = function(element, class_name) {
	if (!r_kit.hasClass(element, class_name)) element.className += " " + class_name;
}

RKit.prototype.removeClass = function(element, class_name) {
	if (r_kit.hasClass(element, class_name)) {
		var reg = new RegExp('(\\s|^)' + class_name + '(\\s|$)');
		element.className = element.className.replace(class_name, ' ');
	}
}
