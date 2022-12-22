var General = General || {};

General.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}

General.initTimePicker = function(elementId, topInset) {
	var options_fixed = { 
		title: '',
		show:
		function positioning() {
			$(elementId).parent().append($('.wickedpicker'));
			$('.wickedpicker').css({'left':'20px','top':`${topInset}px`});
		}
	};
	$(elementId).wickedpicker(options_fixed);
}




