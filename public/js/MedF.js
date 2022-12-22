var MedF = MedF || {};


MedF.searchMedByName = function(medNameSearch) {
    return fetch('/SearchMedByName', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({name_search: medNameSearch})
	})
	.then(response => response.json())
}

MedF.fetchAllMed = function() {
	return fetch('/FetchAllMed', {
		method: 'POST'
	}).then(response => response.json())
}

MedF.searchMedByID = function(medID) {
	return fetch('/SearchMedByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({med_id: medID})
	})
	.then(response => response.json())
}

MedF.createMedCard = function(medData) {
	console.log(medData);
	for(const k in medData) {
		if(medData[k] === null || medData[k] === undefined) {
			medData[k] = '-';
		}
	}

	const medCardHtml = `
		<div class="card med-card flex flex-col" style="width: 14rem;" id="med-card-${medData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#med-card-collapse-${medData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${medData.Name}</h5>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="med-card-collapse-${medData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Directions: ${medData.Directions}</li>
					<li class="list-group-item">For: ${medData.NeededFor}</li>
					<li class="list-group-item">Bought From: ${medData.BoughtFrom}</li>
					<li class="list-group-item">Stock: ${medData.Stock}</li>
					<li class="list-group-item">Units: ${medData.UnitPerStock}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateMedModal" onclick="retrieveMedInfo(${medData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${medData.ID}, '${medData.Name}')">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = MedF.htmlToElement(medCardHtml);

	element.addEventListener('hidden.bs.collapse', function () {
		element.classList.remove("row-span-4");
	});
	
	element.addEventListener('show.bs.collapse', function () {
		element.classList.add("row-span-4");

		$(element).find(".collapse-arrow").addClass("arrow-expanded");
	});

	element.addEventListener('hide.bs.collapse', function () {
		$(element).find(".collapse-arrow").removeClass("arrow-expanded");
	});
	
	return element;
}

MedF.refreshMedCard = function(medId) {
	MedF.searchMedByID(medId).then(rowset => {
		const medData = rowset[0];
		$(`#med-card-${medId}`).replaceWith(MedF.createMedCard(medData));
	});
}

MedF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}

