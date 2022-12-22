var MedPlanF = MedPlanF || {};

MedPlanF.searchMedPlansForDogID = function(dogID) {
	return fetch('/SearchMedPlanByDogID', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({DogID: dogID})
	})
	.then(response => response.json())
}

MedPlanF.getMedPlanByID = function(medPlanID) {
	return fetch('/GetMedPlanByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({medPlan_id: medPlanID})
	})
	.then(response => response.json())
}


MedPlanF.createMedPlanCard = function(medPlanData) {
	console.log(medPlanData);
	for(const k in medPlanData) {
		if(medPlanData[k] === null || medPlanData[k] === undefined) {
			medPlanData[k] = '-';
		}
	}

	const medPlanCardHtml = `
		<div class="card medplan-card flex flex-col" style="width: 14rem;" id="medplan-card-${medPlanData.MedPlanID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#medplan-card-collapse-${medPlanData.MedPlanID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${medPlanData.MedName}</h5>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="medplan-card-collapse-${medPlanData.MedPlanID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Start date: ${medPlanData.StartDate}</li>
					<li class="list-group-item">End date: ${medPlanData.EndDate}</li>
					<li class="list-group-item">Dosage Regime: ${medPlanData.DosageRegime}</li>
					<li class="list-group-item">Special Instructions: ${medPlanData.SpecialInstruction}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateMedPlanModal" onclick="retrieveMedPlanInfo(${medPlanData.MedPlanID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle="modal" href="#confirmDeletionModal" onclick="prepareDeletion(${medPlanData.MedPlanID}, '${medPlanData.MedName}')">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = MedPlanF.htmlToElement(medPlanCardHtml);

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

MedPlanF.refreshMedPlanCard = function(medPlanId) {
	MedPlanF.getMedPlanByID(medPlanId).then(rowset => {
		const medPlanData = rowset[0];
		$(`#medplan-card-${medPlanId}`).replaceWith(MedPlanF.createMedPlanCard(medPlanData));
	});
}

MedPlanF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}